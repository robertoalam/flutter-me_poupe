import 'package:me_poupe/helper/database_helper.dart';

class FrequenciaCadModel{
   int id;
   String descricao;

   final dbHelper = DatabaseHelper.instance;

   static final String TABLE_NAME = "frequencia_cad";

   FrequenciaCadModel({this.id, this.descricao});

   @override
  String toString() {
    return "${this.id} ${this.descricao}";
  }

  factory FrequenciaCadModel.fromJson(Map<String, dynamic> json) {
     return FrequenciaCadModel(
       id: json['_id'],
       descricao: json['descricao'],
     );
   }

   fetchById(int id) async {
     var linha;
     if( id !=null || id.toString() != "" ) {
       linha = await dbHelper.query(TABLE_NAME, where: "_id = ?", whereArgs: [id]);
       linha = linha.isNotEmpty ? FrequenciaCadModel.fromJson(linha.first) : null;
     }
     return linha;
   }

   fetchByAll() async {
     final linhas = await dbHelper.queryAllRows(TABLE_NAME);
     List<FrequenciaCadModel> lista = List<FrequenciaCadModel>();
     for(var linha in linhas){
       FrequenciaCadModel objeto = new FrequenciaCadModel.fromJson(linha);
       lista.add(objeto);
     }
     return lista;
   }

}