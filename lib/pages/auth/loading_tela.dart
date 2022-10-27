import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';

class LoadingTela extends StatefulWidget {
  @override
  _LoadingTelaState createState() => _LoadingTelaState();
}

class _LoadingTelaState extends State<LoadingTela> {

  Widget _body;
  // CORES TELA
  var listaCores ;
  Color _corAppBarFundo =  Color( int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
  Color _background = Color( int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
  Color _colorContainerFundo = Color( int.parse(Funcoes.converterCorStringColor("#FFFFFF") ) );
  Color _colorContainerBorda = Color( int.parse(Funcoes.converterCorStringColor("#FFFFFF") ) );
  Color _colorFundo = Color( int.parse(Funcoes.converterCorStringColor("#FFFFFF") ) );
  Color _colorLetra = Color( int.parse(Funcoes.converterCorStringColor("#FFFFFF") ) );
  
  @override
  void initState() {
    _start();
    super.initState();
  }

  
  _start() async {
    await montarTela();
  }

  montarTela() async {
    listaCores = await ConfiguracaoModel.buscarEstilos;
    setState(() {
      _corAppBarFundo =  Color( int.parse( Funcoes.converterCorStringColor( listaCores['corAppBarFundo'] ) ) );
      _background = Color( int.parse(Funcoes.converterCorStringColor( listaCores['background'] ) ) );
      _colorContainerFundo = Color( int.parse(Funcoes.converterCorStringColor( listaCores['containerFundo'] ) ) ) ;
      _colorContainerBorda = Color( int.parse(Funcoes.converterCorStringColor( listaCores['containerBorda'] ) ) );
      _colorLetra = Color( int.parse(Funcoes.converterCorStringColor( listaCores['textoPrimaria'] ) ) );
    });
    return;
  }

  @override
  Widget build(BuildContext context) {

    _body = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 20,),
        LabelOpensans("sincronizando apliação ...",cor: _colorLetra,tamanho: 22,),
      ],
    );

    return Scaffold(
      backgroundColor: _background,
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5),
        child: _body
      ),
    );
  }
}
