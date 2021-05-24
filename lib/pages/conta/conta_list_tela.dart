import 'package:flutter/material.dart';
import 'package:me_poupe/helper/configuracoes_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/cad/cad_banco_model.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/conta/conta_model.dart';
import 'package:me_poupe/pages/bancos/banco_list_especial_tela.dart';

class ContaListTela extends StatefulWidget {
  @override
  _ContaListTelaState createState() => _ContaListTelaState();
}

class _ContaListTelaState extends State<ContaListTela> {

  var _dados = null;
  Widget _body;
  String modo;
  // CORES TELA
  String _background = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorAppBar = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorContainerFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorContainerBorda = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorLetra = Funcoes.converterCorStringColor("#FFFFFF");

  // CAD BANCOS
  BancoCadModel _bancoCad = new BancoCadModel();
  List<BancoCadModel> _bancoCadLista = new List<BancoCadModel>();

  ContaModel _conta = new ContaModel();
  List<ContaModel> _contaLista = List<ContaModel>();

  @override
  void initState() {
    _start();
  }

  _start() async {
    _contaLista = null;
    await _getDataConfig();
    await _setDataConfig();
    await _getData();
    // await _atualizar();
  }
  _atualizar(){
    setState(() {
      _contaLista;
    });
  }

  _getData() async {
    _contaLista = await _conta.fetchByAll();
    // _bancoCadLista = await _bancoCad.fetchByAll();
    _atualizar();
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
    setState(() { _dados; });
    return _dados;
  }

    @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Lista de contas'),
      backgroundColor: Color(int.parse(_colorAppBar) ),
    );
    final alturaDisponivel = MediaQuery.of(context).size.height - appBar.preferredSize.height;

    if( _contaLista == null && _dados != null) {
      modo = _dados['modo'].toString();
      print("modo: ${modo}");
      _body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 128, height: 128,
                child: Image.asset("assets/images/cofre_normal.png"),
              )
          ),
          SizedBox(height: 20,),
        ],
      );
    }else if( _contaLista != null && _dados != null ) {
      _body = ListView(
        children: [
          for(ContaModel objeto in _contaLista) _thumb(context , objeto),
        ],
      );
    }else{
      _body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      );
    }

    return Scaffold(
      appBar: appBar,
      floatingActionButton: InkWell(
        onTap: (){
          // Navigator.push( context ,MaterialPageRoute( builder: (context) => BancoListTela() ) );
          Navigator.push( context ,MaterialPageRoute( builder: (context) => BancoListEspecialTela() ) );
        },
        child: Container(
            padding: EdgeInsets.all(8),
            // width: MediaQuery.of(context).size.width * .5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color( int.parse(_colorAppBar ) ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.add ,
                  color: Color( int.parse( _colorFundo ) ),
                  size: 32,
                ),
                Text('Adicionar conta' , style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color( int.parse( _colorFundo ) ),
                  ),
                )
              ],
            )
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
              color: Color( int.parse(_colorContainerFundo ) ),
              height: alturaDisponivel,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: _body,
            )
        ),
      ),
    );
  }

  _thumb(BuildContext context , ContaModel objeto){

    String color;
    if (objeto.banco.corPrimaria != null && objeto.banco.corPrimaria == "#FFFFFF"){
      color = Funcoes.converterCorStringColor( objeto.banco.corSecundaria ) ;
    }else if( objeto.banco.corSecundaria != null && objeto.banco.corSecundaria == "#FFFFFF" ){
      color = Funcoes.converterCorStringColor( objeto.banco.corTerciaria );
    }else if( objeto.banco.corTerciaria != null && objeto.banco.corTerciaria == "#FFFFFF" ){
      color = Funcoes.converterCorStringColor( "#EEEEEE" );
    }else{
      color = Funcoes.converterCorStringColor( "#C1C1C1" );
    }
    color = Funcoes.converterCorStringColor( objeto.banco.corCartao ) ;

    return Container(
      child: InkWell(
        onTap: (){},
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              color: Color(int.parse(color)),
            ),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  objeto.banco.descricao ,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22 ,
                    color: Color( int.parse( Funcoes.converterCorStringColor( objeto.banco.corPrimaria.toString() ) ) ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios ,
                  size: 33,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
