import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/componentes/label/label_quicksand.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/pages/testes/teste_rest_tela.dart';
import '../configuracoes/icones_list_tela.dart';

class TesteTela extends StatefulWidget {
  const TesteTela();

  @override
  State<TesteTela> createState() => _TesteTelaState();
}

class _TesteTelaState extends State<TesteTela> {
	// CORES TELA
	var listaCores ;
	Color _corAppBarFundo = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorBackground = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorContainerFundo = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorContainerBorda = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorFundo = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorLetra = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
  
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
    return Scaffold(
      backgroundColor: _colorBackground ,
      appBar: AppBar(
        title: Text("Testes"),
        backgroundColor: _corAppBarFundo,
      ),
      body: SafeArea(

        child: ListView(
          children: [
            _Elemento( context , Icons.format_paint , "Icones" , "Lista de Icones" , IconeListTela()),
            Divider( color: _colorLetra, ),
            _Elemento( context , Icons.cloud , "REST" , "lista de servicos " , TesteRestTela()),
            Divider( color: _colorLetra, ),            
            // FlatButton(
            //   onPressed: () async {
            //     String teste = await Funcoes.buscarVersao;
            //     print("TESTE : ${teste.toString()}");
            //   },
            //   child: Text("VERSAO"),
            // ),
          ],
        ),
      ),
    );
  }

  _Elemento( context,  icone , titulo , subtitulo , rota){
    return Container(
      child: ListTile(
        onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => rota )); },
        leading: CircleAvatar(
          backgroundColor: _colorLetra,
          child: Icon( icone ,  color: _colorBackground),
        ),
        title: LabelOpensans( titulo , bold: true, cor: _colorLetra ),
        subtitle: LabelQuicksand( subtitulo , cor: _colorLetra ),
      ),
    );
  }
}