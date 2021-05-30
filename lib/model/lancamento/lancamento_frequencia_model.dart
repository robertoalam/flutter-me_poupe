import 'package:me_poupe/helper/database_helper.dart';
import 'package:me_poupe/model/cad/cad_frequencia_model.dart';
import 'package:me_poupe/model/cad/cad_frequencia_periodo_model.dart';
import 'package:me_poupe/model/lancamento/lancamento_frequencia_detalhe_model.dart';


class FrequenciaModel{
  int id;
  int idLancamento;
  String chaveUnica;
  FrequenciaCadModel frequencia;
  FrequenciaPeriodoCadModel frequenciaPeriodo;
  int quantidade;
  double valorIntegral;
  // List<LancamentoFrequenciaPeriodoDetalheModel> lista;
  List<FrequenciaDetalheModel> lista;


  static final String TABLE_NAME = "lancamento_frequencia";
  final dbHelper = DatabaseHelper.instance;

  FrequenciaModel({
    this.id,
    this.idLancamento,
    this.chaveUnica,
    this.frequencia,
    this.frequenciaPeriodo,
    this.quantidade,
    this.valorIntegral,
    this.lista
  });

  @override
  String toString() {
    return 'LancamentoFrequenciaModel{frequencia: $frequencia, frequenciaPeriodo: $frequenciaPeriodo, quantidade: $quantidade, valorIntegral: $valorIntegral}';
  }

  factory FrequenciaModel.fromDatabase(Map<String, dynamic> json) {
    return FrequenciaModel(
      id: json['_id'] ,
      idLancamento: json['id_lancamento'],
      chaveUnica: json['st_chave_unica'],
      frequencia: json['id_frequencia'],
      frequenciaPeriodo: json['id_frequencia_periodo'],
      quantidade: json['no_quantidade'],
      valorIntegral: json['vl_integral'],
    );
  }

  Map database() {
    var map = new Map<String, dynamic>();
    map["_id"] = id;
    map["id_lancamento"] = idLancamento;
    map["st_chave_unica"] = chaveUnica;
    map["id_frequencia"] = frequencia.id;
    map["id_frequencia_periodo"] = frequenciaPeriodo.id;
    map["no_quantidade"] = quantidade;
    map["vl_integral"] = valorIntegral;
    return map;
  }

  Future<void> delete({ int valor , coluna}) async {
    return await dbHelper.delete( TABLE_NAME , valor: valor , coluna: coluna);
  }

  save() async {
    await dbHelper.insert( TABLE_NAME , this.database()  );
  }

  buscarValores() async {
    String query ;
    query = "SELECT "+
    " MAX(vl_integral) vl_integral_max ,MIN(vl_integral) vl_integral_min , AVG(vl_integral) vl_integral_medio "+
    " FROM lancamento_frequencia ;";
    final linhas = await dbHelper.executarQuery(query);
    return linhas.first;
  }
}