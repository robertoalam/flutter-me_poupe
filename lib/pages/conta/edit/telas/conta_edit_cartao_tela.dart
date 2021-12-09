
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/label_simples_widget.dart';
import 'package:me_poupe/componentes/mascara_campos.dart';
import 'package:me_poupe/helper/configuracoes_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/cad/cad_cartao_tipo_model.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/conta/cartao_model.dart';

class ContaEditCartaoTela extends StatefulWidget {

  void Function(CartaoModel cartao) onSubmit;
  CartaoModel cartao;

  ContaEditCartaoTela(this.onSubmit ,{this.cartao});

  @override
  _ContaEditCartaoTelaState createState() => _ContaEditCartaoTelaState();
}

class _ContaEditCartaoTelaState extends State<ContaEditCartaoTela> {

  CartaoModel _cartao = new CartaoModel();
  CartaoTipoCadModel _cartaoTipo = new CartaoTipoCadModel();
  List<CartaoTipoCadModel> _listaCartaoTipo = new List<CartaoTipoCadModel>();

  // CartaoModel _cartao = new CartaoModel();
  // List<CartaoModel> _lista = new List<CartaoModel>();

  // CORES TELA
  String _background = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorAppBar = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorContainerFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorContainerBorda = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorLetra = Funcoes.converterCorStringColor("#FFFFFF");

  // VARIAVEIS
  Widget _body;
  var _dados = null;
  String _descricaoAppBar = "";
  // DESCRICAO
  TextEditingController _descricaoController = new TextEditingController();

  // TIPO
  String _cartaoTipoController = "";

  TextEditingController _saldoController = TextEditingController();
  TextEditingController _limiteController = TextEditingController();
  TextEditingController _diaFechamentoController = TextEditingController();
  TextEditingController _diaVencimentoController = TextEditingController();

  int _showTipoCartao = 0;
  bool _flagExibirBotaoSalvar = false;
  bool cartaoSemDefinicao = false;

  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  @override
  void initState() {
    _start();
  }

  _start() async {
    await _getDataConfig();
    await _setDataConfig();
    await _getData();
    _limparControlles();
    if(widget.cartao != null){

      _descricaoAppBar = "Editar cartão";
      _descricaoController.text = widget.cartao.descricao;
      _cartao = widget.cartao;
      _cartaoTipo = widget.cartao.tipo;
      _cartaoTipoController = _cartaoTipo.descricao;
      _showTipoCartao = widget.cartao.tipo.id;

      _saldoController.text = (_cartao.saldo != null)? _cartao.saldo.toString() :"";
      _limiteController.text = (_cartao.limite != null)? _cartao.limite.toString() :"";
      _diaFechamentoController.text = (_cartao.diaFechamento != null)? _cartao.diaFechamento.toString() :"";
      _diaVencimentoController.text = (_cartao.diaVencimento != null)? _cartao.diaVencimento.toString() :"";

      _flagExibirBotaoSalvar = true;
    }else{
      _descricaoAppBar = "Novo cartão";
    }

  }

  _limparControlles(){
    _descricaoController.text = "";
    _saldoController.text = "";
    _limiteController.text = "";
    _diaFechamentoController.text = "";
    _diaVencimentoController.text = "";
    return ;
  }

  _getData() async {
    _listaCartaoTipo = await _cartaoTipo.fetchByAll();
    setState(() { _listaCartaoTipo; });
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

    final appBar = AppBar(
      title: Text("${_descricaoAppBar}"),
      backgroundColor: Color(int.parse(_colorAppBar) ),
      actions: [
        InkWell(
          onTap: () async {
            var retorno = await _deletar();
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(00, 0, 15, 0),
            child: Icon(Icons.delete , color: Colors.white),
          ),
        ),
      ],
    );
    final alturaDisponivel = MediaQuery.of(context).size.height - appBar.preferredSize.height;
    final larguraDisponivel = MediaQuery.of(context).size.width;

    _body = ListView(
      children: [
        SizedBox(height: 15,),
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
                InkWell(
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
                    child: Text(_cartaoTipoController),
                  ),
                ),
              ],
            ),
          ],
        ),
        Divider(height: 25,),

      // PROPRIEDADES CARTAO DE CREDITO
      // CREDITO == 2
        Visibility(
            visible: (_showTipoCartao == 2)?true:false,
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
                      formatter: RealInputFormatter(),
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

        //PROPRIEDADES CARTAO DEBITO == 3
        Visibility(
          visible: (_showTipoCartao == 3)?true:false ,
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
                    formatter: RealInputFormatter(),
                    validate: false,
                  ),
                ],
              )
            ],
          ),
        ),

        //PROPRIEDADES CARTAO DEBITO == 4
        // VALES
        Visibility(
          visible: (_showTipoCartao == 4 || _showTipoCartao == 5)?true:false ,
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
                    formatter: RealInputFormatter(),
                    validate: false,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      floatingActionButton: Visibility(
        visible: (_flagExibirBotaoSalvar),
        child: Container(
          child: RaisedButton(
            onPressed: () async {
              CartaoModel retorno = await _salvar();
              Navigator.pop(context , retorno);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.save),
                SizedBox(height: 10,),
                Text('Salvar')
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(10),
            height: alturaDisponivel,
            width: larguraDisponivel,
            child: _body,
          ),
        ),
      ),
    );
  }

  _salvar(){
    _cartao.descricao = _descricaoController.text;
    _cartao.tipo = _cartaoTipo;
    _cartao.saldo = (_saldoController.text.isNotEmpty)? double.parse( Funcoes.converterMoedaParaDatabase( _saldoController.text.toString() ) ):null;
    _cartao.limite = (_limiteController.text.isNotEmpty ) ? double.parse( Funcoes.converterMoedaParaDatabase( _limiteController.text.toString() ) ): null;
    _cartao.diaFechamento = (_diaFechamentoController.text.isNotEmpty) ? int.parse( _diaFechamentoController.text.toString() ):null;
    _cartao.diaVencimento = (_diaVencimentoController.text.isNotEmpty) ?int.parse( _diaVencimentoController.text.toString() ): null;
    setState(() { _cartao; });
    return _cartao;
  }
  
  _showOptions( BuildContext context ){
    return showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _listaCartaoTipo.map( (objeto) =>
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: FlatButton(
                                child: Text( objeto.descricao ,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20.0
                                  )
                                ),
                                onPressed: (){
                                  _escolherCartao( objeto );
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Divider(height: 15,)
                          ],
                        )
                    ).toList(),
                  ),
                ),
              );
            },
          );
        }
    );
  }

  _escolherCartao(CartaoTipoCadModel objeto){
    if(objeto != null){
      setState(() {
        _flagExibirBotaoSalvar = true;
        _cartaoTipoController = objeto.descricao;
        _showTipoCartao = objeto.id;
        // showCartaoCredito = (objeto.id == 1)? true: false;
        // showCartaoDebito = (objeto.id == 2)? true: false;
        // cartaoSemDefinicao = true;

        _cartaoTipo = objeto;
      });
    }

  }

  _deletar(){

  }
}
