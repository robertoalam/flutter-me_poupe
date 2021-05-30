import 'package:me_poupe/helper/arquivo_helper.dart';
import 'package:me_poupe/helper/database_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/cad/cad_banco_model.dart';
import 'package:me_poupe/model/cad/cad_cartao_tipo_model.dart';
import 'package:me_poupe/model/cad/cad_categoria_model.dart';
import 'package:me_poupe/model/cad/cad_frequencia_model.dart';
import 'package:me_poupe/model/cad/cad_frequencia_periodo_model.dart';
import 'package:me_poupe/model/cad/cad_lancamento_tipo_model.dart';
import 'package:me_poupe/model/cad/cad_pagamento_forma.dart';
import 'package:me_poupe/model/conta/cartao_model.dart';
import 'package:me_poupe/model/conta/conta_model.dart';
import 'package:me_poupe/model/lancamento/lancamento_frequencia_detalhe_model.dart';
import 'package:me_poupe/model/lancamento/lancamento_frequencia_model.dart';
import 'package:me_poupe/model/lancamento/lancamento_pagamento_forma_model.dart';
import 'package:me_poupe/model/usuario/usuario_model.dart';

class LancamentoModel{
  int id;
  String chaveUnica;
  LancamentoTipoCadModel tipo;
  UsuarioModel usuario;
  String descricao;
  CategoriaCadModel categoria;
  PagamentoModel pagamento;
  DateTime data;
  FrequenciaModel frequencia;
  bool delete;

  @override
  String toString() {
    return 'LancamentoModel{id: $id, '
        'usuario: $usuario, '
        'descricao: $descricao, '
        'categoria: $categoria, '
        'data: $data, '
        'frequencia: $frequencia}';
  }

  static final String TABLE_NAME = "lancamento";

  final dbHelper = DatabaseHelper.instance;

  LancamentoModel({
    this.chaveUnica,
    this.id,
    this.tipo,
    this.usuario,
    this.descricao,
    this.categoria,
    this.pagamento,
    this.data,
    this.frequencia,
    this.delete,
  });

  factory LancamentoModel.fromDatabase(Map<String, dynamic> json) {
    return LancamentoModel(
        id: json['_id'] ,
        tipo: json['id_lancamento_tipo'],
        usuario: json['id_usuario'],
        descricao: json['descricao'],
        categoria: json['id_categoria'],
        data: json['dt_lancamento'],
    );
  }

  Map database() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["st_chave_unica"] = chaveUnica;
    map["id_lancamento_tipo"] = tipo.id;
    map["id_usuario"] = 1;
    map["descricao"] = descricao;
    map["id_categoria"] = categoria.id;
    map["dt_lancamento"] = Funcoes.verificarTimeStamp(data) ;
    return map;
  }


  // CRUD
  Future<void> insert() async {
    this.id = ( this.id == 0)? null : this.id;
    int id = 0;
    try{
      id = await dbHelper.insert( TABLE_NAME , this.database()  );
    }catch(error){
      id = 0;
    }

     if( id > 0 ) {

       await lancamentoPagamentoDeletar(id);
       await lancamentoFrequenciaDetalheDeletar(id);
       await lancamentoFrequenciaDeletar(id);

       await lancamentoPagamentoSalvar(id , this.chaveUnica ,this.pagamento);
       await lancamentoFrequenciaSalvar(id , this.chaveUnica ,this.frequencia);
       await lancamentoFrequenciaDetalheSalvar(id , this.chaveUnica ,this.data, this.frequencia);

     }
    return id;
  }

  Future udpate() async {
    await dbHelper.update( TABLE_NAME , "id" , this.database() );
    // await deletarDeviceProducaoLeiteConcentrado(this.id);
    // await salvarDeviceProducaoLeiteConcentrado(this.id, this.producaoLeiteConcentrado);
    // return this.id;
  }

  fetchById(int id) async {
    var linha;
    if( id !=null || id.toString() != "" ) {
      linha = await dbHelper.query(TABLE_NAME, where: "_id = ?", whereArgs: [id]);
      linha = linha.isNotEmpty ? LancamentoModel.fromDatabase(linha.first) : null;
    }
    return linha;
  }

  fetchByAll() async {
    final linhas = await dbHelper.queryAllRows(TABLE_NAME);
    List<LancamentoModel> lista = List<LancamentoModel>();
    for(var linha in linhas ){
      LancamentoModel objeto = new LancamentoModel.fromDatabase(linha);
      lista.add(objeto);
    }
    return lista;
  }

  fetchByYearAndMonth(int ano , int mes , {Map where , String order}) async {

    String ordenacao = (order == null)?" ORDER BY strftime('%d', lfd.dt_detalhe) " : " ${order.toString()} ";

    String pesquisarWhere = "" ;
    String pesquisarLancamentoTipo = "";
    String pesquisarPagamentoForma = "";

    if( where != null){
      if (where['id_lancamento_tipo'] != null){
        pesquisarLancamentoTipo = " AND id_lancamento_tipo IN ${where['id_lancamento_tipo'].toString().replaceAll("[","(").replaceAll("]",")")} ";
      }
      if (where['id_pagamento_forma'] != null){
        pesquisarPagamentoForma = " AND id_pagamento_forma IN ${where['id_pagamento_forma'].toString().replaceAll("[","(").replaceAll("]",")")} ";
      }

      pesquisarWhere = "${pesquisarLancamentoTipo} ${pesquisarPagamentoForma}";
    }

    String query = "SELECT "+
      " l.* , "+
      " lp.id_pagamento_forma , lp.id_cartao ,"+
      " pfc.descricao AS 'ds_pagamento_forma',"+
      " "+CartaoModel.tableName+".id_conta  , "+CartaoModel.tableName+".descricao AS 'ds_cartao',"+
      " ctc._id AS 'id_cartao_tipo',ctc.descricao AS 'ds_cartao_tipo',"+
      " bc._id AS 'id_banco',bc.descricao AS 'ds_banco',"+
      " lf.id_frequencia,  lf.id_frequencia_periodo,  lf.no_quantidade,  lf.vl_integral,"+
      " lfd.no_frequencia,  lfd.dt_detalhe,  lfd.dt_mes,  lfd.dt_ano,  lfd.vl_valor,"+
      " 1=1 "+
    " FROM "+FrequenciaDetalheModel.TABLE_NAME+" lfd "+
    " LEFT JOIN "+FrequenciaModel.TABLE_NAME+" lf ON (lfd.id_lancamento = lf.id_lancamento AND lfd.st_chave_unica = lf.st_chave_unica) "+
    " LEFT JOIN "+LancamentoModel.TABLE_NAME+" l ON (l.id = lfd.id_lancamento AND l.st_chave_unica = lfd.st_chave_unica) "+
    " LEFT JOIN lancamento_pagamento lp ON (l.id = lp.id_lancamento AND l.st_chave_unica = lp.st_chave_unica) "+
    " LEFT JOIN pagamento_forma_cad pfc ON lp.id_pagamento_forma = pfc._id "+
    " LEFT JOIN "+CartaoModel.tableName+" ON  "+CartaoModel.tableName+".id = lp.id_cartao "+
    " LEFT JOIN cartao_tipo_cad ctc ON ctc._id =  "+CartaoModel.tableName+".id_cartao_tipo "+
    " LEFT JOIN "+ContaModel.tableName+" ON "+ContaModel.tableName+".id = cartao.id_conta "+
    " LEFT JOIN "+BancoCadModel.TABLE_NAME+" bc ON bc._id = "+ContaModel.tableName+".id_banco "+
    " LEFT JOIN categoria_cad cc ON l.id_categoria = cc._id "+
    " WHERE lfd.dt_ano = "+ano.toString()+" AND lfd.dt_mes = "+mes.toString()+" " +
    " ${pesquisarWhere} " +
    " ${ordenacao} ";

    ArquivoHelper gravar = new ArquivoHelper(nomeArquivo: "teste");
    gravar.writeFile( query.toString() );

    // print("QUERY: ${query}");

    final linhas = await dbHelper.executarQuery(query);

    List<LancamentoModel> lista = new List<LancamentoModel>();
    for(var linha in linhas){

      if(linha.isNotEmpty){

        int id = int.parse(linha['id'].toString());
        String chaveUnica = linha['st_chave_unica'];
        String descricao = linha['descricao'];
        DateTime dataLancamento = DateTime.parse( linha['dt_lancamento']);

        // LANCAMENTO TIPO
        LancamentoTipoCadModel lancamentoTipo = new LancamentoTipoCadModel();
        lancamentoTipo = await lancamentoTipo.fetchById(linha['id_lancamento_tipo']);

        // CATEGORIA
        CategoriaCadModel categoriaCad = new CategoriaCadModel();
        categoriaCad = await categoriaCad.fetchById( linha['id_categoria']);

        // PAGAMENTO
        PagamentoFormaCadModel pagamentoFormaCad = new PagamentoFormaCadModel();
        pagamentoFormaCad = await pagamentoFormaCad.fetchById(linha['id_pagamento_forma']);

        // CARTAO
        CartaoModel cartao ;
        if( linha['id_cartao'] != null ){
          // // BANCO
          // BancoCadModel bancoCad = new BancoCadModel();
          // bancoCad = await bancoCad.fetchById(linha['id_banco']);

          ContaModel conta = new ContaModel();
          conta = await conta.fetchById(linha['id_conta']);

          // CARTAO TIPO CAD
          CartaoTipoCadModel cartaoTipoCad = new CartaoTipoCadModel();
          cartaoTipoCad = await cartaoTipoCad.fetchById(linha['id_cartao_tipo']);

          cartao = new CartaoModel(
            conta: conta ,
            tipo: cartaoTipoCad
          );
        }

        // FREQUENCIA CAD
        FrequenciaCadModel frequenciaCad = new FrequenciaCadModel();
        frequenciaCad = await frequenciaCad.fetchById(linha['id_frequencia']);

        // FREQUENCIA PERIODO CAD
        FrequenciaPeriodoCadModel frequenciaPeriodoCad = new FrequenciaPeriodoCadModel();
        frequenciaPeriodoCad = await frequenciaPeriodoCad.fetchById(linha['id_frequencia_periodo']);

        List<FrequenciaDetalheModel> listagem = new List<FrequenciaDetalheModel>();
        // FREQUENCIA DETALHE
        FrequenciaDetalheModel frequenciaDetalhe = new FrequenciaDetalheModel(
          frequenciaAno: int.parse( linha['dt_ano'].toString() ),
          frequenciaMes: int.parse( linha['dt_mes'].toString() ),
          frequenciaData: DateTime.parse( linha['dt_detalhe'] ),
          valor: double.parse( linha['vl_valor'].toString() ),
        );
        listagem.add(frequenciaDetalhe);

        LancamentoModel lancamento = new LancamentoModel(
          id: id,
          chaveUnica: chaveUnica,
          tipo: lancamentoTipo,
          descricao: descricao,
          categoria: categoriaCad,
          data: dataLancamento,
          pagamento: new PagamentoModel(
              pagamentoForma: pagamentoFormaCad ,
              cartao: cartao
          ),
          frequencia: FrequenciaModel(
            frequencia: frequenciaCad,
            frequenciaPeriodo: frequenciaPeriodoCad,
            lista: listagem,
          ),
        );

        lista.add( lancamento );
      }
    }
    return lista;
  }

  fetchByDetalhe( Map<String, dynamic> json ){

  }

  save(){
    print('ENTROU SAVE');
    if (this.id.toString().isEmpty || this.id == 0 || this.id == null) {
      this.insert();
    } else {
      this.udpate();
    }
  }

  lancamentoFrequenciaDetalheSalvar(int idLancamento ,String chaveUnica, DateTime dataLancamento,FrequenciaModel objeto) async {

    FrequenciaDetalheModel frequenciaDetalhe = new FrequenciaDetalheModel();
    frequenciaDetalhe.idLancamento = idLancamento;
    frequenciaDetalhe.chaveUnica = chaveUnica;
    frequenciaDetalhe.frequencia = frequencia;
    // [REGRA DE NEGOCIO]
    // SE FREQUENCIA.ID FOR == 2 É UMA VALOR FIXO TODOS OS LANCAAMENTOS , o valor é integral
    // SENAO TEM QUE DIVIDIR O VALOR PELO NUMERO DE LANCAMENTOS
    int numeroTotalPeriodos = objeto.quantidade;
    double valorLancamento = (frequencia.frequencia.id == 2)? frequencia.valorIntegral:frequencia.valorIntegral/numeroTotalPeriodos;
    int numeroDias = objeto.frequenciaPeriodo.dias;
    // [REGRA DE NEGOCIO]
    // A DATA DO PERIODO LANCADO => SALTO =  dias X periodo
    int salto ;
    //LOOP PARA OS LANCAMENTOS
    for(int i = 0 ; i < numeroTotalPeriodos ; i++){
      frequenciaDetalhe.frequenciaNumero = i+1;
      salto = numeroDias * i;
      DateTime dataParcela;

      // periodo MENSAL
      if(frequencia.frequenciaPeriodo.id == 4){
        dataParcela = new DateTime(
            dataLancamento.year ,
            dataLancamento.month + i,
            dataLancamento.day
        );
        // periodo ANUAL
      }else if(frequencia.frequenciaPeriodo.id == 9){
        dataParcela = new DateTime(
            dataLancamento.year+i ,
            dataLancamento.month,
            dataLancamento.day
        );
      }else{
        dataParcela = new DateTime(
            dataLancamento.year ,
            dataLancamento.month ,
            dataLancamento.day
        ).add(Duration(days: salto));
      }
//      print("DATA ${i}: ${dataParcela}");

      frequenciaDetalhe.frequenciaData = dataParcela;
      frequenciaDetalhe.frequenciaAno = int.parse( dataParcela.year.toString() );
      frequenciaDetalhe.frequenciaMes = int.parse( dataParcela.month.toString() );
      frequenciaDetalhe.valor = valorLancamento;
      await frequenciaDetalhe.save();
    }
    return;
  }

  lancamentoFrequenciaSalvar(int idLancamento ,String chaveUnica,FrequenciaModel objeto) async {
    objeto.chaveUnica = chaveUnica;
    objeto.idLancamento = idLancamento;
    await objeto.save();
    return ;
  }

  lancamentoPagamentoSalvar(int idLancamento ,String chaveUnica,PagamentoModel objeto) async {
    objeto.chaveUnica = chaveUnica;
    objeto.idLancamento = idLancamento;
    await objeto.save();
    return ;
  }

  lancamentoFrequenciaDetalheDeletar(int id){
    FrequenciaDetalheModel frequenciaDetalhe = FrequenciaDetalheModel();
    frequenciaDetalhe.delete( coluna: 'id_lancamento',valor: id );
  }

  lancamentoFrequenciaDeletar(int id) async {
    FrequenciaModel frequencia = new FrequenciaModel();
    await frequencia.delete(coluna: 'id_lancamento',valor: id);
    return true;
  }

  lancamentoPagamentoDeletar(int id) async {
    PagamentoModel pagamento = new PagamentoModel();
    await pagamento.delete(coluna: 'id_lancamento',valor: id);
    return true;
  }

  gerarLista(){

  }
}