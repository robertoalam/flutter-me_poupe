import 'package:me_poupe/helper/database_helper.dart';
import 'package:me_poupe/model/cad/cad_banco_model.dart';
import 'package:me_poupe/model/conta/conta_tipo_model.dart';

class ContaModel{
	int id;
	String descricao;
	BancoCadModel banco;
	ContaBancariaTipoModel tipo;
	double saldo;

	final dbHelper = DatabaseHelper.instance;

	static final String TABLE_NAME = "conta_bancaria";

	ContaModel({this.id, this.descricao, this.banco,this.tipo,this.saldo});

	factory ContaModel.fromJson(Map<String, dynamic> json) {
		return ContaModel(
			id: json['id'],
			descricao: json['descricao'],
			banco: json['id_banco'],
			tipo: json['id_conta_tipo'],
			saldo: json['vl_saldo'],
		);
	}

	factory ContaModel.fromDatabase(Map<String, dynamic> json) {
		return ContaModel(
			id: json['_id'],
			descricao: json['descricao'],
			banco: json['id_banco'],
			tipo: json['id_conta_tipo'],
			saldo: json['vl_saldo'],
		);
	}

	fetchById(int id) async {
		var linha;
		if( id !=null || id.toString() != "" ) {
			linha = await dbHelper.query(TABLE_NAME, where: "id = ?", whereArgs: [id]);
			linha = linha.isNotEmpty ? ContaModel.fromDatabase(linha.first) : null;
		}
		return linha;
	}

  fetchByAll() async {
		final linhas = await dbHelper.queryAllRows(TABLE_NAME);
		List<ContaModel> lista = List<ContaModel>();
		for(var linha in linhas){
			ContaModel objeto = new ContaModel.fromDatabase(linha);
			lista.add(objeto);
		}
		return lista;
  	}
}