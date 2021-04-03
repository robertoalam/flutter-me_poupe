import 'database_helper.dart';
import 'funcoes_helper.dart';

class SeedHelper {

  final dbHelper = DatabaseHelper.instance;

  save(
      //LANCAMENTO
    int usuarioId ,
    int lancamentoTipoId,
    String lancamentoDescricao,
    int categoriaId,
    DateTime lancamentoData,
      // LANCAMENTO PAGAMENTO
    int lancamentoPagamentoFormaId,
    int cartaoId,
      // LANCAMENTO FREQUENCIA
    int frequenciaId,
    int frequenciaPeriodoId,
    int quantidade,
    double valor,
  ) async {

    Map<String,dynamic> linhaLancamento = Map();
    String chaveUnica = Funcoes.gerarIdentificador(usuarioId);
    linhaLancamento['id_usuario'] = usuarioId;
    linhaLancamento['st_chave_unica'] = chaveUnica;
    linhaLancamento['id_lancamento_tipo'] = lancamentoTipoId;
    linhaLancamento['id_categoria'] = categoriaId;

    // lancamento
    int lancamentoId = await dbHelper.insert("lancamento", linhaLancamento);

    // lancamento frequencia
    // Map<String,dynamic> linhaLancamentoPagamento = Map();
    // linhaLancamentoPagamento['id_lancamento'] = lancamentoId;
    // linhaLancamentoPagamento['st_chave_unica'] = chaveUnica;
    // linhaLancamentoPagamento['id_pagamento_forma'] = lancamentoPagamentoFormaId;
    // linhaLancamentoPagamento['id_cartao'] = cartaoId;
    // await dbHelper.insert("lancamento_pagamento", linhaLancamentoPagamento);

    // lancamento frequencia

    // lancamento frequencia detalhe
  }

}