import 'package:me_poupe/helper/database_helper.dart';

class LancamentoTipoCadModel{
  int id;
  String descricao;

  static final String TABLE_NAME = "lancamento_tipo_cad";

  final dbHelper = DatabaseHelper.instance;

  LancamentoTipoCadModel({
    this.id,
    this.descricao,
  });

  factory LancamentoTipoCadModel.fromJson(Map<String, dynamic> json) {
    return LancamentoTipoCadModel(
      id: json['_id'],
      descricao: json['descricao'],
    );
  }


  fetchById(int id) async {
    var linha;
    if( id !=null || id.toString() != "" ) {
      linha = await dbHelper.query(TABLE_NAME, where: "_id = ?", whereArgs: [id]);
      linha = linha.isNotEmpty ? LancamentoTipoCadModel.fromJson(linha.first) : null;
    }
    return linha;
  }

  fetchByAll() async {
    final linhas = await dbHelper.queryAllRows(TABLE_NAME);
    List<LancamentoTipoCadModel> lista = List<LancamentoTipoCadModel>();
    for(var linha in linhas){
      LancamentoTipoCadModel objeto = new LancamentoTipoCadModel.fromJson(linha);
      lista.add(objeto);
    }

    return lista;
  }
}