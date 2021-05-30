import 'package:me_poupe/helper/database_helper.dart';

class CartaoTipoCadModel{
  int id;
  String descricao;

  static final String TABLE_NAME = "cartao_tipo_cad";
  final dbHelper = DatabaseHelper.instance;

  CartaoTipoCadModel({this.id, this.descricao});

  factory CartaoTipoCadModel.fromJson(Map<String, dynamic> json) {
    return CartaoTipoCadModel(id: json['_id'] , descricao: json['descricao']);
  }

  fetchById(int id) async {
    var linha;
    if( id !=null || id.toString() != "" ) {
      linha = await dbHelper.query(TABLE_NAME, where: "_id = ?", whereArgs: [id]);
      linha = linha.isNotEmpty ? CartaoTipoCadModel.fromJson(linha.first) : null;
    }
    return linha;
  }

  fetchByAll() async {
    final allRows = await dbHelper.queryAllRows(TABLE_NAME);
    List<CartaoTipoCadModel> listaObjeto = List<CartaoTipoCadModel>();
    for(int i = 0 ; i<allRows.length;i++){
      CartaoTipoCadModel _objeto = new CartaoTipoCadModel.fromJson(allRows[i]);
      listaObjeto.add(_objeto);
    }
    return listaObjeto;
  }
}