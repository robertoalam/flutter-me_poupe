
import 'package:me_poupe/helper/database_helper.dart';
import 'package:me_poupe/model/cad/cad_banco_model.dart';
import 'package:me_poupe/model/conta/cartao_model.dart';
import 'package:me_poupe/model/conta/conta_tipo_model.dart';

class ContaModel {
  int id;
  int webserverId;
  String descricao;
  BancoCadModel banco;
  ContaTipoModel tipo;
  List<CartaoModel> cartoes;
  bool flagDeletado;

  final dbHelper = DatabaseHelper.instance;

  static final String tableName = "conta";

  ContaModel( {
    this.id,
    this.webserverId,
    this.descricao,
    this.banco,
    this.tipo,
    this.flagDeletado
  });

  factory ContaModel.fromJson(Map<String, dynamic> json) {
    return ContaModel(
      id: json['id'],
      webserverId: json['id_webserver'],
      descricao: json['descricao'],
      banco: json['id_banco'],
      tipo: json['id_conta_tipo'],
    );
  }

  fromToDatabase(Map<String, dynamic> json) async {
    BancoCadModel banco = new BancoCadModel();
    banco = await banco.fetchById(json['id_banco']);

    ContaTipoModel contaTipo = new ContaTipoModel();
    contaTipo = await contaTipo.fetchById(json['id_conta_tipo']);

    return ContaModel(
      id: json['id'],
      banco: banco,
      descricao: json['descricao'],
      tipo: contaTipo,
    );
  }

  Map toDatabase() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["id_banco"] = banco.id;
    map["id_conta_tipo"] = tipo.id;
    map["descricao"] = descricao;
    return map;
  }

  fetchById(int id) async {
    var linha;
    linha = null;
    if (id != null || id.toString() != "") {
      linha =
      await dbHelper.query(tableName, where: " id = ?", whereArgs: [id]);
      ContaModel conta = new ContaModel();
      // conta = conta.fromtoDatabase(linha);
      linha = linha.isNotEmpty ? await conta.fromToDatabase(linha.first) : null;
    }
    return linha;
  }

  fetchByAll() async {
    var linhas;
    linhas = await dbHelper.queryAllRows(tableName);
    List<ContaModel> lista = List<ContaModel>();
    for (var linha in linhas) {
      ContaModel objeto = new ContaModel();
      objeto = await objeto.fromToDatabase(linha);
      objeto.cartoes = await objeto.fetchByAllCards(objeto.id);
      lista.add(objeto);
    }
    return lista;
  }

  fetchByAllCards(int id_conta) async {
    var linhas;
    // linhas = await dbHelper.queryAllRows(CartaoModel.tableName);
    linhas = await dbHelper.query(
        CartaoModel.tableName, where: " id_conta = ? ", whereArgs: [id_conta]);
    List<CartaoModel> lista = List<CartaoModel>();
    for (var linha in linhas) {
      CartaoModel objeto = new CartaoModel();
      objeto = await objeto.fromToDatabase(linha);
      lista.add(objeto);
    }
    return lista;
  }

  save() async {
    Map retorno = new Map();
    var id;
    if (this.id == null || this.id == 0) {
      //insert
      try {
        id = await dbHelper.insert(tableName, this.toDatabase());
      } catch (e) {
        print("ERRO UPDATE: ${e}");
        retorno['status'] = 500;
        retorno['msg'] = "Erro ao tentar inserir";
        return retorno;
      }
    } else {
      //update
      try {
        id = await dbHelper.update(tableName, "id", this.toDatabase());
      } catch (e) {
        print("ERRO UPDATE: ${e}");
        retorno['status'] = 500;
        retorno['msg'] = "Erro ao tentar editar";
        return retorno;
      }
    }

    // se houver cartoes , salva
    // senao deleta todos os cartoes dessa conta
    if (this.cartoes != null) {
      try {
        await _cartoesListaSalvar();
      } catch (e) {
        print("ERRO SALVAR CARTOES");
        retorno['status'] = 500;
        retorno['msg'] = "Erro ao salvar cartões";
        return retorno;
      }
    }

    retorno['status'] = 200;
    retorno['msg'] = "Sucesso !!!";
    return retorno;
  }


  _cartoesListaSalvar() async {
    for(CartaoModel item in this.cartoes){
      var retorno = await item.save();

    }
  }

}