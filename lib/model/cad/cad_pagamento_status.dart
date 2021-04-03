import 'package:me_poupe/helper/database_helper.dart';

class PagamentoStatusCad{
  int id;
  String descricao;
  int ordem;

  final String TABLE_NAME = "pagamento_status_cad";
  final dbHelper = DatabaseHelper.instance;

  PagamentoStatusCad({this.id, this.descricao,this.ordem});

  factory PagamentoStatusCad.fromJson(Map<String, dynamic> json) {
    return PagamentoStatusCad(id: json['_id'] , descricao: json['descricao'], ordem: json['ordem']);
  }

  fetchById(int id) async {
    var linha;
    if( id !=null || id.toString() != "" ) {
      linha = await dbHelper.query(TABLE_NAME, where: "_id = ?", whereArgs: [id]);
      linha = linha.isNotEmpty ? PagamentoStatusCad.fromJson(linha.first) : null;
    }
    return linha;
  }

  fetchByAll() async {
    final linhas = await dbHelper.queryAllRows(TABLE_NAME);
    List<PagamentoStatusCad> lista = List<PagamentoStatusCad>();
    for(var linha in linhas){
      PagamentoStatusCad objeto = new PagamentoStatusCad.fromJson(linha);
      lista.add(objeto);
    }
    return lista;
  }
}