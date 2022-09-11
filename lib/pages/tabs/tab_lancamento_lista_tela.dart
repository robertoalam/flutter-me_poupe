import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/calendario_horizontal_widget.dart';
import 'package:me_poupe/componentes/icone_gambiarra.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/calendario_model.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/configuracoes/icone_cad_model.dart';
import 'package:me_poupe/model/lancamento/lancamento_model.dart';
import 'package:me_poupe/pages/tabs/modal/modal_tab_lancamento_lista_filtro_tela.dart';
import 'package:me_poupe/pages/tabs/modal/modal_tab_lancamento_lista_ordenacao_tela.dart';

class TabLancamentoListaTela extends StatefulWidget {
  const TabLancamentoListaTela();
  @override
  _TabLancamentoListaTelaState createState() => _TabLancamentoListaTelaState();
}

class _TabLancamentoListaTelaState extends State<TabLancamentoListaTela> {
  var body;
  var _dados;
  LancamentoModel _lancamento = new LancamentoModel();
  List<LancamentoModel> _lancamentoLista = new List<LancamentoModel>();
  String corLancamentoDespesa ;
  String corLancamentoReceita ;
  // CALENDARIO
  List<CalendarioModel> _calendarioLista = new List<CalendarioModel>();
  CalendarioModel _calendario = new CalendarioModel();
  double _valorTotalReceita = 0.00;
  double _valorTotalDespesa = 0.00;
  double _valorTotalSaldo = 0.00;
  // PESQUISA
  String _ordenacao;
  Map _where = Map();

  @override
  void initState() {
    _lancamentoLista = null;
    _calendarioLista = null;
    _where = null;
    _ordenacao = null;
    inicio();
  }

  inicio() async {
    await _buscarDadosConfiguracao();
    await _definirCores();
    await _buscarLista();
    await _buscarLancamentos();
  }

  _buscarLista(){
    _calendarioLista = _calendario.gerarLista( new DateTime.now() );
    setState(() {
      _calendarioLista;
    });
    return _calendarioLista;
  }

  _definirCores() {
    corLancamentoDespesa = ( _dados['modo'] == "normal" ) ? "#FF5C4A":"#7A0004";
    corLancamentoReceita = ( _dados['modo'] == "normal" ) ? "#4CAF50":"#00640E";
    setState(() {
      corLancamentoDespesa = Funcoes.converterCorStringColor( corLancamentoDespesa );
      corLancamentoReceita = Funcoes.converterCorStringColor( corLancamentoReceita );
      // _background = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['background']);
      // _colorFundo = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['background']);
      // _colorContainerFundo = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['containerFundo']);
      // _colorContainerBorda = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['containerBorda']);
      // _colorLetra = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['textoPrimaria']);
    });
    return;
  }

  _buscarDadosConfiguracao() async {
    _dados = await ConfiguracaoModel.getConfiguracoes().then((list) {
      return list;
    });
    setState(() {
      _dados;
    });
    return;
  }


  @override
  Widget build(BuildContext context) {
    if( _lancamentoLista != null){
      body = SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LabelOpensans("Lista de Lancamentos",tamanho: 18,cor: Colors.white,),
                    Container(
                      child: Row(
                        children: [
                          InkWell(
                            child: Icon(Icons.reorder , color: Colors.white,),
                            onTap: () async {
                              var retorno = await _modalTabLancamentoListaOrdenacaoTela(context);
                              _pesquisaOrdenar(retorno);
                            },
                          ),
                          SizedBox(width: 10,),
                          InkWell(
                            child: Icon(Icons.search, color: Colors.white,),
                            onTap: () async {
                              var retorno = await Navigator.push( context , MaterialPageRoute( builder: (context) => ModalTabLancamentoListaFiltroTela()));
                              _pesquisaFiltrar( retorno );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                )
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: CalendarioHorizontalWidget( _calendarioLista , _dataSelecionada),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .7,
              child: ListView(
                children: [
                  for(var item in _lancamentoLista) _thumb(item , context),
                  _cardResumo(),
                ],
              ),
            ),
          ],
        ),
      );

      //   Container(
      //     child: Column(
      //       children: [
      //
      //
      //         (_lancamentoLista != null)?
      //         SingleChildScrollView(
      //           child: Column(
      //             children: [
      //               for(var item in _lancamentoLista) _thumb(item , context),
      //               _cardResumo(),
      //             ],
      //           ),
      //         )
      //             :
      //         Container(
      //           height: MediaQuery.of(context).size.height,
      //           child: Center(
      //             child: CircularProgressIndicator(),
      //           ),
      //         )
      //       ],
      //     )
      // );
    }else{
      body = Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return body;
  }

  _modalTabLancamentoListaOrdenacaoTela(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return ModalTabLancamentoListaOrdenacaoTela();
        }
    );
  }

  _cardResumo(){
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text("Saldo"),
              Text("R\$\ ${_valorTotalSaldo.toStringAsFixed(2)}"),
            ],
          ),
          Column(
            children: [
              Text("Despesas"),
              Text("R\$\ ${_valorTotalDespesa.toStringAsFixed(2)}"),
            ],
          ),
          Column(
            children: [
              Text("Receita"),
              Text("R\$\ ${_valorTotalReceita.toStringAsFixed(2)}"),
            ],
          ),
        ],
      ),
    );
  }
  _thumb(LancamentoModel item , context){
    // DIA
    int dia = Funcoes.retornarDiaDataEUA( item.frequencia.lista[0].frequenciaData );
    String mes = Funcoes.retornarMesDataEUA( item.frequencia.lista[0].frequenciaData );
    String corTipoLancamento = (item.tipo.id == 1)?corLancamentoDespesa:corLancamentoReceita;

    // VALORES
    // SE FOR DESPESA
    if(item.tipo.id == 1){
      _valorTotalDespesa = _valorTotalDespesa + item.frequencia.lista.first.valor;
      _valorTotalSaldo = _valorTotalSaldo - item.frequencia.lista.first.valor;
    }else{
      _valorTotalReceita = _valorTotalReceita + item.frequencia.lista.first.valor;
      _valorTotalSaldo = _valorTotalSaldo + item.frequencia.lista.first.valor;
    }

    var icone = new IconeCadModel.find(item.categoria.icone.toString());
    IconeGambiarra categoriaIcone = (icone !=null)? new IconeGambiarra( icone , cor: Colors.white,tamanho: 22,) : IconeGambiarra( new IconeCadModel.find('help-01') , cor: Colors.white,tamanho: 22,);

    String descricao = (item.descricao.isNotEmpty)? item.descricao: "Sem descricao";
    String pagamentoLabel;
    //SE FOR DINHEIRO
    if(item.pagamento.cartao == null){
      pagamentoLabel = item.pagamento.pagamentoForma.descricao;
    }else{
      // 20210524
      pagamentoLabel = "${item.pagamento.cartao.conta.banco.descricao} - ${item.pagamento.pagamentoForma.descricao} ${item.pagamento.cartao.tipo.descricao}";
    }

    return Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        // height: 105,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("${dia.toString()} ${mes.toString()}"),
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                //ICONE
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * .10,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50)
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(7),
                    child: categoriaIcone,
                  ),
                ),

                // DESCRICAO E CONTA
                Flex(
                  direction: Axis.vertical,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .6,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              descricao ,
                              overflow: TextOverflow.ellipsis,softWrap: false,maxLines: 5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text("${pagamentoLabel}"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // VALOR E STATUS
                Container(
                  width: MediaQuery.of(context).size.width * .2,
                  child: Column(
                    children: [
                      LabelOpensans("R\$ ${item.frequencia.lista.first.valor}" , cor: Color(int.parse(corTipoLancamento) ),bold: true,)
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Divider(height: 10,color: Colors.grey,)
          ],
        )
    );
  }

  _dataSelecionada(String opcao) {
    DateTime dataPesquisar;
    if(opcao == "posterior-mes"){
      dataPesquisar = _calendarioLista[2].data;
      _calendarioLista = _calendario.gerarLista( dataPesquisar );
    }
    if(opcao == "posterior-ano"){
      dataPesquisar = new DateTime(_calendarioLista[1].data.year + 1 , _calendarioLista[1].data.month , 1);
      _calendarioLista = _calendario.gerarLista( dataPesquisar );
    }
    if(opcao == "anterior-mes"){
      dataPesquisar = _calendarioLista[0].data;
      _calendarioLista = _calendario.gerarLista( dataPesquisar );
    }
    if(opcao == "anterior-ano"){
      dataPesquisar = new DateTime(_calendarioLista[1].data.year - 1 , _calendarioLista[1].data.month , 1);
      _calendarioLista = _calendario.gerarLista( dataPesquisar );
    }
    setState(() {
      _calendarioLista;
    });

    _buscarLancamentos();
  }

  _pesquisaOrdenar(Map json) async {
    String ordem = (json['ordem'] != null)? " ${json['ordem']} " : " ASC ";
    _ordenacao = (json['ordenacao'] != null) ? " ORDER BY ${json['ordenacao']} ${ordem}" : "";
    setState(() {
      _lancamentoLista = null;
      _ordenacao;
    });
    await _buscarLancamentos();
  }

  _pesquisaFiltrar(Map<String, dynamic> array) async {
    print("ARRAY: ${array}");
//    String pesquisarWhere = "" ;
//    String pesquisarLancamentoTipo = "";
//    String pesquisarPagamentoForma = "";
//
//    if( array != null){
//      if (array['id_lancamento_tipo'] != null){
//        pesquisarLancamentoTipo = " AND id_lancamento_tipo IN ${array['id_lancamento_tipo'].toString().replaceAll("[","(").replaceAll("]",")")} ";
//      }
//      if (array['id_pagamento_forma'] != null){
//        pesquisarPagamentoForma = " AND id_pagamento_forma IN ${array['id_pagamento_forma'].toString().replaceAll("[","(").replaceAll("]",")")} ";
//      }
//
//      pesquisarWhere = "${pesquisarLancamentoTipo} ${pesquisarPagamentoForma}";
//    }
    setState(() { _where = array ; });
    await _buscarLancamentos();
  }

  Future <List<LancamentoModel>> _buscarLancamentos() async {
    int ano =_calendarioLista[1].ano;
    int mes =_calendarioLista[1].mes;
    _lancamentoLista = await _lancamento.fetchByYearAndMonth(ano,mes, where: _where ,order: _ordenacao);

    setState(() {
      _valorTotalDespesa = 0.00;
      _valorTotalReceita = 0.00;
      _valorTotalSaldo = 0.00;
      _lancamentoLista;
    });
  }
}
