import 'package:me_poupe/helper/database_helper.dart';
import 'package:me_poupe/model/cartao_model.dart';

class CarteiraModel{
	int id;
	String descricao;
	List<CartaoModel> listaCartao;

	final dbHelper = DatabaseHelper.instance;

	static final String TABLE_NAME = "carteira";

	CarteiraModel({this.id, this.descricao, this.listaCartao});

	factory CarteiraModel.fromJson(Map<String, dynamic> json) {
		return CarteiraModel(
			id: json['id'],
			descricao: json['descricao'],
		);
	}

  fetchById(int id) async {
    var linha;
    if( id !=null || id.toString() != "" ) {
		linha = await dbHelper.query(TABLE_NAME, where: "id = ?", whereArgs: [id]);
		linha = linha.isNotEmpty ? CarteiraModel.fromJson(linha.first) : null;
    }
    return linha;
  }

  fetchByAll() async {
		final linhas = await dbHelper.queryAllRows(TABLE_NAME);
		List<CarteiraModel> lista = List<CarteiraModel>();
		for(int i=0;i < linhas.length ; i++){
		CarteiraModel objeto = new CarteiraModel.fromJson(linhas[i]);
		lista.add(objeto);
		}
		return lista;
  	}
}