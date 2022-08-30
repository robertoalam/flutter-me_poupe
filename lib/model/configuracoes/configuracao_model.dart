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

  static incrementAbertura() async {
    final dbHelper = DatabaseHelper.instance;
    String query = " UPDATE "+TABLE_NAME+" SET valor = valor + 1 WHERE chave = 'no_aberturas' ;";
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

    //CORES
  static const cores = {
	"normal":{
		"appBarFundo":"#9C27B0",
		"background":"#FFFFFF",
		"containerFundo":"#FFFFFF",
		"containerBorda":"#C1C1C1",
		"textoPrimaria":"#000000",
		"sombraPrimaria":"#000000",
		"dividerCor":"#C1C1C1",
	},"escuro": {
    "appBarFundo":"#461151",
    "background":"#000000",
    "containerFundo":"#000000",
    "containerBorda":"#EEEEEE",
    "textoPrimaria":"#FFFFFF",
    "sombraPrimaria":"#FFFFFF",
    "dividerCor":"#FFFFFF",
		}
  };
}

