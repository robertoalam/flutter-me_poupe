import 'package:flutter/material.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/cad/cad_banco_model.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/conta/conta_model.dart';
import 'package:me_poupe/pages/bancos/banco_edit_tela.dart';
import 'package:me_poupe/pages/bancos/banco_list_tela.dart';
import 'package:me_poupe/pages/conta/conta_edit_tela.dart';

class BancoDestaqueTela extends StatefulWidget {
    @override
    _BancoDestaqueTelaState createState() => _BancoDestaqueTelaState();
}

class _BancoDestaqueTelaState extends State<BancoDestaqueTela> {

	BancoCadModel _banco = new BancoCadModel();
	List<BancoCadModel> _bancoLista = new List<BancoCadModel>();
  ContaModel _conta = new ContaModel();
	var _dados;

	// CORES TELA
	String _background = Funcoes.converterCorStringColor("#FFFFFF");
	String _colorContainerFundo = Funcoes.converterCorStringColor("#FFFFFF");
	String _colorContainerBorda = Funcoes.converterCorStringColor("#FFFFFF");
	String _colorFundo = Funcoes.converterCorStringColor("#FFFFFF");
	String _colorLetra = Funcoes.converterCorStringColor("#FFFFFF");

  	@override
		void initState() {
      super.initState();
      _start();
  	}

	_start() async {
		await _getDataConfig();
		await _setDataConfig();
		await _getBanks();
	}

	_getBanks() async {
		_bancoLista = await _banco.fetchByDestaque(1);
		setState(() { _bancoLista; });
	}

	_setDataConfig(){
		_background = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['background']);
    _colorContainerFundo = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['containerFundo']);
    _colorContainerBorda = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['containerBorda']);
    _colorLetra = Funcoes.converterCorStringColor( ConfiguracaoModel.cores[_dados['modo']]['textoPrimaria']);
	}

	_getDataConfig() async {
		_dados = await ConfiguracaoModel.getConfiguracoes().then( (list) {
			return list;
		});
		return;
	}


	@override
	Widget build(BuildContext context) {
		return Scaffold(
      backgroundColor: Color(int.parse(_background)),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: SizedBox( height: 10, ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text("Escolha a instituição financeira de sua utilização para a criação de conta",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18 ,
                    color: Color(int.parse(_colorLetra)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  itemCount: _bancoLista.length,
                  itemBuilder: (BuildContext context , int index){
                    return thumbGrid( _bancoLista[index] );
                  },
              ),
            ),
          ],
        ),
      ),
		);
	}

    thumbGrid(BancoCadModel objeto){
      String color;
      if (objeto.corPrimaria != null && objeto.corPrimaria == "#FFFFFF"){
        color = Funcoes.converterCorStringColor( objeto.corSecundaria ) ;
      }else if( objeto.corSecundaria != null && objeto.corSecundaria == "#FFFFFF" ){
        color = Funcoes.converterCorStringColor( objeto.corTerciaria );
      }else if( objeto.corTerciaria != null && objeto.corTerciaria == "#FFFFFF" ){
        color = Funcoes.converterCorStringColor( "#EEEEEE" );
      }else{
        color = Funcoes.converterCorStringColor( "#C1C1C1" );
      }
      color = Funcoes.converterCorStringColor( objeto.corCartao ) ;
      String imagem = "assets/images/bancos/logo/${objeto.id.toString()}.png";

      return GestureDetector(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircleAvatar(
            backgroundColor:  Color(int.parse(color)),
            radius: 30,
            child: SizedBox(
                height: 50, width: 50,
                child: Image.asset(objeto.imageAsset),
            ),
          ),
        ),
        onTap: (){ _navegar(objeto); },
      );
  	}

    _navegar(objeto){
      // SE FOR OUTROS
      if(objeto.id == 54){
        Navigator.push( context , MaterialPageRoute( builder: (context) => BancoListTela() ) );
      }else{
              _conta.banco = objeto;
        Navigator.push( context , MaterialPageRoute( builder: (context) => ContaEditTela(conta: _conta,) ) );
      }
  	}    
}
