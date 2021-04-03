import 'package:me_poupe/helper/database_helper.dart';

class CategoriaCadModel{

  final int id;
  final int idPai;
  final String descricao;
//  final Icon icone;
//  final IconData icone;
  final String icone;
  final int order;

  final dbHelper = DatabaseHelper.instance;

  static final String TABLE_NAME = "categoria_cad";

  CategoriaCadModel({this.id, this.idPai, this.descricao, this.icone,this.order});


  @override
  String toString() {
    return "${id.toString()} ${idPai.toString()} ${icone.toString()}";
  }

  factory CategoriaCadModel.fromJson(Map<String, dynamic> json) {
    return CategoriaCadModel(
      id: json['_id'],
      idPai: json['id_pai'],
      descricao: json['descricao'],
      icone: json['icone'],
      order: json['order'],
    );
  }

  factory CategoriaCadModel.getDestaque(int destaque) {
    final dbHelper = DatabaseHelper.instance;
    var linha;
    if( destaque != null || destaque.toString() != "" ) {
      linha = dbHelper.query(TABLE_NAME, where: "destaque = ?", whereArgs: [destaque],orderBy: " ORDER BY ordem_destaque DESC");
      linha = linha.isNotEmpty ? CategoriaCadModel.fromJson(linha.first) : null;
    }
    return linha;
  }

  fetchByDestaque(int destaque) async {
    var linhas;
    List<CategoriaCadModel> lista = List<CategoriaCadModel>();
    if( destaque !=null || destaque.toString() != "" ) {
      linhas = await dbHelper.query(TABLE_NAME, where: "destaque = ?", whereArgs: [destaque]);
      for(int i=0;i < linhas.length ; i++){
        CategoriaCadModel objeto = new CategoriaCadModel.fromJson(linhas[i]);
        lista.add(objeto);
      }
    }
    return lista;
  }

  fetchById(int id) async {
    var linha;
    if( id !=null || id.toString() != "" ) {
      linha = await dbHelper.query(TABLE_NAME, where: "_id = ?", whereArgs: [id]);
      linha = linha.isNotEmpty ? CategoriaCadModel.fromJson(linha.first) : null;
    }
    return linha;
  }

  fetchByAll() async {
    final linhas = await dbHelper.queryAllRows(TABLE_NAME);
    List<CategoriaCadModel> lista = List<CategoriaCadModel>();
    for(var linha in linhas){
      CategoriaCadModel objeto = new CategoriaCadModel.fromJson(linha);
      lista.add(objeto);
    }
    return lista;
  }
}