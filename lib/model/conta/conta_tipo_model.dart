import 'package:me_poupe/helper/database_helper.dart';

class ContaTipoModel{
	int id;
	String descricao;

	final dbHelper = DatabaseHelper.instance;

	static final String TABLE_NAME = "conta_tipo_cad";

	ContaTipoModel({this.id, this.descricao});

  @override
  toString(){
    return "${this.id} ${this.descricao}";
  }

	factory ContaTipoModel.fromJson(Map<String, dynamic> json) {
		return ContaTipoModel(
			id: json['id'],
			descricao: json['descricao'],
		);
	}

	factory ContaTipoModel.fromDatabase(Map<String, dynamic> json) {
		return ContaTipoModel(
			id: json['_id'],
			descricao: json['descricao'],
		);
	}

	fetchById(int id) async {
		var linha;
		if( id !=null || id.toString() != "" ) {
			linha = await dbHelper.query(TABLE_NAME, where: " _id = ?", whereArgs: [id]);
			linha = linha.isNotEmpty ? ContaTipoModel.fromDatabase(linha.first) : null;
		}
		return linha;
	}

  fetchByAll() async {
		final linhas = await dbHelper.queryAllRows(TABLE_NAME);
		List<ContaTipoModel> lista = List<ContaTipoModel>();
		for(var linha in linhas){
			ContaTipoModel objeto = new ContaTipoModel.fromDatabase(linha);
			lista.add(objeto);
		}
		return lista;
  	}
}