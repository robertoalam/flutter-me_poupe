import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/componentes/botao_adaptavel_widget.dart';
import 'package:me_poupe/componentes/label_opensans.dart';
import 'package:me_poupe/componentes/label_quicksand.dart';
import 'package:me_poupe/helper/configuracoes_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/balancete_model.dart';
import 'package:me_poupe/model/cartao_model.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/conta/conta_model.dart';
import 'package:me_poupe/pages/bancos/banco_destaque_tela.dart';
import 'package:me_poupe/pages/cartao/cartao_index_tela.dart';
import 'package:me_poupe/pages/configuracoes/configuracoes_index_tela.dart';

class TabInicioTela extends StatefulWidget {
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
        await _getConta();
        await _getBalanceteGeral();
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
		setState(() { 
			_saldoGeralNumeroCaracteres = _balancete.diferenca.toStringAsFixed(2).length;
			_flagExibirSaldo = (_dados['exibir_saldo'] == "true")?true : false;
			_saldoGeral = (_dados['exibir_saldo'] == "true")? _balancete.diferenca.toStringAsFixed(2) :"------"; 
		});
	}

   _getConta() async {
        _contaLista = await _conta.fetchByAll();
    }

	_setDataConfig() async {
		setState(() {
			_modo = _dados['modo'].toString();
			_background = Funcoes.converterCorStringColor( Configuracoes.cores[_dados['modo']]['background']);
			_colorContainerFundo = Funcoes.converterCorStringColor( Configuracoes.cores[_dados['modo']]['containerFundo']);
			_colorContainerBorda = Funcoes.converterCorStringColor( Configuracoes.cores[_dados['modo']]['containerBorda']);
			_colorLetra = Funcoes.converterCorStringColor( Configuracoes.cores[_dados['modo']]['textoPrimaria']);
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

    // TOPO
    widgetTopo = Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Padding(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
            child: Column(
              children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Row(
                        children: [
                            Text("Boa noite" , style: TextStyle(color: Colors.black),),
                            SizedBox(width: 5,),
                            LabelOpensans("Roberto !" , cor: Colors.black, tamanho: 20 ,bold: true,),
                        ],
                    ),
                    Row(
                        children: [
                            InkWell(
                                onTap: ( ) { _clicFlagMostrarSaldo();},
                                child: Icon( _iconeExibirSaldo, size: 45, ) ,
                            ),
                            SizedBox(width:5),
                            GestureDetector(
                                onTap: (){
                                    Navigator.push( context , MaterialPageRoute( builder: (context) => ConfiguracoesIndexTela() ) );
                                },
                                child: Column(
                                    children: [
                                        SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: Icon(MdiIcons.applicationCog, size: 45,)
                                        ),
                                    ],
                                )
                            ),

                        ],
                    ),
                ],
              ),
              SizedBox( height: 30, ),
            ]
          )
        )
      );
    
 

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
              
       
    }else{

        widgetConta = Container(
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
                        Text("Saldo Atual "),
                        LabelOpensans(" R\$ ${_saldoGeral}",bold: true,),
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
                    title: LabelOpensans("Conta padrão"),
                        subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text("Geral"),
                            Text("R\$ ${_saldoGeral}")
                        ],
                        )
                    ),
                    Divider(),
                    ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Color(int.parse(_colorLetra)),
                        child: Icon(Icons.person, color: Color(int.parse(_colorContainerFundo)),),
                    ),
                    title: Text("Poupança"),
                    subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text("Banco do Brasil"),
                        Text("R\$ 2.500,00")
                        ],
                    )
                    ),
                    Divider(),
                    Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: RaisedButton(
                        child: Text("Ajustar Balanço"),
                    ),
                    ),

                ],
                ),
            ),
        );

    }

	// CARTOES
    if(_cartaoLista.length == 0){
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
                child: Text("Cartões de Creditos",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18), ),
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
                child:Text("Escolha o seu cartao",style: TextStyle(fontSize: 20),),
                alignment: Alignment.topCenter,
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                child: Text("Tenha facilmente um longo histórico das suas faturas dos seus cartões de crédito em um só lugar"),
                alignment: Alignment.topCenter,
              ),
              Align(
                child: BotaoAdptavelWidget(label: "Adicionar cartão" , onPressed: _cartaoAdicionar, ),
                alignment: Alignment.topCenter,
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
                  LabelOpensans("Meus cartões",bold: true,tamanho: 25,),
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
            widgetTopo,
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
    if( objeto.banco.corCartao != null ){
      _colorFundo = Funcoes.converterCorStringColor( objeto.banco.corCartao );
    }else if( (objeto.banco.corTerciaria != null) && (objeto.banco.corTerciaria != "#FFFFFF") ){
      _colorFundo = Funcoes.converterCorStringColor( objeto.banco.corTerciaria );
    }else if( (objeto.banco.corTerciaria != null) && (objeto.banco.corSecundaria != "#FFFFFF") && (objeto.banco.corTerciaria == "#FFFFFF") ){
      _colorFundo = Funcoes.converterCorStringColor( objeto.banco.corSecundaria );
    }
    _colorLetra = Funcoes.converterCorStringColor( "#000000" );
    _imagem = "assets/images/bancos/logo/${objeto.banco.id.toString()}.png";
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
                  SizedBox(
                    height: 24, width: 24,
                    child: Image.asset(_imagem),
                  ),
                  SizedBox(width: 10,),
                  LabelOpensans(objeto.banco.descricao,tamanho: 22,cor: Color(int.parse(_colorLetra) ),bold: true,),
                ],
              ),
              LabelOpensans("Cartão tipo ${objeto.tipo.descricao}",cor: Color(int.parse(_colorLetra) ),bold: true,),
            ],
          ),
        );
  }

  _contaAdicionar(){
    Navigator.push( context , MaterialPageRoute( builder: (context) => BancoDestaqueTela() ) );
  }

  _cartaoAdicionar(){
    Navigator.push( context , MaterialPageRoute( builder: (context) => CartaoIndexTela() ) );
  }
}
