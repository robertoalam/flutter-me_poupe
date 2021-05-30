import 'dart:async';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/label_simples_widget.dart';
import 'package:me_poupe/componentes/mascara_campos.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/cad/cad_banco_model.dart';
import 'package:me_poupe/model/cad/cad_cartao_tipo_model.dart';
import 'package:me_poupe/model/conta/cartao_model.dart';
import 'package:me_poupe/model/conta/conta_model.dart';

class CartaoEditTela extends StatefulWidget {

  final BancoCadModel bancoModel;
  final CartaoModel cartao;

  CartaoEditTela({this.cartao, this.bancoModel});

  @override
  _CartaoEditTelaState createState() => _CartaoEditTelaState();
}

class _CartaoEditTelaState extends State<CartaoEditTela> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CartaoModel _cartao = new CartaoModel();
  CartaoTipoCadModel _cartaoTipo = new CartaoTipoCadModel();
  List<CartaoTipoCadModel> _listaCartaoTipo = new List<CartaoTipoCadModel>();

  ContaModel conta = new ContaModel();
  // CartaoTipoCadModel _cartaoTipo = new CartaoTipoCadModel();
  // List<CartaoTipoCadModel> _listaCartaoTipo = new List<CartaoTipoCadModel>();

  String _color;
  String _imagem;
  String _bancoDescricao;
  String cartaoTipoController;
  TextEditingController _descricaoController = new TextEditingController();
  bool showCartaoCredito = false;
  bool showCartaoDebito = false;
  bool cartaoSemDefinicao = false;

  final _saldoController = TextEditingController();
  final _limiteController = TextEditingController();
  final _diaFechamentoController = TextEditingController();
  final _diaVencimentoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cartaoTipoController = "Clique aqui";
    _carregarTipoCartao();
    if(widget.cartao != null){
      _carregarBancoTela( widget.bancoModel );
    }
  }
  _carregarTipoCartao() async {
    _listaCartaoTipo = await _cartaoTipo.fetchByAll();
    setState(() {
      _listaCartaoTipo;
    });
  }
  _carregarBancoTela(BancoCadModel banco){
    _color = (banco.corSecundaria != null )? Funcoes.converterCorStringColor( banco.corSecundaria ) :  Funcoes.converterCorStringColor( "#FFFFFF" );
    _imagem = "assets/images/bancos/logo/${banco.id.toString()}.png";
    _bancoDescricao = banco.descricao;

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Novo Cartão"),
      ),

      floatingActionButton: Visibility(
        visible: cartaoSemDefinicao,
        child: FloatingActionButton(
          onPressed: () async {
            var retorno = await _salvar();
            _showDialog(context , retorno);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.save , size: 40, color: Colors.white,),
        ),
      ),

      body: SafeArea(

        child: Padding(
          padding: EdgeInsets.all(15),
          child:
          ListView(
            children: [
              SizedBox(height: 15,),

              // INSTITUICAO
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelSimples("Instituição financeira", tamanho: 19.0,),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:  Color(int.parse(_color)),
                        radius: 20,
                        child: SizedBox(
                          height: 24, width: 24,
                          child: Image.asset(_imagem),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(_bancoDescricao,style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(height: 25,),

              // DESCRICAO
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelSimples("Descrição" , tamanho: 19.0,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                        child: Icon(Icons.credit_card),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        height: 50,
                        width: MediaQuery.of(context).size.width * .8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)
                        ),
                        child: TextFormField(
                          controller: _descricaoController,
                          decoration: InputDecoration(
                            hintText: "opcional",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(height: 25,),

              // TIPO DE CARTAO
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelSimples("Tipo de cartão" , tamanho: 19.0,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                        child: Icon(Icons.credit_card),
                      ),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () {
                          _showOptions( context );
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          height: 50,
                          width: MediaQuery.of(context).size.width * .8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey)
                          ),
                          child: Text(cartaoTipoController),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(height: 25,),

//              PROPRIEDADES CARTAO DEBITO
              Visibility(
                visible: showCartaoDebito && cartaoSemDefinicao ,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelSimples("Saldo" , tamanho: 19.0,),
                        CampoMascarado(
                          controller: _saldoController,
                          text: null,
                          hint: null,
                          label: 'R\$ 0,00',
                          icone: Icon(Icons.attach_money , color: Colors.grey,),
                          formatter: RealInputFormatter(centavos: true),
                          validate: false,
                        ),
                      ],
                    )
                  ],
                ),
              ),


//            PROPRIEDADES CARTAO DE CREDITO
              Visibility(
                visible: showCartaoCredito  && cartaoSemDefinicao,
                child:
                // LIMITE
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelSimples("Limite de crédito" , tamanho: 19.0,),
                        CampoMascarado(
                          controller: _limiteController,
                          text: null,
                          hint: null,
                          label: 'R\$ 0,00',
                          icone: Icon(Icons.attach_money , color: Colors.grey,),
                          formatter: RealInputFormatter(centavos: true),
                          validate: false,
                        ),
                      ],
                    ),
                    Divider(height: 25,),
                    // DIA DE FECHAMENTO
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelSimples("Dia de fechamento", tamanho: 19.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                              child: Icon(Icons.calendar_today),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              height: 50,
                              width: 40,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  border: OutlineInputBorder(),
                                  counter: Offstage(),
                                ),
                                controller: _diaFechamentoController,
                                keyboardType: TextInputType.numberWithOptions(decimal: false),
                                maxLength: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(height: 25,),

                    // DIA DE VENCIMENTO
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelSimples("Dia de vencimento", tamanho: 19.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                              child: Icon(Icons.calendar_today),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              height: 50,
                              width: 40,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  border: OutlineInputBorder(),
                                  counter: Offstage(),
                                ),
                                controller: _diaVencimentoController,
                                keyboardType: TextInputType.numberWithOptions(decimal: false),
                                maxLength: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ),

            ],
          ),
        ),
      ),
    );
  }

  _showOptions( BuildContext context ){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children:
                      _listaCartaoTipo.map( (objeto) =>

                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: FlatButton(
                                child: Text( objeto.descricao ,style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20.0) ),
                                onPressed: (){
                                  _escolherCartao( objeto );
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Divider(height: 25,)
                          ],
                        )
                      ).toList(),

                ),
              );
            },
          );
        }
    );
  }
  _escolherCartao(CartaoTipoCadModel objeto){
    setState(() {
      showCartaoCredito = (objeto.id == 1)? true: false;
      showCartaoDebito = (objeto.id == 2)? true: false;
      cartaoSemDefinicao = true;
      cartaoTipoController = objeto.descricao;
      _cartaoTipo = objeto;
    });
  }
  _salvar(){
    _cartao.id = null;
    // _cartao.banco = widget.bancoModel;
    // _cartao.conta = widget.conta;
    _cartao.descricao = _descricaoController.text;
    _cartao.tipo = _cartaoTipo;
    _cartao.saldo = ( _saldoController.text.toString().length > 0 ) ? double.parse( Funcoes.converterMoedaParaDatabase(_saldoController.text.toString() ) ) : null;
    _cartao.diaFechamento = ( _diaFechamentoController.text.toString().length > 0) ? int.parse( _diaFechamentoController.text.toString() ) : 0;
    _cartao.diaVencimento =  ( _diaVencimentoController.text.toString().length > 0) ? int.parse( _diaVencimentoController.text.toString() ) : 0;
    var retorno = Map();
    retorno['msg'] = "Erro !";
    retorno['status'] = 500;
    if(_cartao.save()){
      retorno['msg'] = "Sucesso !";
      retorno['status'] = 200;
    }
    return retorno;
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
}
