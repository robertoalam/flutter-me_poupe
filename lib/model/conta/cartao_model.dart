import 'package:me_poupe/helper/database_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/cad/cad_cartao_tipo_model.dart';
import 'package:me_poupe/model/conta/conta_model.dart';

class CartaoModel{
  int id;
  int webserverId;
  ContaModel conta;
  CartaoTipoCadModel tipo;
  String descricao;
  double saldo;
  double limite;
  int diaFechamento;
  int diaVencimento;
  bool selecionado;
  bool deletadoFlag;
  DateTime deletadoData;

  CartaoModel({
    this.id,
    this.webserverId,
    this.conta,
    this.tipo,
    this.descricao,
    this.saldo,
    this.limite,
    this.diaFechamento,
    this.diaVencimento,
    this.selecionado = false,
    this.deletadoFlag = false,
    this.deletadoData,
  });

  final dbHelper = DatabaseHelper.instance;

  static final String tableName = "cartao";

  @override
  String toString() {
    return 'CartaoModel{id: $id, conta: $conta , descricao ${descricao}';
  }

  factory CartaoModel.fromJson(Map<String, dynamic> json) {
    return CartaoModel(id: json['id'] , descricao: json['descricao']);
  }

  fromToDatabase(Map<String, dynamic> linha) async {
    CartaoTipoCadModel tipo = new CartaoTipoCadModel();
    ContaModel conta = new ContaModel();
    conta = await conta.fetchById(int.parse( linha['id_conta'].toString() ) );
    tipo = await tipo.fetchById( int.parse( linha['id_cartao_tipo'].toString() ) );
    return CartaoModel(
      id: linha['id'] ,
      webserverId: linha['id_webserver'] ,
      conta: conta,
      descricao: linha['descricao'] ,
      tipo: tipo ,
      saldo: linha['vl_saldo'],
      limite: linha['vl_limite'],
      diaFechamento: linha['dia_fechamento'],
      diaVencimento: linha['dia_vencimento'],
      deletadoFlag: (linha['st_deleted'] == 1)?true:false,
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'id_webserver':webserverId,
      'id_conta': conta.id,
      'id_cartao_tipo': tipo.id,
      'descricao': descricao,
      'vl_saldo': saldo,
      'vl_limite': limite,
      'dia_fechamento': diaFechamento,
      'dia_vencimento': diaVencimento,
      'st_deleted': (deletadoFlag)?1:null,
      'dt_deleted':(deletadoFlag)? Funcoes.dataAtualEUA(retornarHorario: true).toString() : 0 ,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_conta': conta.id,
      'id_cartao_tipo': tipo.id,
      'descricao': descricao,
      'vl_saldo': saldo,
      'vl_limite': limite,
      'dia_fechamento': diaFechamento,
      'dia_vencimento': diaVencimento,
      'st_deletado':deletadoFlag,
      'dt_deletado':(deletadoFlag)? Funcoes.dataAtualEUA(retornarHorario: true).toString() : null ,
    };
  }

  fetchById(int id) async {
    var linha;
    if( id !=null || id.toString() != "" ) {
      linha = await dbHelper.query(tableName, where: "id = ?", whereArgs: [id]);
      if (linha.isNotEmpty || linha != null) {
        CartaoModel cartao = new CartaoModel();
        return await cartao.fromToDatabase(linha[0]);
      }else{
        return null;
      }
    }else{
      return null;
    }
  }

  fetchByAll() async {
    final linhas = await dbHelper.queryAllRows(tableName);
    List<CartaoModel> lista = List<CartaoModel>();
    if(linhas.isNotEmpty) {
      for (int i = 0; i < linhas.length; i++) {
        CartaoModel objeto = new CartaoModel();
        objeto = await objeto.fromToDatabase(linhas[i]);
        lista.add(objeto);
      }
    }
    return lista;
  }

  // CONSULTA CUSTOMIZADA PARA BUSCAR OS CARTOES PROTEGIDOS DE DELETE OU NAO
  fetchProtected({int protected}) async {
    String where = "";
    var argumentos = [];
    if(protected != null){
      where = "st_protected = ? ";
      argumentos = [protected];
    }else{
      where = "1 = 1";
    }

    final linhas = await dbHelper.query(tableName, where: where, whereArgs: argumentos);
    List<CartaoModel> lista = List<CartaoModel>();
    if(linhas.isNotEmpty) {
      for (int i = 0; i < linhas.length; i++) {
        CartaoModel objeto = new CartaoModel();
        objeto = await objeto.fromToDatabase(linhas[i]);
        lista.add(objeto);
      }
    }
    return lista;
  }

  Future<void> insert() async {
    this.id = null ;
    await dbHelper.insert( tableName , this.toDatabase()  );
  }

  Future udpate() async {
    // var map = this.toMap();
    return await dbHelper.update( tableName , " id " , this.toDatabase() );
  }

  save() async {
    // INSERT
    if(this.id.toString().isEmpty || this.id == 0 || this.id == null){
      await dbHelper.insert(CartaoModel.tableName , toDatabase() );
      // UPDATE
    }else{
      await dbHelper.update(CartaoModel.tableName, "id", toDatabase() );
    }
    return true;
  }
}