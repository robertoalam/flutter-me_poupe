import 'package:me_poupe/helper/database_helper.dart';

class FrequenciaPeriodoCadModel{
  int id;
  String descricao;
  int dias;
  bool exibir;

  FrequenciaPeriodoCadModel({this.id, this.descricao, this.dias, this.exibir});

  final dbHelper = DatabaseHelper.instance;

  static final String TABLE_NAME = "frequencia_periodo_cad";


  @override
  String toString() {
    return 'PERIODO: id: $id, descricao: $descricao';
  }

  factory FrequenciaPeriodoCadModel.fromJson(Map<String, dynamic> json) {
    return FrequenciaPeriodoCadModel(
      id: json['_id'],
      descricao: json['descricao'],
      dias: json['dias'],
      exibir: ( json['st_exibir'] == '1')? true : false,
    );
  }

  fetchById(int id) async {
    var linha;
    if( id !=null || id.toString() != "" ) {
      linha = await dbHelper.query(TABLE_NAME, where: "_id = ?", whereArgs: [id]);
      linha = linha.isNotEmpty ? FrequenciaPeriodoCadModel.fromJson(linha.first) : null;
    }
    return linha;
  }

  fetchByAll() async {
    final linhas = await dbHelper.queryAllRows(TABLE_NAME);
    List<FrequenciaPeriodoCadModel> lista = List<FrequenciaPeriodoCadModel>();
    for(var linha in linhas){
      FrequenciaPeriodoCadModel objeto = new FrequenciaPeriodoCadModel.fromJson(linha);
      lista.add(objeto);
    }
    return lista;
  }

  fetchByDestaque(int destaque) async {
    var linhas;
    List<FrequenciaPeriodoCadModel> lista = List<FrequenciaPeriodoCadModel>();
    if( destaque !=null || destaque.toString() != "" ) {
      linhas = await dbHelper.query(TABLE_NAME, where: "st_exibir = ?", whereArgs: [destaque]);
      for(int i=0;i < linhas.length ; i++){
        FrequenciaPeriodoCadModel objeto = new FrequenciaPeriodoCadModel.fromJson(linhas[i]);
        lista.add(objeto);
      }
    }
    return lista;
  }
}