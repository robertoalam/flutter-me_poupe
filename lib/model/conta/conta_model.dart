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

	static final String tableName = "conta";

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

	fromDatabase(Map<String, dynamic> json) async {
    BancoCadModel banco = new BancoCadModel();
    banco = await banco.fetchById(json['id_banco']);

    ContaBancariaTipoModel contaTipo = new ContaBancariaTipoModel();
    contaTipo = await contaTipo.fetchById(json['id_conta_tipo']);

    return ContaModel(
			id: json['id'],
      banco: banco,
			descricao: json['descricao'],
			tipo: contaTipo,
			saldo: json['vl_saldo'],
		);
	}

    Map database() {
        var map = new Map<String, dynamic>();
        map["id"] = id;
        map["id_banco"] = banco.id;
        map["id_conta_tipo"] = tipo.id;
        map["descricao"] = descricao;
        map["saldo"] = saldo;
        return map;
    }

	fetchById(int id) async {
		var linha;
		if( id !=null || id.toString() != "" ) {
			linha = await dbHelper.query(tableName, where: " id = ?", whereArgs: [id]);
      ContaModel conta = new ContaModel();
      // conta = conta.fromDatabase(linha);
			linha = linha.isNotEmpty ? await conta.fromDatabase(linha) : null;
		}
		return linha;
	}

  fetchByAll() async {
	  var linhas;
		linhas = await dbHelper.queryAllRows(tableName);
		List<ContaModel> lista = List<ContaModel>();
		for(var linha in linhas){
			ContaModel objeto = new ContaModel();
      objeto = await objeto.fromDatabase(linha);
			lista.add(objeto);
		}
		return lista;
  }

    save() async {
	    Map retorno = new Map();
      if(this.id == null || this.id == 0){
          //insert
           var id = await dbHelper.insert(tableName, this.database() );
           if(id.runtimeType != int){
             retorno['status'] = 500;
             retorno['msg'] = "Erro ao tenar inserir";
             return retorno;
          }
      }else{
          //update
          var id = await dbHelper.update(tableName, "id", this.database() );
          if(id.runtimeType != int){
            retorno['status'] = 500;
            retorno['msg'] = "Erro ao tentar editar";
            return retorno;
          }
      }
      retorno['status'] = 200;
      retorno['msg'] = "Sucesso !!!";
      return retorno;
    }
}