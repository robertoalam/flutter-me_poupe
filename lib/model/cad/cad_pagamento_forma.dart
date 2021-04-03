import 'package:me_poupe/helper/database_helper.dart';

class PagamentoFormaCadModel{
  int id;
  String descricao;
  String icone;
  int ordem;

  final String TABLE_NAME = "pagamento_forma_cad";
  final dbHelper = DatabaseHelper.instance;

  PagamentoFormaCadModel({this.id, this.descricao,this.icone,this.ordem});


  @override
  String toString() {
    return "${this.descricao}";
  }

  factory PagamentoFormaCadModel.fromJson(Map<String, dynamic> json) {
    return PagamentoFormaCadModel(
        id: json['_id'] ,
      descricao: json['descricao'],
      icone: json['icone'],
      ordem:  json['ordem'] ,
    );
  }

  fetchById(int id) async {
    var linha;
    if( id !=null || id.toString() != "" ) {
      linha = await dbHelper.query(TABLE_NAME, where: "_id = ?", whereArgs: [id]);
      linha = linha.isNotEmpty ? PagamentoFormaCadModel.fromJson(linha.first) : null;
    }
    return linha;
  }

  fetchByAll() async {
    final linhas = await dbHelper.queryAllRows(TABLE_NAME);
    List<PagamentoFormaCadModel> lista = List<PagamentoFormaCadModel>();
    for(var linha in linhas){
      PagamentoFormaCadModel objeto = new PagamentoFormaCadModel.fromJson(linha);
      lista.add(objeto);
    }
    return lista;
  }
}