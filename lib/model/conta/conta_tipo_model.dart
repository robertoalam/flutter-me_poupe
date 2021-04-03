import 'package:me_poupe/helper/database_helper.dart';

class ContaBancariaTipoModel{
	int id;
	String descricao;

	final dbHelper = DatabaseHelper.instance;

	static final String TABLE_NAME = "conta_bancaria_tipo_cad";

	ContaBancariaTipoModel({this.id, this.descricao});

  @override
  toString(){
    return "${this.id} ${this.descricao}";
  }

	factory ContaBancariaTipoModel.fromJson(Map<String, dynamic> json) {
		return ContaBancariaTipoModel(
			id: json['id'],
			descricao: json['descricao'],
		);
	}

	factory ContaBancariaTipoModel.fromDatabase(Map<String, dynamic> json) {
		return ContaBancariaTipoModel(
			id: json['_id'],
			descricao: json['descricao'],
		);
	}

	fetchById(int id) async {
		var linha;
		if( id !=null || id.toString() != "" ) {
			linha = await dbHelper.query(TABLE_NAME, where: "id = ?", whereArgs: [id]);
			linha = linha.isNotEmpty ? ContaBancariaTipoModel.fromDatabase(linha.first) : null;
		}
		return linha;
	}

  fetchByAll() async {
		final linhas = await dbHelper.queryAllRows(TABLE_NAME);
		List<ContaBancariaTipoModel> lista = List<ContaBancariaTipoModel>();
		for(var linha in linhas){
			ContaBancariaTipoModel objeto = new ContaBancariaTipoModel.fromDatabase(linha);
			lista.add(objeto);
		}
		return lista;
  	}
}