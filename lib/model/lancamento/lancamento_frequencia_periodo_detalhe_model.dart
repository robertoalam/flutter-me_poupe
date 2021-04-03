import 'package:me_poupe/helper/database_helper.dart';

class LancamentoFrequenciaPeriodoDetalheModel{
  int id;
  int idParcela;
  DateTime data;
  int mes;
  int ano;
  double valor;

  final dbHelper = DatabaseHelper.instance;

  static final String TABLE_NAME = "lancamento_periodo";
}

