import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/icone_gambiarra.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/componentes/label/label_quicksand.dart';
import 'package:me_poupe/model/configuracoes/icone_cad_model.dart';

class ModalTabLancamentoListaOrdenacaoTela extends StatefulWidget {
  @override
  _ModalTabLancamentoListaOrdenacaoTelaState createState() => _ModalTabLancamentoListaOrdenacaoTelaState();
}

class _ModalTabLancamentoListaOrdenacaoTelaState extends State<ModalTabLancamentoListaOrdenacaoTela> {
  var body;
  List _listaOrdenacao = [
    {'label':'Data','coluna':"strftime('%d', lfd.dt_detalhe)",'icone':'calendario-01'},
    {'label':'Forma de Pagamento','coluna':'lp.id_pagamento_forma','icone':'money-01'},
    {'label':'Tipo despesa','coluna':'id_lancamento_tipo','icone':'money-01'},
    {'label':'Valor','coluna':'lfd.vl_valor','icone':'money-01'}
  ];
  List _listaOrdem = [
    {'label':'Crescente','valor':'asc','icone':'seta-cima-02'},
    {'label':'Decrescente','valor':'desc','icone':'seta-baixo-02'},
  ];
  String _ordenacaoString = "";
  String _ordenacao ;
  String _ordemString = "";
  String _ordem;

  @override
  void initState() {
    _iniciar();
  }

  _iniciar(){
    _ordenacaoString = "Clique aqui";
    _ordemString = "Clique aqui";
  }

  @override
  Widget build(BuildContext context) {
    body = Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width * .8,
        height: MediaQuery.of(context).size.height * .5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ORDENACAO
            Container(
              width: MediaQuery.of(context).size.width * .9,
              child: LabelOpensans('Ordenação: ',tamanho: 18,),
            ),
            InkWell(
              onTap: () async {
                var retorno = await _modalBottomSheetColunas(context);
                _setarCampoOrdenacao(retorno);
              },
              child: Container(
                  width: MediaQuery.of(context).size.width * .9,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all( width: 3.0 , color: Colors.purple),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 12, 0, 0),
                    child: Row(
                      children: [
                        Text(_ordenacaoString , style: TextStyle(fontSize: 22 , color: Colors.white,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  )
              ),
            ),
            SizedBox(height: 10,),

            // ORDEM
            Container(
              width: MediaQuery.of(context).size.width * .9,
              child: LabelOpensans('Ordem: ',tamanho: 18,),
            ),
            InkWell(
              onTap: () async {
                var retorno = await _modalBottomSheetOrdem(context);
                _setarCampoOrdem(retorno);
              },
              child: Container(
                  width: MediaQuery.of(context).size.width * .9,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all( width: 3.0 , color: Colors.purple),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 12, 0, 0),
                    child: Row(
                      children: [
                        Text(_ordemString , style: TextStyle(fontSize: 22 , color: Colors.white,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  )
              ),
            ),

            SizedBox(height: 20,),
            Divider( height: 2,color: Colors.black87,),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  onPressed: () => { Navigator.pop(context , null),},
                  child: Text('cancelar'),
                ),
                SizedBox(width: 15,),
                RaisedButton(
                  onPressed: () {
                    var retorno = Map();
                    retorno['ordenacao'] = _ordenacao;
                    retorno['ordem'] = _ordem;
                    Navigator.pop(context , retorno);
                  },
                  color: Colors.purple,
                  child: Text('Ordenar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black12,
      body: body,
    );
  }

  _modalBottomSheetColunas(context){
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Wrap(
              children: [
                for(var item in _listaOrdenacao) _thumbCampoOrdem(item),
              ],
            ),
          );
        }
    );
  }
  _setarCampoOrdenacao(objeto){
    if(objeto !=null){
      _ordenacaoString = objeto['label'];
      _ordenacao = objeto['coluna'];
    }else{
      _ordenacaoString = "Clique aqui";
      _ordenacao = null;
    }
    setState(() {
      _ordenacaoString;
      _ordenacao;
    });
  }

  _thumbCampoOrdenacao(objeto){
    var icone = new IconeCadModel.find( objeto['icone'].toString() );
    IconeGambiarra iconeGambiarra = (icone !=null)? new IconeGambiarra( icone , cor: Colors.white,tamanho: 22,) : IconeGambiarra( new IconeCadModel.find('help-01') , cor: Colors.white,tamanho: 22,);
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: MediaQuery.of(context).size.width * .13,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(1000)
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.all(3),
            child: iconeGambiarra,
          ),
          title: new LabelQuicksand( objeto['label'].toString() ,bold: true,tamanho: 22,),
          onTap: (){ Navigator.pop(context , objeto); },
        ),
        Divider(color: Colors.black87,),
      ],
    );
  }

  _modalBottomSheetOrdem(context){
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Wrap(
              children: [
                for(var item in _listaOrdem) _thumbCampoOrdenacao(item),
              ],
            ),
          );
        }
    );
  }
  _setarCampoOrdem(objeto){
    if(objeto !=null){
      _ordemString = objeto['label'];
      _ordem = objeto['valor'];
    }else{
      _ordemString = "Clique aqui";
      _ordem = null;
    }
    setState(() {
      _ordem;
      _ordemString;
    });
  }
  _thumbCampoOrdem(objeto){
    var icone = new IconeCadModel.find( objeto['icone'].toString() );
    IconeGambiarra iconeGambiarra = (icone !=null)? new IconeGambiarra( icone , cor: Colors.white,tamanho: 22,) : IconeGambiarra( new IconeCadModel.find('help-01') , cor: Colors.white,tamanho: 22,);
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: MediaQuery.of(context).size.width * .13,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(1000)
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.all(3),
            child: iconeGambiarra,
          ),
          title: new LabelQuicksand( objeto['label'].toString() ,bold: true,tamanho: 22,),
          onTap: (){ Navigator.pop(context , objeto); },
        ),
        Divider(color: Colors.black87,),
      ],
    );
  }
}
