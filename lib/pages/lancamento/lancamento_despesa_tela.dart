import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/componentes/datepicker_adaptavel.dart';
import 'package:me_poupe/componentes/icone_gambiarra.dart';
import 'package:me_poupe/componentes/label_opensans.dart';
import 'package:me_poupe/componentes/label_simples_widget.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/cad/cad_categoria_model.dart';
import 'package:me_poupe/model/cad/cad_frequencia_model.dart';
import 'package:me_poupe/model/cad/cad_frequencia_periodo_model.dart';
import 'package:me_poupe/model/cad/cad_lancamento_tipo_model.dart';
import 'package:me_poupe/model/cad/cad_pagamento_forma.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/configuracoes/icone_cad_model.dart';
import 'package:me_poupe/model/conta/cartao_model.dart';
import 'package:me_poupe/model/lancamento/lancamento_frequencia_model.dart';
import 'package:me_poupe/model/lancamento/lancamento_model.dart';
import 'package:me_poupe/model/lancamento/lancamento_pagamento_forma_model.dart';
import 'package:me_poupe/pages/lancamento/modal/lancamento_modal_categoria.dart';
import 'package:me_poupe/pages/lancamento/modal/lancamento_modal_frequencia.dart';

class LancamentoDespesaTela extends StatefulWidget {

  List<CartaoModel> listaCartao;
  List<FrequenciaPeriodoCadModel> listaFrequenciaPeriodo;
  LancamentoModel lancamento;
  LancamentoDespesaTela(this.listaCartao , this.listaFrequenciaPeriodo , {this.lancamento});

  @override
  _LancamentoDespesaTelaState createState() => _LancamentoDespesaTelaState();
}

class _LancamentoDespesaTelaState extends State<LancamentoDespesaTela> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // CORES TELA
  String _corTopoString ;
  String _corTopo = Funcoes.converterCorStringColor("#FFFFFF");
  String _background = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorContainerFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorContainerBorda = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorLetra = Funcoes.converterCorStringColor("#FFFFFF");

  var _dados;
  Color corTopo = Colors.purple;
  IconeCadModel _icone = new IconeCadModel();
  List<IconeCadModel> _listaIcones = new List<IconeCadModel>();

  // TIPO
  LancamentoTipoCadModel _tipo = new LancamentoTipoCadModel();
  List<LancamentoTipoCadModel> _listaTipo = List<LancamentoTipoCadModel>();

  // VALOR
  double _valorIntegral = 0.00;
  TextEditingController _valorController = new TextEditingController();

  // DESCRICAO
  TextEditingController _descricaoController = new TextEditingController();

  // CATEGORIA
  CategoriaCadModel _categoria = new CategoriaCadModel();
  CategoriaCadModel _lancamentoCategoria = new CategoriaCadModel();
  List<CategoriaCadModel> _listaCategoria = null;
  String _categoriaDescricaoController = "";
  IconeGambiarra categoriaIcone = null;

  // PAGAMENTO
  PagamentoFormaCadModel _pagamentoForma = new PagamentoFormaCadModel();
  List<PagamentoFormaCadModel> _pagamentoFormaLista = null;
  IconeGambiarra pagamentoIcone;
  String pagamentoDescricaoController;
  PagamentoFormaCadModel _lancamentoFormaPagamento = new PagamentoFormaCadModel();

  // CARTAO
  String cartaoIcone = "assets/images/bancos/logo/00.png";
  int _cartaoControllerId;
  String _cartaoControllerDescricao = "Clique Aqui";
  String _corCartaoInicial = Funcoes.converterCorStringColor("#FFFFFF");
  CartaoModel _lancamentoFormaPagamentocartao = new CartaoModel();

  // DATA
  DateTime _dataSelecionadaController = DateTime.now() ;

  // FREQUENCIA
  FrequenciaCadModel _frequenciaCad = new FrequenciaCadModel();
  List<FrequenciaCadModel> _listaFrequencia = new List<FrequenciaCadModel>();
  List<FrequenciaPeriodoCadModel> _listaFrequenciaPeriodo = null;
  String _frequenciaDescricaoController = "";
  FrequenciaModel _lancamentoFrequencia = new FrequenciaModel();

  // FREQUENCIA PERIODO
  FrequenciaPeriodoCadModel _frequenciaPeriodoCad = new FrequenciaPeriodoCadModel();

  //LOCAL
  String localizacaoDescricao = "";
  TextEditingController _localizacaoController = new TextEditingController();
  @override
  void initState() {
    prepararDados();
  }

  prepararDados() async {
    await _buscarDadosConfiguracao();
    await _definirCores();
    await _buscarLancamentoTipo();
    await _buscarCategorias();
    await _buscarPagamentosFormas();
    await buscarFrequencias();
    await _carregarVariaveis();
    await _atualizarVariavies();
  }

  _buscarLancamentoTipo() async {
    _listaTipo = await _tipo.fetchByAll();
    setState(() {
      _listaTipo;
    });
  }

  _carregarVariaveis() async {
    if(widget.lancamento == null){
      _setarDespesa();
      _setarValor(null);
      _setarDescricao(null);
      _setarCategoria(null);
      _setarPagamento(null);
      _setarFrequencia(null,null);


//      //CARREGAR TELA DEFAULT
//        // LISTA DE ICONES DE CATEGORIAS
//      _listaIcones = _icone.buscarLista;
//      _categoriaDescricaoController = "Clique aqui";
//      _lancamentoCartao = await _lancamentoCartao.fetchById(1);
//      _cartaoControllerDescricao = _lancamentoCartao.banco.descricao;
//
//      categoriaIcone = IconeGambiarra( new IconeCadModel(icone: 'help-02' , codigo: 0xe7b2 , familia: "MaterialIcons") , cor: Colors.black,tamanho: 26,);
//      cartaoIcone = "assets/images/bancos/logo/01.png";
//
//      // FREQUENCIA
//      _frequenciaCad = await _frequenciaCad.fetchById(1);
//      _frequenciaPeriodoCad = await _frequenciaPeriodoCad.fetchById(1);
//      _lancamentoFrequencia = new LancamentoFrequenciaModel( frequencia: _frequenciaCad , frequenciaPeriodo: _frequenciaPeriodoCad , quantidade: 1 , _valorIntegral: 0.00);
//      _frequenciaDescricaoController = _frequenciaCad.descricao;
    }else{
      print('ENTROU 2');
      //CARREGAR COM DADOS - EDICAO

    }

  }

  _atualizarVariavies(){
    setState(() {
      categoriaIcone;
      pagamentoIcone;
      cartaoIcone;
      _cartaoControllerDescricao;
      _frequenciaDescricaoController;
    });
  }

  _definirCores() {
    _corTopoString = ( _dados['modo'] == "normal" ) ? "#FF5C4A":"#7A0004";
    setState(() {
      _corTopo =  Funcoes.converterCorStringColor( _corTopoString );
      _background = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['background']);
      _colorFundo = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['background']);
      _colorContainerFundo = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['containerFundo']);
      _colorContainerBorda = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['containerBorda']);
      _colorLetra = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['textoPrimaria']);
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

  _buscarCategorias() async {
    _listaCategoria = await _categoria.fetchByAll();
    setState(() {
      _listaCategoria;
    });
    return;
  }

  _buscarPagamentosFormas() async {
    _pagamentoFormaLista = await _pagamentoForma.fetchByAll();
    setState(() {
      _pagamentoFormaLista;
    });
  }

  buscarFrequencias() async {
    _listaFrequencia = await _frequenciaCad.fetchByAll();
    _listaFrequenciaPeriodo = widget.listaFrequenciaPeriodo;
    setState(() {
      _listaFrequencia;
      _listaFrequenciaPeriodo;
    });
  }

  _validarListas(){
    if( _listaCategoria == null) return false;
    if( _listaFrequenciaPeriodo == null) return false;
    return true;
  }

  _validarIcones(){
    if( categoriaIcone == null ) return false;
    if( pagamentoIcone == null ) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var body;
    if(_dados != null && _validarListas() && _validarIcones()  ){
      body = Column(
        children: [
          // VALOR
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(int.parse(_corTopo)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LabelOpensans("-",cor: Colors.white,tamanho: 32,bold: true,),
                Row(
                  children: [
                    // LabelOpensans(_valorIntegral.toString(),cor: Colors.white,tamanho: 32,bold: true,),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(int.parse(_corTopo)),
                      ),
                      width: MediaQuery.of(context).size.width * .7,
                      child: TextFormField(
                        onChanged: (value) => _setarValor(double.parse(value)),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 32 , fontWeight: FontWeight.bold,color: Colors.white,fontFamily: "OpenSans"),
                        controller: _valorController,
                        decoration: InputDecoration(
                          hintText: '0.00' ,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.attach_money , color: Colors.white,size: 32,),
                  ],
                )
              ],
            ),
          ),
          Flexible(
           child: SingleChildScrollView(
             physics: BouncingScrollPhysics(),
             child:  Container(
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   // DESCRICAO
                   Container(
                     padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         LabelSimples("Descrição" , tamanho: 16.0,),
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Padding(
                               padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
//                               child: Icon(Icons.edit),
                               child: IconeGambiarra( new IconeCadModel(icone: 'carrinho-01' , codigo: 0xf0110, familia:'Material Design Icons' , pacote: 'material_design_icons_flutter',),cor: Colors.black,tamanho: 22,),
                             ),
                             SizedBox(width: 10,),
                             Container(
                               padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                               height: 40,
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
                   ),
                   Divider(height: 15,),

                   // CATEGORIA
                   Container(
                     padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         LabelSimples("Categoria" , tamanho: 16.0,),
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Padding(
                               padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                               child: categoriaIcone,
                             ),
                             SizedBox(width: 10,),
                             GestureDetector(
                               onTap: () async {
                                 var retorno = await _modalCategoria( context );
                                 _setarCategoria(retorno);
                               },
                               child: Container(
                                 padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                                 height: 40,
                                 width: MediaQuery.of(context).size.width * .8,
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(10),
                                     border: Border.all(color: Colors.grey)
                                 ),
                                 child: Text(_categoriaDescricaoController),
                               ),
                             ),
                           ],
                         ),
                       ],
                     ),
                   ),
                   Divider(height: 15,),


                 //PAGAMENTO
                   Container(
                     padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         LabelSimples("Forma de Pagamento" , tamanho: 16.0,),
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Padding(
                               padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                               child: Container(
                                 padding:EdgeInsets.all(3),
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(20),
                                   // color: Color(int.parse( _corCartaoInicial )),
                                 ),
                                 child: SizedBox(
                                   width: 24,
                                   height: 24,
                                   child: pagamentoIcone,
                                 ),
                               ),
                             ),
                             SizedBox(width: 10,),
                             GestureDetector(
                               onTap: () async {
                                 var retorno = await _cortinaPagamento( context );
                                 if(retorno != null){
                                   _setarPagamento(retorno);
                                 }
                               },
                               child: Container(
                                 padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                                 height: 40,
                                 width: MediaQuery.of(context).size.width * .8,
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(10),
                                     border: Border.all(color: Colors.grey)
                                 ),
                                 child: Text(pagamentoDescricaoController),
                               ),
                             ),
                           ],
                         ),
                       ],
                     ),
                   ),
                   Divider(height: 15,),

                   // CARTAO
                   Visibility(
                     visible: (_lancamentoFormaPagamento.id == 2)? true : false,
                     child:  Container(
                       padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           LabelSimples("Cartão" , tamanho: 16.0,),
                           Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Padding(
                                 padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                 child: Container(
                                   padding:EdgeInsets.all(3),
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(20),
                                     color: Color(int.parse( _corCartaoInicial )),
                                   ),
                                   child: SizedBox(
                                     width: 24,
                                     height: 24,
                                     child: Image.asset(cartaoIcone) ,
                                   ),
                                 ),
                               ),
                               SizedBox(width: 10,),
                               GestureDetector(
                                 onTap: () async {
                                   var retorno = await _modalCartao( context );
                                   if(retorno != null){
                                     // _adicionarCartao(retorno);
                                     _setarCartao(retorno);
                                   }
                                 },
                                 child: Container(
                                   padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                                   height: 40,
                                   width: MediaQuery.of(context).size.width * .8,
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(10),
                                       border: Border.all(color: Colors.grey)
                                   ),
                                   child: Text(_cartaoControllerDescricao),
                                 ),
                               ),
                             ],
                           ),
                           Divider(height: 15,),
                         ],
                       ),
                     ),
                   ),


                   // DATA
                   Container(
                     padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         LabelSimples("Data" , tamanho: 16.0,),
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Padding(
                               padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                               child: Icon(Icons.calendar_today),
                             ),
                             SizedBox(width: 10,),
                             Container(
                               padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                               height: 40,
                               width: MediaQuery.of(context).size.width * .8,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10),
                                   border: Border.all(color: Colors.grey)
                               ),
                               // child: Text(_cartaoControllerDescricao),
                               child: DatepickerAdaptative(
                                 dataSelecionadaController: _dataSelecionadaController,
                                 onDateChanged: (newDate) {
                                   setState(() {
                                     _dataSelecionadaController = newDate;
                                   });
                                 },
                               ),
                             ),
                           ],
                         ),
                       ],
                     ),
                   ),
                   Divider(height: 15,),

                   // FREQUENCIA
                   Container(
                     padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         LabelSimples("Frequência" , tamanho: 16.0,),
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Padding(
                               padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                               child: Icon(Icons.refresh),
                             ),
                             SizedBox(width: 10,),
                             GestureDetector(
                               onTap: () async {
                                 FrequenciaCadModel frequencia = await _cortinaFrequencia( context );
                                 if(frequencia != null) {
                                   if(frequencia.id == 1){
                                     FrequenciaPeriodoCadModel periodo = new FrequenciaPeriodoCadModel();
                                     periodo = await periodo.fetchById(1);
                                     Map<String,dynamic> retornoCortina = Map();
                                     retornoCortina['quantidade'] = 1;
                                     retornoCortina['periodo'] = periodo;
                                     _setarFrequencia( frequencia , retornoCortina );
                                   }else if (frequencia.id > 1) {
                                     var retornoModal = await _modalFrequencia( context , frequencia , _listaFrequenciaPeriodo);
                                     _setarFrequencia( frequencia, retornoModal );
                                   }
                                 }
                               },
                               child: Container(
                                 padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                                 height: 40,
                                 width: MediaQuery.of(context).size.width * .7,
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(10),
                                     border: Border.all(color: Colors.grey)
                                 ),
                                 child: Text( _frequenciaDescricaoController ),
                               ),
                             ),
                             SizedBox(width: 10,),
                             GestureDetector(
                               child: Container(
                                 padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                 child: Icon(Icons.help),
                               ),
                             )
                           ],
                         ),
                       ],
                     ),
                   ),
                   Divider(height: 15,),

                   // LOCALIZACAO
                   Container(
                     padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         LabelSimples("Local" , tamanho: 16.0,),
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Padding(
                               padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                               child: Icon(MdiIcons.mapMarker),
                             ),
                             SizedBox(width: 10,),
                             Container(
                               padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                               height: 40,
                               width: MediaQuery.of(context).size.width * .8,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10),
                                   border: Border.all(color: Colors.grey)
                               ),
                               child: TextFormField(
                                 controller: _localizacaoController,
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
                   ),
                   SizedBox( height: 25,)
                 ],
               ),
             ),
           ),
          ),
        ],
      );
    }else{
      body = Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor:  Color(int.parse(_corTopo)),
        child: Icon(Icons.save , color: Colors.white,),
        onPressed: (){
          if(_validarForm() ){
            _salvar();
          }
        },
      ),
      backgroundColor: Color(int.parse(_colorFundo)),
      body: body,
    );
  }

  _modalCategoria(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return LancamentoModalCategoria( _listaCategoria );
        }
    );
  }

  _modalCartao(BuildContext context) async {
    // 20210524
    // if( widget.listaCartao.length > 0 ){
    //   return await showDialog(
    //       context: context,
    //       builder: (context) {
    //         return LancamentoModalCartao( widget.listaCartao );
    //       }
    //   );
    // }
    return;
  }

  _cortinaPagamento( BuildContext context ){
    return showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for(PagamentoFormaCadModel objeto in _pagamentoFormaLista) Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: FlatButton(
                            child: Text( objeto.descricao ,style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20.0) ),
                            onPressed: (){
                              Navigator.pop(context , objeto);
                            },
                          ),
                        ),
                        Divider(height: 25,)
                      ],
                    )
                  ],
                ),
              );
            },
          );
        }
    );
  }

  _cortinaFrequencia( BuildContext context ){
    return showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for(FrequenciaCadModel objeto in _listaFrequencia) Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: FlatButton(
                            child: Text( objeto.descricao ,style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20.0) ),
                            onPressed: (){
                              Navigator.pop(context , objeto);
                            },
                          ),
                        ),
                        Divider(height: 25,)
                      ],
                    )
                  ],
                ),
              );
            },
          );
        }
    );
  }

  _modalFrequencia(BuildContext context, FrequenciaCadModel frequencia , List<FrequenciaPeriodoCadModel> periodos) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return LancamentoModalFrequencia( frequencia , periodos );
        }
    );
  }

  _setarDespesa(){
    _tipo = _listaTipo[0];
  }

  _setarValor(double valor){
   if(valor !=null){
     _valorIntegral = valor;
   }
   setState(() {
     _valorIntegral;
   });
  }

  _setarDescricao(String descricao){
    if(descricao !=null){

    }
  }

  _setarCategoria(CategoriaCadModel objeto) async {
    var icone;
    if(objeto !=null){
      _categoriaDescricaoController = objeto.descricao;
      icone = new IconeCadModel.find(objeto.icone);
      categoriaIcone = IconeGambiarra( icone , cor: Colors.black,tamanho: 22,);
      _lancamentoCategoria = objeto;

    }else{
      _categoriaDescricaoController = "Clique aqui";
      icone = new IconeCadModel.find('help-02');
      categoriaIcone = IconeGambiarra( icone , cor: Colors.black,tamanho: 22,);
      _lancamentoCategoria = await _categoria.fetchById( 1 );
    }
    setState(() {
      _categoriaDescricaoController;
      categoriaIcone;
    });
  }

  _setarPagamento(PagamentoFormaCadModel objeto) async {
    var icone;
    if(objeto != null){
      icone = new IconeCadModel.find(objeto.icone);
      pagamentoIcone = IconeGambiarra( icone , cor: Colors.black, tamanho: 22, );
      pagamentoDescricaoController = objeto.descricao;
      _lancamentoFormaPagamento = objeto;
    }else{
      // SETAR O PADRAO
      objeto = await _pagamentoForma.fetchById(1);
      icone = new IconeCadModel.find( objeto.icone );
      pagamentoIcone = IconeGambiarra( icone , cor: Colors.black, tamanho: 22, );
      pagamentoDescricaoController = objeto.descricao;
      _lancamentoFormaPagamento = objeto;
    }

    setState(() {
      _lancamentoFormaPagamento;
      pagamentoIcone;
      pagamentoDescricaoController;
    });
  }

  _setarCartao(CartaoModel objeto) async {
    if( objeto != null ){
      // 20210524
      // cartaoIcone = objeto.banco.imageAsset;
      // _corCartaoInicial = Funcoes.converterCorStringColor( objeto.banco.corCartao );
      // _cartaoControllerDescricao = "${objeto.banco.descricao} - ${objeto.tipo.descricao}";
      // _lancamentoFormaPagamentocartao = objeto;
    }

    setState(() {
      _corCartaoInicial;
      cartaoIcone;
      _cartaoControllerDescricao;
    });
  }

  _setarFrequencia(FrequenciaCadModel frequencia , objeto) async {
    print("frequencia: ${frequencia}");
    if( frequencia !=null && objeto != null){
      _lancamentoFrequencia.frequencia = frequencia;

      FrequenciaPeriodoCadModel periodo;
      int quantidade;
      if( objeto['periodo'] == null){
        FrequenciaPeriodoCadModel periodo = FrequenciaPeriodoCadModel();
        _frequenciaPeriodoCad = await _frequenciaPeriodoCad.fetchById(1);
        quantidade = 1;
      }else{
        quantidade = int.parse( objeto['quantidade'].toString() );
        periodo = objeto['periodo'];
      }
      _lancamentoFrequencia.frequenciaPeriodo = _frequenciaPeriodoCad;
      _lancamentoFrequencia.quantidade = quantidade;
      _lancamentoFrequencia.valorIntegral = _valorIntegral;
      _frequenciaDescricaoController = "${frequencia.descricao}(${quantidade}) - ${periodo.descricao}";
    }else{

      _frequenciaCad = await _frequenciaCad.fetchById(1);
      _frequenciaPeriodoCad = await _frequenciaPeriodoCad.fetchById(1);

      _lancamentoFrequencia.frequencia = _frequenciaCad;
      _lancamentoFrequencia.frequenciaPeriodo = _frequenciaPeriodoCad;
      _lancamentoFrequencia.quantidade = 1;
      _lancamentoFrequencia.valorIntegral = 0.00;
      _frequenciaDescricaoController = "${_frequenciaCad.descricao} - ${_frequenciaPeriodoCad.descricao}";
    }

    setState(() {
      _frequenciaDescricaoController ;
    });
  }
  _salvar() async {

    PagamentoFormaCadModel pagamento = PagamentoFormaCadModel();

    LancamentoModel lancamento = new LancamentoModel(
      chaveUnica: Funcoes.gerarIdentificador(1.toString()),
      tipo: _tipo,
      descricao: _descricaoController.text,
      categoria: new CategoriaCadModel(
        id: _lancamentoCategoria.id
      ),
      pagamento: PagamentoModel(
        pagamentoForma: _lancamentoFormaPagamento,
        cartao: _lancamentoFormaPagamentocartao,
      ),
      data: _dataSelecionadaController,
      frequencia: FrequenciaModel(
        frequencia: _lancamentoFrequencia.frequencia,
        frequenciaPeriodo: _lancamentoFrequencia.frequenciaPeriodo,
        quantidade: _lancamentoFrequencia.quantidade,
        valorIntegral: _valorIntegral,
      )
    );

    await lancamento.save();

  }

  _validarForm(){
    print('ENTROU');
    return true;
  }
}
