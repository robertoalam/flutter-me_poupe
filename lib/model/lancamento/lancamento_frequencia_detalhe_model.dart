import 'package:me_poupe/helper/database_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/lancamento/lancamento_frequencia_model.dart';
import 'package:me_poupe/model/lancamento/lancamento_model.dart';

class FrequenciaDetalheModel{
  int id;
  int idLancamento;
  String chaveUnica;
  FrequenciaModel frequencia;
  // frequenciaNumero == numero da parcela
  int frequenciaNumero;
  DateTime frequenciaData;
  int frequenciaMes;
  int frequenciaAno;
  double valor;

  FrequenciaDetalheModel({
    this.id,
    this.idLancamento,
    this.chaveUnica,
    this.frequencia,
    this.frequenciaNumero,
    this.frequenciaData,
    this.frequenciaMes,
    this.frequenciaAno,
    this.valor
  });

  final dbHelper = DatabaseHelper.instance;

  static final String TABLE_NAME = "lancamento_frequencia_detalhe";

  factory FrequenciaDetalheModel.fromDatabase(Map<String, dynamic> json) {
    return FrequenciaDetalheModel(
      id: json['_id'] ,
      idLancamento: json['id_lancamento_tipo'],
      chaveUnica: json['st_chave_unica'],
      frequencia: json['id_frequencia'],
      frequenciaNumero: json['no_frequencia'],
      frequenciaData: json['dt_detalhe'],
      frequenciaAno: json['dt_ano'],
      frequenciaMes: json['dt_mes'],
      valor: json['vl_valor']
    );
  }

  montarObjeto( Map<String, dynamic> json ){

  }
  Map database() {
    var map = new Map<String, dynamic>();
    map["_id"] = id;
    map["id_lancamento"] = idLancamento;
    map["st_chave_unica"] = chaveUnica;
    map["id_frequencia"] = frequencia.frequencia.id;
    map["no_frequencia"] = frequenciaNumero;
    map["dt_detalhe"] = Funcoes.verificarTimeStamp(frequenciaData);
    map["dt_mes"] = frequenciaMes;
    map["dt_ano"] = frequenciaAno;
    map["vl_valor"] = valor;
    return map;
  }

  @override
  String toString() {
    return '{id: $id, idLancamento: $idLancamento, chaveUnica: $chaveUnica, frequencia: $frequencia, frequenciaNumero: $frequenciaNumero, frequenciaData: $frequenciaData, frequenciaMes: $frequenciaMes, frequenciaAno: $frequenciaAno, valor: $valor}';
  }

  fetchById(int id) async {
    var linha;
    if( id !=null || id.toString() != "" ) {
      linha = await dbHelper.query(TABLE_NAME, where: "_id = ?", whereArgs: [id]);
      linha = linha.isNotEmpty ? FrequenciaDetalheModel.fromDatabase(linha.first) : null;
    }
    return linha;
  }

  fetchByAll() async {
    final linhas = await dbHelper.queryAllRows(TABLE_NAME);
    List<FrequenciaDetalheModel> lista = List<FrequenciaDetalheModel>();
    for(var linha in linhas ){
      FrequenciaDetalheModel objeto = new FrequenciaDetalheModel.fromDatabase(linha);
      lista.add(objeto);
    }
    return lista;
  }

//   fetchByYearAndMonth(int ano , int mes) async {
//     final linhas = await dbHelper.query(TABLE_NAME, where: "dt_ano = ? AND dt_mes = ?", whereArgs: [ano,mes]);
//     List<FrequenciaDetalheModel> lista = List<FrequenciaDetalheModel>();
//     for(var linha in linhas ){
// //      FrequenciaDetalheModel objeto = new FrequenciaDetalheModel.fromDatabase(linha);
//       LancamentoModel _lancamento = LancamentoModel();
// //      _lancamento.fetchByDetalhe();
//
//       FrequenciaDetalheModel objeto = new FrequenciaDetalheModel();
//       objeto = objeto.montarObjeto(linha);
//       lista.add(objeto);
//     }
//     return lista;
//   }

  save() async {
    await dbHelper.insert( TABLE_NAME , this.database()  );
  }

  Future<void> delete({ int valor , coluna}) async {
    return await dbHelper.delete( TABLE_NAME , valor: valor , coluna: coluna);
  }
}