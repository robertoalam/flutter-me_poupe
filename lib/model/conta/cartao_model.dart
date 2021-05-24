import 'package:me_poupe/helper/database_helper.dart';
import 'package:me_poupe/model/cad/cad_banco_model.dart';
import 'package:me_poupe/model/cad/cad_cartao_tipo_model.dart';
import 'package:me_poupe/model/conta/conta_model.dart';

class CartaoModel{
  int id;
  ContaModel conta;
  CartaoTipoCadModel tipo;
  String descricao;
  double saldo;
  double limite;
  int diaFechamento;
  int diaVencimento;

  CartaoModel({
    this.id,
    this.conta,
    this.tipo,
    this.descricao,
    this.saldo,
    this.limite,
    this.diaFechamento,
    this.diaVencimento
  });

  final dbHelper = DatabaseHelper.instance;
  final String tableName = "cartao";

  @override
  String toString() {
    return 'CartaoModel{id: $id, conta: $conta}';
  }

  factory CartaoModel.fromJson(Map<String, dynamic> json) {
    return CartaoModel(id: json['id'] , descricao: json['descricao']);
  }

  fromDatabase(Map<String, dynamic> linha) async {
    CartaoTipoCadModel tipo = new CartaoTipoCadModel();
    BancoCadModel banco = new BancoCadModel();
    ContaModel conta = new ContaModel();
    banco = await banco.fetchById(int.parse( linha['id_banco'].toString() ) );
    tipo = await tipo.fetchById( int.parse( linha['id_cartao_tipo'].toString() ) );
    return CartaoModel(id: linha['id'] ,conta: conta, descricao: linha['descricao'] , tipo: tipo);
  }

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'id_conta': conta.id,
      'id_cartao_tipo': tipo.id,
      'descricao': descricao,
      'vl_saldo': saldo,
      'vl_limite': limite,
      'dia_fechamento': diaFechamento,
      'dia_vencimento': diaVencimento,
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
    };
  }

  fetchById(int id) async {
    var linha;
    if( id !=null || id.toString() != "" ) {
      linha = await dbHelper.query(tableName, where: "id = ?", whereArgs: [id]);
      if (linha.isNotEmpty || linha != null) {
        CartaoModel cartao = new CartaoModel();
        return await cartao.fromDatabase(linha[0]);
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
        objeto = await objeto.fromDatabase(linhas[i]);
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
        objeto = await objeto.fromDatabase(linhas[i]);
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

  save(){
    // INSERT
    if(this.id.toString().isEmpty || this.id == 0 || this.id == null){
      this.insert();
      // UPDATE
    }else{
      this.udpate();
    }
    return true;
  }
}