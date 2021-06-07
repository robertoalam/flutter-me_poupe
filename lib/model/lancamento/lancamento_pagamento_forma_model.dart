import 'package:me_poupe/helper/database_helper.dart';
import 'package:me_poupe/model/cad/cad_pagamento_forma.dart';
import 'package:me_poupe/model/conta/cartao_model.dart';

class PagamentoModel{
  int id;
  int idLancamento;
  String chaveUnica;
  PagamentoFormaCadModel pagamentoForma;
  CartaoModel cartao;

  PagamentoModel({
    this.id,
    this.chaveUnica,
    this.idLancamento,
    this.pagamentoForma,
    this.cartao
  });

  static final String TABLE_NAME = "lancamento_pagamento";

  final dbHelper = DatabaseHelper.instance;

  Map database() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["id_lancamento"] = idLancamento;
    map["st_chave_unica"] = chaveUnica;
    map["id_pagamento_forma"] = pagamentoForma.id;
    map["id_cartao"] = cartao.id;
    return map;
  }

  Future<void> delete({ int valor , coluna}) async {
    return await dbHelper.delete( TABLE_NAME , valor: valor , coluna: coluna);
  }

  save() async {
    await dbHelper.insert( TABLE_NAME , this.database()  );
  }

}
