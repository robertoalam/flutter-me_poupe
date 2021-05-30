import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/componentes/modal_aviso_simples_widget.dart';
import 'package:me_poupe/helper/configuracoes_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/cad/cad_banco_model.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/conta/cartao_model.dart';
import 'package:me_poupe/model/conta/conta_model.dart';
import 'package:me_poupe/model/conta/conta_tipo_model.dart';
import 'package:me_poupe/pages/conta/edit/telas/conta_edit_banco_tela.dart';
import 'package:me_poupe/pages/conta/edit/telas/conta_edit_cartao_tela.dart';
import 'package:me_poupe/pages/conta/edit/telas/conta_edit_tipo_tela.dart';

import 'edit/telas/conta_edit_descricao_tela.dart';

class ContaEditTela extends StatefulWidget {

    final ContaModel conta;
    ContaEditTela({this.conta});

    @override
    _ContaEditTelaState createState() => _ContaEditTelaState();
}

class _ContaEditTelaState extends State<ContaEditTela> {

    final _formKey = GlobalKey<FormState>();
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    // CORES TELA
    String _modo = "normal";
    String _background = Funcoes.converterCorStringColor("#FFFFFF");
    String _colorAppBar = Funcoes.converterCorStringColor("#FFFFFF");
    String _colorContainerFundo = Funcoes.converterCorStringColor("#FFFFFF");
    String _colorContainerBorda = Funcoes.converterCorStringColor("#FFFFFF");
    String _colorFundo = Funcoes.converterCorStringColor("#FFFFFF");
    String _colorLetra = Funcoes.converterCorStringColor("#FFFFFF");

    // VARIAVEIS
    Widget _body;
    var _dados = null;
    bool _flagDadosCompletos = false;

    // CONTA
    ContaModel _conta = new ContaModel();
    String _descricaoAppBar = "";

    // BANCO
    final String _bancoTitulo = "Instituição financeira";
    String _bancoDescricao;
    bool _bancoFlagConcluido;

    // DESCRICAO
    final String _descricaoTitulo = "Descrição para conta";
    String _descricao;
    bool _descricaoFlagConcluido;

    // TIPO
    final String _tipoTitulo = "Tipo de conta";
    String _tipoDescricao = "Clique aqui para selecionar";
    bool _tipoFlagConcluido = false;

    // CARTAO
    List<CartaoModel> _cartaoLista = new List<CartaoModel>();
    final String _cartaoTitulo = "Cartões";
    bool _cartaoControleRota = false;
    String _cartaoDescricao = "Clique aqui para selecionar";
    bool _cartaoFlagConcluido = false;

    @override
    void initState() {
        super.initState();
        _start();
    }

    _start() async{
      if( widget.conta != null){
        // _bancoCadLista = _bancoCad.fetchById(widget.conta.banco.id);
        _descricaoAppBar = "Editar conta";
      }else{
        _descricaoAppBar = "Nova conta";

        _limparVariaveisBanco();
        _limparVariaveisDescricao();
        _limparVariaveisTipo();

      }

      await _getDataConfig();
      await _setDataConfig();
      await _getData();

      setState(() { _flagDadosCompletos = true; });
      return ;
    }

    _getData() async {
        if(widget.conta != null){
            _conta = widget.conta;
        }

    }

    _setDataConfig() async {
        setState(() {
            _background = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['background']);
            _colorAppBar = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['corAppBar']);
            _colorContainerFundo = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['containerFundo']);
            _colorContainerBorda = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['containerBorda']);
            _colorLetra = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['textoPrimaria']);
        });
    }

    _getDataConfig() async {
        _dados = await ConfiguracaoModel.getConfiguracoes().then((list) {
            return list;
        });
        return;
    }

    @override
    Widget build(BuildContext context) {

      final TextStyle styleTextError = TextStyle(
        fontWeight: FontWeight.bold ,
        color: Colors.red,
      );

      final appBar = AppBar(
        title: Text("${_descricaoAppBar}"),
        backgroundColor: Colors.indigo,
      );
      final alturaDisponivel = MediaQuery.of(context).size.height - appBar.preferredSize.height;

      if( !_flagDadosCompletos){
        _body = Center(
          child: CircularProgressIndicator(),
        );
      }else{
        _body = ListView(
          children: [
            // BANCO
            _linha(context , MdiIcons.bankOutline ,_bancoTitulo,_bancoDescricao , ContaBancoEditTela( _setarBanco , (_conta.banco != null)?_conta.banco:null ) , true ),
            _linha(context , Icons.edit ,_descricaoTitulo, _descricao , ContaEditDescricaoTela( _setarDescricao , (_conta.descricao != null)?_conta.descricao:null ) , true ),
            _linha(context , FontAwesomeIcons.piggyBank , _tipoTitulo, _tipoDescricao , ContaEditTipoTela( _setarTipo , (_conta.tipo != null)?_conta.tipo:null ) , true ),
            // _linha(context , FontAwesomeIcons.creditCard , _cartaoTitulo, _cartaoDescricao , ContaEditCartaoTela( _setarCartao , (_conta.cartoes != null)?_conta.cartoes:null ) , true ),
            _linhaCartoes(context , FontAwesomeIcons.creditCard , _cartaoTitulo, _cartaoDescricao , ContaEditCartaoTela( _setarCartao ) , _cartaoControleRota ),
          ],
        );
      }

      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_descricaoAppBar),
          backgroundColor: Color(int.parse(_colorAppBar) ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     if(_validarForm( context ) ){
        //       var retorno = await _salvar();
        //       // await _showDialog(context , retorno);
        //       var retornoModal = await showDialog(
        //         context: context,
        //         builder: (context) {
        //           return ModalMensagemSimplesWidget(
        //             context: context,
        //             mensagem: retorno['msg'],
        //             action: null,
        //             onSubmit: null,
        //             botaoTexto: null,
        //             botaoCor: null,
        //           );
        //         }
        //       );
        //       Navigator.push( context ,MaterialPageRoute( builder: (context) => ContaListTela() ) );
        //     }else{
        //       print('entrou 2');
        //       print('ERRO NA TELA');
        //     }
        //   },
        //
        //   backgroundColor: Color(int.parse( _colorAppBar) ),
        //   child: Icon(Icons.save , color: Colors.black, size: 32,),
        // ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Container(
                color: Color( int.parse(_colorContainerFundo ) ),
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: _body,
              )
          ),
        ),
      );
    }

    Widget _linha(BuildContext context ,IconData icone ,String titulo , String label , rota , bool rotaLiberada){
      return InkWell(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .15,
                    child: Icon(icone , size: 35,),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${titulo}" ,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          "${label}",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .05,
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
              SizedBox( height: 10,),
              Divider( color: Colors.black87)
            ],
          ),
        ),
        onTap: () async {
          if(rotaLiberada){
            var retorno = await Navigator.push( context ,MaterialPageRoute( builder: (context) => rota ) );
            if( rota.toString() == 'ContaBancoEditTela'){
              if(retorno == null) {
                // PERGUNTAR ANTES SE DESEJA LIMPAR O OBJETO
                _limparVariaveisBanco();
              }
            }

            if( rota.toString() == 'ContaEditCartaoTela'){
              if(retorno != null) {
                print('ENTROU');
                // PERGUNTAR ANTES SE DESEJA LIMPAR O OBJETO
                // _limparVariaveisBanco();
              }
            }
          }
        },
      );
    }

    Widget _linhaCartoes( BuildContext context ,IconData icone ,String titulo , String label , rota , bool rotaLiberada ){
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .15,
                  child: Icon(
                    icone , size: 35,
                    color: (rotaLiberada)?Colors.black: Colors.grey,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${titulo}" ,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: (rotaLiberada)?Colors.black: Colors.grey,
                        ),
                      ),
                      Text(
                        "${label}",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox( height: 20,),
            RaisedButton(
              color: Colors.purple,
              onPressed: () async {
                if( rotaLiberada ){
                  CartaoModel cartaoRetorno = await Navigator.push( context ,MaterialPageRoute( builder: (context) => rota ) );
                  if(cartaoRetorno != null){
                    await _setarCartao(cartaoRetorno);
                  }
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add , color: Colors.white,),
                  Text(
                    'Adicionar Cartão' ,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                // height: 200,
                child:ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    for(CartaoModel item in _cartaoLista) Container(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Color( int.parse( Funcoes.converterCorStringColor( _conta.banco.corCartao ) ) ),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * .1,
                                child: Image.asset( _conta.banco.imageAsset.toString() ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .65,
                                padding: EdgeInsets.fromLTRB(10, 0, 01, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.tipo.descricao , style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text( item.descricao != null ? item.descricao : "-"),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .05,
                                child: Icon( Icons.arrow_forward_ios , color: Colors.black,),
                              ),

                            ],
                          ),
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider( color: Colors.black87)
          ],
        ),
      );
    }

    _setarBanco(BancoCadModel objeto){
      if( objeto != null){
        setState(() {
          _conta.banco = objeto;
          _bancoDescricao = objeto.descricao;
          _bancoFlagConcluido = true;
          _cartaoControleRota = true;
        });
      }
    }

    _limparVariaveisBanco(){
      setState(() {
        _conta.banco = null;
        _bancoDescricao = "Clique aqui para selecionar";
        _bancoFlagConcluido = false;
      });
      return;
    }

    _setarDescricao(String objeto){
      if( objeto != null){
        setState(() {
          _conta.descricao = objeto.toString();
          _descricao = "Definido";
          _descricaoFlagConcluido = true;
        });
      }
    }
    _limparVariaveisDescricao(){
      setState(() {
        _conta.descricao = "";
        _descricao = "Clique aqui";
      });
      return;
    }

    _setarTipo(ContaTipoModel objeto){
      if( objeto != null ){
        setState(() {
          _conta.tipo = objeto;
          _tipoDescricao = objeto.descricao.toString();
          _tipoFlagConcluido = true;
        });
      }
    }

    _limparVariaveisTipo(){
      setState(() {
        // TIPO
        _tipoDescricao = "Clique aqui para selecionar";
        _tipoFlagConcluido = false;
      });
    }

    _setarCartao(CartaoModel cartao){
      _cartaoLista.add(cartao);
      setState(() { _cartaoLista; });
      print("CARTAO :${_cartaoLista.last.descricao}");
      print("TAMNAHO :${_cartaoLista.length}");
    }

    _validarForm(BuildContext context){
      bool error = false;
      if( _conta.banco == null) {
        error = true;
        _bancoFlagConcluido = true;
      }

      // if( _conta.tipo == null){
      //   error = true;
      //   _contaTipoValidate = true;
      // }
      // setState(() {
      //   _bancoFlagConcluido ; _contaTipoValidate;
      // });
      return !error;
    }

    _salvar() async {
        return await _conta.save();
    }

    // _setarTipoConta(ContaBancariaTipoModel objeto){
    //     if(objeto != null){
    //         _contaTipoDescricaoSelecionada = objeto.descricao;
    //         _conta.tipo = objeto;
    //     }else{
    //         // SETAR O PADRAO
    //         _conta.tipo = null;
    //         _contaTipoDescricaoSelecionada = "";
    //     }
    //
    //     setState(() { _contaTipoDescricaoSelecionada; });
    //
    // }

    // _cortinaTipoConta(BuildContext context){
    //     return  showModalBottomSheet(
    //         elevation: 0,
    //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    //         context: context,
    //         builder: (BuildContext context) {
    //             return Container(
    //                 // height: MediaQuery.of(context).size.height * .4,
    //                 decoration: BoxDecoration(
    //                     color: (_dados['modo'] == "normal")? Colors.white:Colors.grey,
    //                     borderRadius: BorderRadius.only(
    //                         topLeft: Radius.circular(20),
    //                         topRight: Radius.circular(20),
    //                     ),
    //                 ),
    //                 child: ListView(
    //                     children: [
    //                         for(ContaBancariaTipoModel objeto in _contaTipoLista) InkWell(
    //                             onTap: (){ Navigator.pop(context , objeto); },
    //                             child: Column(
    //                                 children: [
    //                                     Padding(
    //                                         padding: EdgeInsets.fromLTRB(5, 15, 0, 15),
    //                                         child: Text("${objeto.descricao}",style: TextStyle(color: Color(int.parse( _colorAppBar)), fontSize: 20.0) ),
    //                                     ),
    //                                     Visibility(
    //                                         visible: (objeto.id != _contaTipoLista.last.id)? true:false,
    //                                         child: Divider( color: Color(int.parse( _colorLetra)),),
    //                                     )
    //                                 ],
    //                             )
    //                         )
    //                     ],
    //                 ),
    //             );
    //         },
    //     );
    // }

    _opcaoModal(String opcao){
      print(opcao);
      if(opcao == 'voltar'){
        Navigator.pop(context);
      }
    }

    void _showDialog(BuildContext context , retorno) {
      final snackBar = SnackBar(content: Text(retorno['msg']));
      if(snackBar != null){
        _scaffoldKey.currentState.showSnackBar(snackBar);
        Timer( Duration(seconds: 3) , ()=>
            Navigator.pop(context, "foo"),
        );
      }
    }

    _exibirAviso(title,mensagem,botao,action) async {
      return await showDialog(
          context: context,
          builder: (context) {
            return ModalAvisoSimplesWidget(context,title,mensagem,action,textoBotao: (botao!=null)?botao.toString():null);
          }
      );
      // await Navigator.push( context ,MaterialPageRoute( builder: (context) => ModalAvisoSimplesWidget('Erro','Defina o tipo de conta') ) );
    }

}