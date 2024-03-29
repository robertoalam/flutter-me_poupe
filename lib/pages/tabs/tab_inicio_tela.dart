import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/botao_adaptavel_widget.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/componentes/label/label_quicksand.dart';

import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/balancete_model.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/conta/cartao_model.dart';
import 'package:me_poupe/model/conta/conta_model.dart';
import 'package:me_poupe/pages/cartao/cartao_index_tela.dart';
import 'package:me_poupe/pages/conta/conta_list_tela.dart';

class TabInicioTela extends StatefulWidget {
  const TabInicioTela();
  @override
  _TabInicioTelaState createState() => _TabInicioTelaState();
}

class _TabInicioTelaState extends State<TabInicioTela> {

	BalanceteModel _balancete = new BalanceteModel();
    ContaModel _conta = new ContaModel();
    List<ContaModel> _contaLista = new List<ContaModel>();
	CartaoModel _cartao = new CartaoModel();
	List<CartaoModel> _cartaoLista = new List<CartaoModel>();

	Widget widgetTopo;
  Widget widgetConta;
	Widget widgetSaldo;
	Widget widgetCartoes;

	// CORES TELA
	String _modo = "normal";
	String _background = Funcoes.converterCorStringColor("#FFFFFF");
	String _colorContainerFundo = Funcoes.converterCorStringColor("#FFFFFF");
	String _colorContainerBorda = Funcoes.converterCorStringColor("#FFFFFF");
	String _colorFundo = Funcoes.converterCorStringColor("#FFFFFF");
	String _colorLetra = Funcoes.converterCorStringColor("#FFFFFF");

	String _imagem;
	var _dados = null;
	// SALDO
	String _saldoGeral ;
	bool _flagExibirSaldo = false;
	IconData _iconeExibirSaldo = Icons.remove_red_eye;
	int _saldoGeralNumeroCaracteres = 4;

    @override
    void initState() {
      _start();
      super.initState();
    }

  _start() async {
    await _getDataConfig();
    await _setDataConfig();
    await _getBalanceteGeral();
    await _getConta();
    await _getCartao();
  }

	_getCartao() async {
		_cartaoLista = await _cartao.fetchProtected(protected: 0);
		setState(() {
			_cartaoLista;
		});
	}

	_getBalanceteGeral() async {
		_balancete = await _balancete.balancoGeral(periodo: null);
		if( _balancete.receita != null && _balancete.despesa != null && _balancete.diferenca != null ){
      setState(() {
        _saldoGeralNumeroCaracteres = _balancete.diferenca.toStringAsFixed(2).length;
        _flagExibirSaldo = (_dados['exibir_saldo'] == "true")?true : false;
        _saldoGeral = (_dados['exibir_saldo'] == "true")? _balancete.diferenca.toStringAsFixed(2) :"------";
      });
    }
	}

   _getConta() async {
      _contaLista = await _conta.fetchByAll();
      setState(() { _contaLista; });
    }

	_setDataConfig() async {
		setState(() {
			_modo = _dados['modo'].toString();
			_background = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['background']);
			_colorContainerFundo = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['containerFundo']);
			_colorContainerBorda = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['containerBorda']);
			_colorLetra = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['textoPrimaria']);
		});
	}

	_getDataConfig() async {
		_dados = await ConfiguracaoModel.getConfiguracoes().then( (list) {
			return list;
		});
		return ;
	}

  @override
  Widget build(BuildContext context) {
    
    // SALDOS
    if( _balancete.receita == null || _balancete.despesa == null || _balancete.diferenca == null ){
      widgetSaldo = Text('');
    }else{
      widgetSaldo = Container(
        padding: EdgeInsets.all(15),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:  Color(int.parse(_colorContainerFundo)),
            border: Border.all(color: Color(int.parse(_colorContainerBorda)))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LabelOpensans("Saldo Atual ",cor:Color(int.parse(_colorLetra))),
                  LabelOpensans(" R\$ ${_saldoGeral}",bold: true,cor:Color(int.parse(_colorLetra))),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: LabelOpensans("Balancete",bold: true,tamanho: 25),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(int.parse(_colorLetra)),
                  child: Icon(Icons.person, color: Color(int.parse(_colorContainerFundo)),),
                ),
                title: LabelOpensans("Conta padrão",cor: Color(int.parse(_colorLetra)),),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LabelQuicksand("Geral",cor: Color(int.parse(_colorLetra))),
                    LabelQuicksand("R\$ ${_saldoGeral}",cor: Color(int.parse(_colorLetra)))
                  ],
                )
              ),
              Divider(),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(int.parse(_colorLetra)),
                  child: Icon(Icons.person, color: Color(int.parse(_colorContainerFundo)),),
                ),
                title: LabelOpensans("Poupança",cor: Color(int.parse(_colorLetra))),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LabelQuicksand("Banco do Brasil",cor: Color(int.parse(_colorLetra))),
                    LabelQuicksand("R\$ 2.500,00",cor: Color(int.parse(_colorLetra)))
                  ],
                )
              ),
              Divider(),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: RaisedButton(
                  onPressed: null,
                  child: LabelQuicksand("Ajustar Balanço",cor: Color(int.parse(_colorLetra))),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // SALDO
    if(_contaLista.length == 0 || _contaLista == null){

      widgetConta = Container(
        padding: EdgeInsets.all(15),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(int.parse(_colorContainerFundo)),
            borderRadius: BorderRadius.circular(10),
            border: Border.all( width: 1.0 , color: Color(int.parse(_colorContainerBorda)),),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Contas",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18 ,
                    color: Color(int.parse( _colorLetra) ),
                  ),
                ),
              ),
              SizedBox( height: 15, ),
              Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 128,height: 128,
                    child: Image.asset("assets/images/cofre_${_modo}.png"),
                  )
              ),
              SizedBox( height: 20, ),
              Align(
                child:Text("Escolha a instituição financeira de sua preferência" , style: TextStyle(
                  color: Color(int.parse( _colorLetra) ),
                ),
              ),
                alignment: Alignment.centerLeft,
              ),
              Align(
                child:Text("NÃO é necessário dados pessoais!", style: TextStyle(
                  color: Color(int.parse( _colorLetra) ),
                ),
              ),
                alignment: Alignment.centerLeft,
              ),              
              SizedBox( height: 20, ),
              Align(
                alignment: Alignment.bottomRight,
                child: BotaoAdptavelWidget(
                  label: "Adicionar conta" , onPressed: _contaAdicionar,
                  cor: Color(int.parse( _background )),
                ),
              ),
            ],
          ),
        ),
      );
    }

	// CARTOES
    if(_cartaoLista.length == 0){
      // SE AINDA NAO EXISTIR CONTA
      String cartaoDescricao ;
      if(_contaLista.length == 0){
        cartaoDescricao = "Para criar cartões é necessário primeiramente criar uma conta, para isso clique no botão acima";
      }else{
        cartaoDescricao = "Tenha facilmente um longo histórico das suas faturas dos seus cartões de crédito em um só lugar";
      }

      widgetCartoes = Container(
        padding: EdgeInsets.all(15),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(int.parse(_colorContainerFundo)),
            borderRadius: BorderRadius.circular(10),
            border: Border.all( width: 1.0 , color: Color(int.parse(_colorContainerBorda)),),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: LabelOpensans("Cartões de Creditos",bold: true,tamanho: 18,cor: Color(int.parse(_colorLetra)),),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 128,height: 128,
                    child: Image.asset("assets/images/cartoes_${_modo}.png"),
                  )
              ),
              Align(
                child:LabelOpensans("Escolha o seu cartao",tamanho: 20,cor:Color(int.parse(_colorLetra)),),
                alignment: Alignment.topCenter,
              ),
              SizedBox( height: 15 ),
              Align(
                child: LabelOpensans(cartaoDescricao , cor:Color(int.parse(_colorLetra)) ,),
                alignment: Alignment.topCenter,
              ),

              Visibility(
                visible: (_contaLista.length > 0)?true:false,
                child:Align(
                  child: BotaoAdptavelWidget(label: "Adicionar cartão" , onPressed: _cartaoAdicionar, ),
                  alignment: Alignment.topCenter,
                ),
              ),

            ],
          ),
        ),
      );

    }else if( _cartaoLista.length > 0){
      widgetCartoes = Container(
        padding: EdgeInsets.all(15),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all( width: 1.0 , color: Color(int.parse(_colorContainerBorda)),),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.credit_card , size: 25,),
                  LabelOpensans("Meus cartões",bold: true,tamanho: 25,cor:  Color(int.parse(_colorLetra)),),
                ],
              ),

              //LISTA DE CARTOES
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
                  children: [
                    for(var i = 0 ; i < _cartaoLista.length ; i++) cartaoList( context , _cartaoLista[i], i+1),
                  ],
                ),
              ),

              // ADICIONAR MAIS CARTOES
              GestureDetector(
                onTap:() async {
                  print('teste');
                  var retorno = await Navigator.push( context , MaterialPageRoute( builder: (context) => CartaoIndexTela() ) );
                  _start();
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      LabelQuicksand("Adicionar mais cartões",bold: true, cor: Color(int.parse(_colorLetra)),),
                      Icon(Icons.add_circle),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );


    }else{
      return Container(
        child: Center(
          child: LabelQuicksand("ERROR"),
        ),
      );
    }

    if(_dados != null){
      return Container(
        color: Color(int.parse(_background)),
        child: Column(
          children: [
            // widgetTopo,
            widgetSaldo,
            widgetConta,
            widgetCartoes,
          ],
        ),
      );
    }else{
      return Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

	_clicFlagMostrarSaldo() async {
		_flagExibirSaldo = !_flagExibirSaldo;
		if(_flagExibirSaldo){
			_iconeExibirSaldo = Icons.visibility;
			_saldoGeral = _balancete.diferenca.toStringAsFixed(2);
			// _saldoGeral = (_dados['exibir_saldo'] == "true")? _balancete.diferenca.toStringAsFixed(2) :"------";
		}else{
			_iconeExibirSaldo = Icons.visibility_off;
			String regex = "[^\W_]";
			_saldoGeral = _balancete.diferenca.toStringAsFixed(2).replaceAll(RegExp(regex),"-");
		}
		await ConfiguracaoModel.alterarExibirSaldo( _flagExibirSaldo );
		setState(() {
		  _iconeExibirSaldo;
		  _saldoGeral;
		});
	}

  Widget cartaoList(BuildContext context , CartaoModel objeto , int index){

    if( objeto.conta.banco.corCartao != null ){
      _colorFundo = Funcoes.converterCorStringColor( objeto.conta.banco.corCartao );
    }else if( (objeto.conta.banco.corTerciaria != null) && (objeto.conta.banco.corTerciaria != "#FFFFFF") ){
      _colorFundo = Funcoes.converterCorStringColor( objeto.conta.banco.corTerciaria );
    }else if( (objeto.conta.banco.corTerciaria != null) && (objeto.conta.banco.corSecundaria != "#FFFFFF") && (objeto.conta.banco.corTerciaria == "#FFFFFF") ){
      _colorFundo = Funcoes.converterCorStringColor( objeto.conta.banco.corSecundaria );
    }
    _colorLetra = Funcoes.converterCorStringColor( "#000000" );
    _imagem = "assets/images/bancos/logo/${objeto.conta.banco.id.toString()}.png";
    double valor = index * 10.0 * -1;

    return Container(
      transform: Matrix4.translationValues(0.0, valor, 0.0),
      // transform: Matrix4.translationValues(0.0, -20.0, 0.0),
      width: MediaQuery.of(context).size.width,
      height: 80,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [ 0.8, 0.95, 1.0 ],
          colors: [ Color(int.parse(_colorFundo)) , Color(int.parse(_colorFundo))  , Colors.black]
        ),
        borderRadius: BorderRadius.only( topRight: Radius.circular(10) , topLeft: Radius.circular(10) ),
        boxShadow: [ BoxShadow(color: Colors.black, blurRadius: 5.0), ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox( height: 24, width: 24,
                child: Image.asset(_imagem),
              ),
              SizedBox(width: 10,),
              LabelOpensans(objeto.conta.banco.descricao,tamanho: 22,cor: Color(int.parse(_colorLetra) ),bold: true,),
            ],
          ),
          LabelOpensans("Cartão tipo ${objeto.tipo.descricao}",cor: Color(int.parse(_colorLetra) ),bold: true,),
        ],
      ),
    );
  }

  _contaAdicionar(){
    Navigator.push( context , MaterialPageRoute( builder: (context) => ContaListTela() ) );
  }

  _cartaoAdicionar(){
    Navigator.push( context , MaterialPageRoute( builder: (context) => CartaoIndexTela() ) );
  }
}
