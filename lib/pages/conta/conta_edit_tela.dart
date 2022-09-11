import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/componentes/modal_aviso_simples_widget.dart';
import 'package:me_poupe/componentes/modal_dialog_widget.dart';

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
    String _corAppBarFundo = Funcoes.converterCorStringColor("#FFFFFF");
    String _colorContainerFundo = Funcoes.converterCorStringColor("#FFFFFF");
    String _colorContainerBorda = Funcoes.converterCorStringColor("#FFFFFF");
    String _colorFundo = Funcoes.converterCorStringColor("#FFFFFF");
    String _colorLetra = Funcoes.converterCorStringColor("#FFFFFF");

    // VARIAVEIS
    Widget _body;
    var _dados = null;
    bool _flagDadosCompletos = false;
    bool _flagBotaoSalvarExibir = false;

    // CONTA
    ContaModel _conta = new ContaModel();
    String _descricaoAppBar = "";

    // BANCO
    final String _bancoTitulo = "Instituição financeira";
    String _bancoDescricao;
    bool _bancoFlagConcluido;

    // DESCRICAO
    final String _descricaoTitulo = "Descrição para conta";
    String _descricao = "Clique aqui para selecionar";
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
    Icon _cartaoIconeController = Icon( Icons.arrow_forward_ios , color: Colors.black);

    @override
    void initState() {
        super.initState();
        _start();
    }

    _start() async{

      await _getDataConfig();
      await _setDataConfig();
      await _getData();

      setState(() { _flagDadosCompletos = true; });
      return ;
    }

    _getData() async {

      if( widget.conta != null){
        _descricaoAppBar = "Editar conta";

        _conta.id = widget.conta.id;

        //BANCO
        _conta.banco = widget.conta.banco;
        _bancoDescricao = _conta.banco.descricao;

        // CONTA DESCRICAO
        _conta.descricao = widget.conta.descricao;
        _descricao = _conta.descricao;

        // TIPO DE CONTA
        _conta.tipo = widget.conta.tipo;
        _tipoDescricao = _conta.tipo.descricao;

        // CARTOES
        _conta.cartoes = widget.conta.cartoes;
        _cartaoLista = _conta.cartoes;
        _cartaoControleRota = true;

        _flagBotaoSalvarExibir = true;
      }else{
        _descricaoAppBar = "Nova conta";

        _limparVariaveisBanco();
        _limparVariaveisDescricao();
        _limparVariaveisTipo();
        _flagBotaoSalvarExibir = false;
      }

    }

    _setDataConfig() async {
        setState(() {
            _background = Funcoes.converterCorStringColor(ConfiguracaoModel.cores[_dados['modo']]['background']);
            _corAppBarFundo = Funcoes.converterCorStringColor(ConfiguracaoModel.cores[_dados['modo']]['corAppBar']);
            _colorContainerFundo = Funcoes.converterCorStringColor(ConfiguracaoModel.cores[_dados['modo']]['containerFundo']);
            _colorContainerBorda = Funcoes.converterCorStringColor(ConfiguracaoModel.cores[_dados['modo']]['containerBorda']);
            _colorLetra = Funcoes.converterCorStringColor(ConfiguracaoModel.cores[_dados['modo']]['textoPrimaria']);
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
            _linha(context , Icons.edit ,_descricaoTitulo, _descricao , ContaEditDescricaoTela( _setarDescricao , (_conta.descricao != null)?_conta.descricao.toString():null ) , true ),
            _linha(context , FontAwesomeIcons.piggyBank , _tipoTitulo, _tipoDescricao , ContaEditTipoTela( _setarTipo , (_conta.tipo != null)?_conta.tipo:null ) , true ),
            _linhaCartoes(context , FontAwesomeIcons.creditCard , _cartaoTitulo, _cartaoDescricao , ContaEditCartaoTela( _setarCartao ) , _cartaoControleRota ),
            Divider(color:Colors.grey),
            SizedBox(height: 55,),
          ],
        );
      }

      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_descricaoAppBar),
          backgroundColor: Color(int.parse(_corAppBarFundo) ),
        ),
         floatingActionButton: Visibility(
           visible: _flagBotaoSalvarExibir,
           child: FloatingActionButton(
             onPressed: () async {
               await _clickBotaoSalvarConta();
             },
             backgroundColor: Color(int.parse( _corAppBarFundo )),
             child: Icon(Icons.save , color: Color(int.parse( _colorFundo) )),
           ),
         ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Icon(icone , size: 35,),
                        SizedBox(width: 30,),
                        Column(
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
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Icon( icone , size: 35,color: (rotaLiberada)?Colors.black: Colors.grey,),
                      SizedBox(width: 30,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${titulo.toString()}" ,
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
                                color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox( height: 20,),
            Align(
              alignment: Alignment.centerRight,
              child:RaisedButton(
                color: (rotaLiberada)?Colors.purple: Colors.grey,
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
                    SizedBox(width: 10,),
                    Text(
                      'Adicionar cartão' ,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // LISTA DE CARTOES DA CONTA
            for(CartaoModel item in _cartaoLista) _thumbCartao(context , item),
          ],
        ),
      );
    }

    _thumbCartao(BuildContext context , CartaoModel item){
      Widget bodyCard ;
      if( !item.deletadoFlag ){
        bodyCard = GestureDetector(
          onLongPress: (){
            setState(() { item.selecionado = !item.selecionado; });
          },
          onTap: () async {
            if(!item.selecionado){
              Navigator.push( context ,MaterialPageRoute( builder: (context) => ContaEditCartaoTela( _setarCartao , cartao: item ) ) );
            }else{
              await _clickBotaoDeletarCartao( context , item );
            }
          },
          child: Container(
            color: (item.selecionado)?Colors.red[200] : Colors.transparent,
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
                              item.tipo.descricao.toString().toUpperCase() ,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold ,
                                color: Color( int.parse( Funcoes.converterCorStringColor(_conta.banco.corPrimaria ) ) ),
                                shadows: [
                                  Shadow(
                                    color:  Colors.black.withOpacity( 1.0 ),
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 1.0,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox( height:  10,),
                            Text(
                              item.descricao != null ? item.descricao : "-" ,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox( height:  10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * .1,
                                  child: Text(
                                    'dia de venc.' ,
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                Text(
                                  item.diaVencimento != null ? item.diaVencimento.toString() : "- - ",
                                  style: TextStyle(
                                    fontFamily: "OpenSans",
                                    color:Colors.grey ,
                                    fontSize: 22 ,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color:  Colors.black.withOpacity( 1.0 ),
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .1,
                                  child: Text(
                                    'dia de fech.' ,
                                    style: TextStyle(
                                      color: Colors.white ,
                                    ),
                                  ),
                                ),
                                Text(
                                  item.diaFechamento != null ? item.diaFechamento.toString() : " - - " ,
                                  style: TextStyle(
                                    fontFamily: "OpenSans",
                                    color:Colors.grey ,
                                    fontSize: 22 ,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color:  Colors.black.withOpacity( 1.0 ),
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .05,
                        child: (item.selecionado)
                            ?
                        Icon(Icons.delete , color:Colors.red , size : 35)
                            :
                        Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                )
            ),
          ),
        );
      }else{
        bodyCard = Text('');
      }

      return bodyCard;
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
          _descricao = _conta.descricao;
          _descricaoFlagConcluido = true;
        });
      }
    }
    _limparVariaveisDescricao(){
      setState(() {
        _conta.descricao = "";
        _descricao = "Clique aqui para selecionar";
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


    _clickBotaoSalvarConta() async {
      var retorno = await _conta.save();
      await showDialog(
          context: context,
          useSafeArea: true,
          builder: (context) {
            return ModalDialogWidget(context , (retorno['status'] == 200)?"Sucesso !": "ERRO !!!", null , mensagem: (retorno['status'] != 200)?retorno['msg']:null,);
          }
      );
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
            return ModalAvisoSimplesWidget(context,title,mensagem,action,textoBotao: (botao!=null)?botao.toString():null , exibirBotaoCancelar: true,);
          }
      );
      // await Navigator.push( context ,MaterialPageRoute( builder: (context) => ModalAvisoSimplesWidget('Erro','Defina o tipo de conta') ) );
    }

    _clickBotaoDeletarCartao(BuildContext context ,CartaoModel item ) async {
      var retorno = await _exibirAviso('Deletar cartão', 'deseja deletar o carão selecionado !?','deletar', _handlerReturnClickBotaoDeletarCartao );
      if(retorno){
        // validar senao ha lancamentos com esse cartao
        // se houver nao pode deletar
        item.deletadoFlag = true;
        print("RETORNO: ${retorno}");
      }
      setState(() { _cartaoLista; });

    }

    _handlerReturnClickBotaoDeletarCartao(bool funcao ){
      return funcao;
    }

}
