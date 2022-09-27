import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/componentes/label/label_quicksand.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TesteVariaveisConstantes extends StatefulWidget {
  const TesteVariaveisConstantes();

  @override
  State<TesteVariaveisConstantes> createState() => _TesteVariaveisConstantesState();
}

class _TesteVariaveisConstantesState extends State<TesteVariaveisConstantes> {
  Widget _body;

  // CORES TELA
	var listaCores ;
	Color _corAppBarFundo = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorBackground = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorContainerFundo = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorContainerBorda = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorFundo = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorLetra = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );

  ConfiguracaoModel _config = new ConfiguracaoModel();
  Map<String,dynamic> _configuracoesLista = new Map<String,dynamic>();
  bool _flagPesquisar = false;
  
  
  List<Map<String,dynamic>> _listagemSharedPreferences = new List<Map<String,dynamic>>();
  List<Map<String,dynamic>> _listagemConfiguracaoConstante = new List<Map<String,dynamic>>();
  List<Map<String,dynamic>> _listagemConfiguracaoDatabase = new List<Map<String,dynamic>>();

  @override
  void initState() {
    _start();
    super.initState();
  }
	  
	_start() async { 
    _listagemConfiguracaoDatabase.clear();
    _listagemSharedPreferences.clear();
    _listagemConfiguracaoConstante.clear();
    await montarTela(); 
    await buscarDados();
  }
	
  buscarDados() async {
    setState(() {  });
    _listagemConfiguracaoDatabase = await ConfiguracaoModel.getConfiguracoesLista;

    (await ConfiguracaoModel.sharedPreferencesBuscarDados).forEach((key, value) { 
      Map<String,dynamic> constante = new Map<String,dynamic>();
      constante['chave'] = key;
      constante['valor'] = value;
      _listagemSharedPreferences.add(constante);
    });

    (await ConfiguracaoModel.buscarConstantesAmbiente).forEach((key, value) { 
      Map<String,dynamic> constante = new Map<String,dynamic>();
      constante['chave'] = key;
      constante['valor'] = value;
      _listagemConfiguracaoConstante.add( constante );
    });
    setState(() {  });    
  }

	montarTela() async {
		listaCores = await ConfiguracaoModel.buscarEstilos;
		setState(() {
		  _corAppBarFundo = Color(int.parse( Funcoes.converterCorStringColor( listaCores['corAppBarFundo'] ) ) );
		  _colorBackground = Color(int.parse( Funcoes.converterCorStringColor( listaCores['background'] ) ) );
		  _colorContainerFundo = Color(int.parse( Funcoes.converterCorStringColor( listaCores['containerFundo'] ) ) );
		  _colorContainerBorda = Color(int.parse( Funcoes.converterCorStringColor( listaCores['containerBorda'] ) ) );
		  _colorLetra = Color(int.parse( Funcoes.converterCorStringColor( listaCores['textoPrimaria'] ) ) );
		});
		return;
	}

  @override
  Widget build(BuildContext context) {
    
    if( _listagemConfiguracaoDatabase == null || _listagemConfiguracaoConstante == null || _listagemSharedPreferences == null){
      _body = Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
          ],
        ),
      );
    }else{
      _body = ListView(
          children: [
            LabelOpensans("DATABASE",cor: _colorLetra ,bold: true,),
            for( var item in _listagemConfiguracaoDatabase) _elemento(context, item),   
            SizedBox(height: 20,),

            LabelOpensans("SHARED",cor: _colorLetra ,bold: true,),
            for( var item in _listagemSharedPreferences) _elemento(context, item),   
            SizedBox(height: 20,),

            LabelOpensans("CONSTANTES",cor: _colorLetra ,bold: true,),
            for( var item in _listagemConfiguracaoConstante) _elemento(context, item),
          ],
      );
    }

    return Scaffold(
      backgroundColor: _colorBackground ,
      appBar: AppBar(
        title: Text("Testes"),
        backgroundColor: _corAppBarFundo,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: _body
        ),
      )
    );
  }

  _elemento(BuildContext context , objeto){
    return Card(
      color: _colorFundo,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelQuicksand( objeto['chave'] , bold: true , tamanho: 17,),
            LabelOpensans( objeto['valor'] ,),
          ],
        ),
      ),

    );
  }
}