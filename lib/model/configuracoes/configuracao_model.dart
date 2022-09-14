import 'package:me_poupe/helper/database_helper.dart';

class ConfiguracaoModel{
  
  final String chave ;
  final String valor;
  static final String TABLE_NAME = "configuracoes";

  ConfiguracaoModel({ this.chave, this.valor });

  final dbHelper = DatabaseHelper.instance;
  
  @override
  String toString() { return "${this.chave} ${this.valor}"; }

  get getConfiguracao async {
    List<Map> maps = await dbHelper.queryAllRows(TABLE_NAME);
    return (maps.length > 0) ? maps : null;
  }

  factory ConfiguracaoModel.fromJson(Map<String, dynamic> json) {
    return ConfiguracaoModel(
      chave: json['chave'] ,
      valor: json['valor'] ,
    );
  }

  static getConfiguracoes() async {
    final dbHelper = DatabaseHelper.instance;
    Map<String,dynamic> retorno = Map();
    List<Map<String,dynamic>> maps = await dbHelper.queryAllRows(TABLE_NAME);
    maps.forEach( (elemento) {
      String chave = elemento['chave'].toString();
      String valor = elemento['valor'];
      retorno['${chave.toString()}'] = valor;
    });

    // CONCATENAR COM PROPRIEDADES DE BANCO
    List configDatabase = await ConfiguracaoModel.buscarConfiguracoesDatabase;
    for( ConfiguracaoModel item in configDatabase ){ retorno[item.chave] = item.valor; }
    return retorno;
  }

  static get buscarConfiguracaoAmbiente async {
    ConfiguracaoModel config = new ConfiguracaoModel();
    return (await config.fetchByChave('ambiente')).valor.toString().toLowerCase();    
  }

  Future<ConfiguracaoModel> fetchByChave(String chave) async {
    var linha;
    if( chave !=null || chave.toString() != "" ) {
      linha = await dbHelper.query(TABLE_NAME, where: "chave = ?", whereArgs: [chave]);
      linha = linha.isNotEmpty ? ConfiguracaoModel.fromJson(linha.first) : null;
    }
    return linha;
  }

  static incrementAbertura() async {
    final dbHelper = DatabaseHelper.instance;
    String query = " UPDATE "+TABLE_NAME+" SET valor = valor + 1 WHERE chave = 'no_aberturas' ;";
    return await dbHelper.executar( query );
  }

  static setarDebug(valor) async {
    final dbHelper = DatabaseHelper.instance;
    String query = " UPDATE "+TABLE_NAME+" SET valor = '"+valor.toString()+"' WHERE chave = 'debug' ;";
    return await dbHelper.executar( query );
  }

  static alterarModo(valor) async {
    final dbHelper = DatabaseHelper.instance;
    String query = " UPDATE "+TABLE_NAME+" SET valor = '"+valor+"' WHERE chave = 'modo' ;";
    return await dbHelper.executar( query );
  }

  static alterarExibirSaldo(valor) async {
    final dbHelper = DatabaseHelper.instance;
    String query = "UPDATE "+TABLE_NAME+" SET valor = '"+valor.toString()+"' WHERE chave = 'exibir_saldo' ;";
    return await dbHelper.executar( query );
  }

  static get buscarConfiguracoesDatabase async {
    final dbHelper = DatabaseHelper.instance;
    Map linha = new Map<String,dynamic>();
    List<ConfiguracaoModel> lista = List<ConfiguracaoModel>();
    ConfiguracaoModel objeto = new ConfiguracaoModel.fromJson(linha);

    linha.clear();
    linha['chave'] = 'sqlite_versao';
    linha['valor'] = (await dbHelper.executarQuery( "SELECT sqlite_version();" ))[0].toString();
    objeto = new ConfiguracaoModel.fromJson(linha);
    lista.add( objeto );

    linha['chave'] = 'database_versao';
    linha['valor'] = ( await dbHelper.executarQuery( "PRAGMA user_version;" ))[0]['user_version'].toString();
    objeto = new ConfiguracaoModel.fromJson(linha);
    lista.add( objeto );

    linha.clear();
    linha['chave'] = 'database_schema_versao';
    linha['valor'] = (await dbHelper.executarQuery( "PRAGMA schema_version;" ))[0]['schema_version'].toString();
    objeto = new ConfiguracaoModel.fromJson(linha);
    lista.add( objeto );
    return lista;
  }    


  static final Map<String,dynamic> CONFIGURACAO = {
    'ambientes':[
      {
        'ambiente':'local',
        'constantes':{
          'host_auth':'http://192.168.0.110/i9tecnosul.com.br/auth',          
          'user_name':'teste@gmail.com',
          'user_pass':'1234',
          'host_url':'http://192.168.0.110/i9tecnosul.com.br/mepoupe',
          'ftp_host':'192.168.0.110',
          'ftp_host_user':'mepoupe',
          'ftp_host_pass':'1234',
          'ftp_porta':'21'            
        },
        'rest':{
          'auth_loging':'/api/v1/basic/logon',
          'cidades_buscar':'/api/v1/cidade/get_all',
          'arquivo_send':'/api/v1/arquivo/send',
          'database_send':'/api/v1/database/send',
        }
      },{
        'ambiente':'producao',
        'constantes': {
          'username':'admin',
          'password':'admin',
          'host_url':'https://api.aguiaempresarial.com.br',
        },
        'rest':{
          'auth_loging':'/login/validar',          
          'clientes_buscar':'/clientes/get_all',
          'precos_buscar':'/listas_preco/get_all',
          'produtos_buscar':'/produtos/get_all',
          'estados_buscar':'/estados/get_all',
          'cidades_buscar':'/cidades/get_all',
          'clientes_enviar':'/clientes/salvar_cliente',
          'clientes_save_all':'/clientes/salvar_cliente',
          'pedidos_enviar':'/pedidos/salvar',
          'pedido_enviar':'/pedidos/salvar',
          'pedido_salvar':'/pedidos/salvar_pedido',
          'arquivo_send':'/arquivo/salvar_arquivo',     
          'database_send':'/database/salvar_database',               
        }
      }
    ]
  };

  static get buscarConstantesTodas{ return ConfiguracaoModel.CONFIGURACAO; }
  static get buscarConstantesAmbiente async {
    String _ambiente = (await ConfiguracaoModel.buscarConfiguracaoAmbiente).toString();
    var retorno = ConfiguracaoModel.CONFIGURACAO['ambientes'].where( 
      (item) => item['ambiente'] == _ambiente
    ).toList() as List<Map<String,dynamic>>;
    return retorno[0]['constantes'];
  }

  static get buscarConstantesRest async {
    String _ambiente = (await ConfiguracaoModel.buscarConfiguracaoAmbiente).toString();
    var retorno = ConfiguracaoModel.CONFIGURACAO['ambientes'].where(
      (item) => item['ambiente'].toString() == _ambiente
    ).toList() as List<Map<String,dynamic>>;
    return retorno[0]['rest'];
  }

  //CORES
  static const cores = {
	"normal":{
		"corAppBarFundo":"#9C27B0",
		"corAppBarLetra":"#FFFFFF",
		"background":"#FFFFFF",
		"containerFundo":"#FFFFFF",
		"containerBorda":"#C1C1C1",
		"textoPrimaria":"#000000",
		"sombraPrimaria":"#000000",
		"dividerCor":"#C1C1C1",
	},"escuro": {
    "corAppBarFundo":"#461151",
		"corAppBarLetra":"#C1C1C1",    
    "background":"#000000",
    "containerFundo":"#000000",
    "containerBorda":"#EEEEEE",
    "textoPrimaria":"#FFFFFF",
    "sombraPrimaria":"#FFFFFF",
    "dividerCor":"#FFFFFF",
		}
  };

  static get buscarEstilos async {
    ConfiguracaoModel _config = new ConfiguracaoModel();
    String modo = (await _config.fetchByChave('modo')).valor;
    return ConfiguracaoModel.cores[modo];
  }

  static const icones = {
    {"icone":"acougue-01" , "codigo":0xf146a, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"adicionar-01" , "codigo": 0xe567, "familia":"MaterialIcons"},
    {"icone":"adicionar-02" , "codigo": 0xf11ec, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"agua-01" , "codigo": 0xf058c, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"agua-02" , "codigo": 0xf0e0a, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"ajuda-01" , "codigo": 0xe7b0, "familia":"MaterialIcons"},
    {"icone":"ajuda-02" , "codigo": 0xe7b2, "familia":"MaterialIcons"},
    {"icone":"alimentar-01" , "codigo": 0xe720, "familia":"MaterialIcons"},
    {"icone":"alimentar-02" , "codigo": 0xe19f, "familia":"MaterialIcons"},
    {"icone":"alimentar-03" , "codigo": 0xf025a, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"alimentar-04" , "codigo": 0xf0685, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"arroba-01" , "codigo": 0xf0065, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},

    {"icone":"bebida-01" , "codigo": 0xf02a6, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"bolo-01" , "codigo": 0xe621, "familia":"MaterialIcons"},
    {"icone":"bolo-02" , "codigo": 0xe0b5, "familia":"MaterialIcons"},

    {"icone":"cabelereiro-01" , "codigo": 0xf10ef, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"calendario-01" , "codigo": 0xf00ed, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"carrinho-01" , "codigo": 0xf0110, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"carrinho-02" , "codigo": 0xf0111, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"cartao-credito-01" , "codigo": 0xf0ff0, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"cartao-credito-02" , "codigo": 0xf019c, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"casa-banheiro-01" , "codigo": 0xf09a0, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"casa-banheiro-02" , "codigo": 0xf09a1, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"casa-local-01" , "codigo": 0xf0d15, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"casa-moveis-01" , "codigo": 0xf05bc, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"casa-moveis-02" , "codigo": 0xf156f, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"casa-moveis-03" , "codigo": 0xf05bc, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"celular-01" , "codigo": 0xf011c, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"celular-02" , "codigo": 0xf011e, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"celular-config-01" , "codigo": 0xf0951, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"cinema-01" , "codigo": 0xf050d, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"cheque-01" , "codigo": 0xf019b, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"combustivel-01" , "codigo": 0xf0298, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"comprar-01" , "codigo": 0xf049a, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"comprar-02" , "codigo": 0xf11d5, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"comprar-03" , "codigo": 0xf0076, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"comprar-04" , "codigo": 0xf1181, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"copiar-01" , "codigo": 0xe681, "familia":"MaterialIcons"},

    {"icone":"dinheiro-01" , "codigo": 0xf0116, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"deletar-01" , "codigo": 0xe3b7, "familia":"MaterialIcons"},
    {"icone":"dente-01" , "codigo": 0xf57f, "familia":"FontAwesomeSolid" , "pacote":"font_awesome_flutter"},
    {"icone":"doce-01" , "codigo": 0xf00e9, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},

    {"icone":"eletro-01" , "codigo": 0xf109f, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"eletro-02" , "codigo": 0xf072a, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"eletro-generico-01" , "codigo": 0xe6f1, "familia":"MaterialIcons" },
    {"icone":"escritorio-01" , "codigo": 0xf095f, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"esporte-academia-01" , "codigo": 0xf01e6, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"esporte-academia-pessoa-01" , "codigo": 0xf115d, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"esporte-futebol-01" , "codigo": 0xf04b8, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"esporte-futebol-02" , "codigo": 0xf0834, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"estacionamento-01" , "codigo": 0xf0b6e, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"estrelar-01" , "codigo": 0xea22, "familia":"MaterialIcons"},
    {"icone":"estrelar-02" , "codigo": 0xea23, "familia":"MaterialIcons"},

    {"icone":"favoritar-01" , "codigo": 0xe721, "familia":"MaterialIcons"},
    {"icone":"favoritar-02" , "codigo": 0xe722, "familia":"MaterialIcons"},
    {"icone":"flag-01" , "codigo": 0xe751, "familia":"MaterialIcons"},
    {"icone":"flag-02" , "codigo": 0xe1c8, "familia":"MaterialIcons"},
    {"icone":"filtrar-01" , "codigo": 0xe73d, "familia":"MaterialIcons"},
    {"icone":"filtrar-02" , "codigo": 0xe1b6, "familia":"MaterialIcons"},

    {"icone":"help-01" , "codigo": 0xe7b0, "familia":"MaterialIcons"},
    {"icone":"help-02" , "codigo": 0xe7b2, "familia":"MaterialIcons"},
    {"icone":"home-01" , "codigo": 0xe7ba, "familia":"MaterialIcons"},
    {"icone":"home-02" , "codigo": 0xe59e, "familia":"MaterialIcons"},
    {"icone":"home-03" , "codigo": 0xf1159, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"home-04" , "codigo": 0xf115a, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},

    {"icone":"lazer-01" , "codigo": 0xf1545, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"luz-01" , "codigo": 0xf0335, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"luz-02" , "codigo": 0xf0e4f, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},

    {"icone":"mala-01" , "codigo": 0xf158b, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"material-construcao-01" , "codigo": 0xe67a, "familia":"MaterialIcons"},
    {"icone":"money-01" , "codigo": 0xe5c6, "familia":"MaterialIcons"},
    {"icone":"money-02" , "codigo": 0xf0116, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"money-03" , "codigo": 0xf067a, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},

    {"icone":"notebook-01" , "codigo": 0xe7ff, "familia":"MaterialIcons"},

    {"icone":"pao-01" , "codigo": 0xf0f3e, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"parque-diversoes-01" , "codigo": 0xf0ea4, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"pedagio-01" , "codigo": 0xf0b6e, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"pessoa-saude-01" , "codigo": 0xf0a42, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"pessoa-bebe-01" , "codigo": 0xf138b, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"pessoa-professor-01" , "codigo": 0xf0890, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"pets-01" , "codigo": 0xf0a43, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"pets-02" , "codigo": 0xf011b, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"pets-99" , "codigo": 0xf03e9, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"piscina-01" , "codigo": 0xf0606, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"predio-01" , "codigo": 0xf0991, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"predio-02" , "codigo": 0xf151f, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},

    {"icone":"roupa-01" , "codigo": 0xf02c8, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},

    {"icone":"saude-01" , "codigo": 0xf02e0, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"saude-02" , "codigo": 0xf0ff7, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"saude-03" , "codigo": 0xf04d9, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"saude-local-01" , "codigo": 0xf02e1, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"saude-gps-01" , "codigo": 0xf02e2, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"saude-remedio-01" , "codigo": 0xf0391, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"saude-remedio-02" , "codigo": 0xf0402, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"saude-pasta-01" , "codigo": 0xf06ef, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"saude-pessoa-01" , "codigo": 0xf0a42, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"servicos-01" , "codigo": 0xe6a8, "familia":"MaterialIcons"},
    {"icone":"seguradora-01" , "codigo": 0xf4c0, "familia":"FontAwesomeSolid" , "pacote":"font_awesome_flutter"},
    {"icone":"seta-baixo-01" , "codigo": 0xf0792, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"seta-baixo-02" , "codigo": 0xf0796, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"seta-cima-01" , "codigo": 0xf0795, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"seta-cima-02" , "codigo": 0xf0799, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"seta-menu-cima-01" , "codigo": 0xf0360, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"seta-menu-baixo-01" , "codigo": 0xf035d, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"seta-menu-esquerda-01" , "codigo": 0xf035e, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"seta-menu-direita-01" , "codigo": 0xf035f, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"school-01" , "codigo": 0xe9a8, "familia":"MaterialIcons"},
    {"icone":"school-02" , "codigo": 0xe3e6, "familia":"MaterialIcons"},
    {"icone":"school-03" , "codigo": 0xe789, "familia":"MaterialIcons"},
    {"icone":"school-04" , "codigo": 0xf1186, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"school-05" , "codigo": 0xf1187, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"school-06" , "codigo": 0xf14e7, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"school-07" , "codigo": 0xf14e9, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},

    {"icone":"teatro-01" , "codigo": 0xf630, "familia":"FontAwesomeSolid" , "pacote":"font_awesome_flutter"},
    {"icone":"televisao-01" , "codigo": 0xf07f4, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"trabalhar-01" , "codigo": 0xeaf4, "familia":"MaterialIcons" },
    {"icone":"trabalhar-02" , "codigo": 0xeaf6, "familia":"MaterialIcons" },
    {"icone":"trabalhar-03" , "codigo": 0xeaf5, "familia":"MaterialIcons" },
    {"icone":"trabalhar-04" , "codigo": 0xe520, "familia":"MaterialIcons" },
    {"icone":"transporte-01" , "codigo": 0xf0bd8, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"transporte-02" , "codigo": 0xf00e7, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"transporte-03" , "codigo": 0xf001d, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},
    {"icone":"torneira-01" , "codigo": 0xe005, "familia":"FontAwesomeSolid" , "pacote":"font_awesome_flutter"},

    {"icone":"ventilador-01" , "codigo": 0xf0210, "familia":"Material Design Icons" , "pacote":"material_design_icons_flutter"},

  };
}

