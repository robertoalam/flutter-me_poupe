import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/componentes/label/label_quicksand.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';

class SobreTela extends StatefulWidget {
  const SobreTela();

  @override
  State<SobreTela> createState() => _SobreTelaState();
}

class _SobreTelaState extends State<SobreTela> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ConfiguracaoModel _config = new ConfiguracaoModel();
  Map<String,dynamic> _listagem = new Map<String,dynamic>();
  int _contador = 0;
  // CORES TELA
  var listaCores ;
  String _corAppBarFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _background = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorContainerFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorContainerBorda = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorLetra = Funcoes.converterCorStringColor("#FFFFFF");
  
  @override
  void initState() {
    _listagem.clear();
    _start();
    super.initState();
  }

  _start() async {
    await montarTela();
    _listagem = await ConfiguracaoModel.getConfiguracoes();
    _listagem['versao'] = await Funcoes.buscarVersao;
    setState(() { });
  }

  montarTela() async {
    listaCores = await ConfiguracaoModel.buscarEstilos;
    setState(() {
      _corAppBarFundo = Funcoes.converterCorStringColor( listaCores['corAppBarFundo'] );
      _background = Funcoes.converterCorStringColor( listaCores['background'] );
      _colorContainerFundo = Funcoes.converterCorStringColor( listaCores['containerFundo'] );
      _colorContainerBorda = Funcoes.converterCorStringColor( listaCores['containerBorda'] );
      _colorLetra = Funcoes.converterCorStringColor( listaCores['textoPrimaria'] );      
    });
    return;
  }

  @override
  Widget build(BuildContext context) {

    Widget _body ;
    if( _listagem.length > 0){
      _body = ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Image.asset("assets/images/porco_01.png" , height: 150,),
          ),
          SizedBox(height: 10,),            
          _Elemento( "app version:" , _listagem['versao'].toString() ),
          _Elemento( "installation date:" , Funcoes.converterDataEUAParaBR( _listagem['dt_instalacao'].toString() ,retornarHorario: true ) ),
          _Elemento( "openings:" , _listagem['no_aberturas'].toString() ),
          _Elemento( "device:" , _listagem['device_id'].toString() ),
          _Elemento( "debug:" , _listagem['debug'].toString() ),
          Visibility(
            visible:  ( _listagem['debug'].toString().toLowerCase() == "true")?true:false,
            child: _Elemento( "environment:" , _listagem['ambiente'].toString() ),
          ),
          _Elemento( "database version:" , _listagem['database_versao'].toString() ),
          _Elemento( "database schema version:" , _listagem['database_schema_versao'].toString() ),
        ],
      );
    }else{
      _body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 2,),
          ],
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(int.parse(_background)),
      appBar: AppBar( title: Text("Sobre"), 
        backgroundColor: Color(int.parse( _corAppBarFundo) ),
        actions: [
          InkWell(
            onTap: ()=>_alterarModo,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Icon( Icons.access_alarm , )
            ),
          ),
        ],      
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: _body
      )
    );
  }
  get _alterarModo async {
    ++_contador;
    if( _contador == 7){
      print("ENTROU");
      bool flag = ( ( await _config.fetchByChave('debug') ).valor.toString().toLowerCase() == "true")? true : false;
      flag = !flag;
      await ConfiguracaoModel.setarDebug( flag );
      String mensagem = (flag)? "ATIVADO":"DESATIVADO";
      setState(() {
        _listagem.clear();
        _start();
      });

      _showToast(context , "MODO DEBUG ${mensagem.toString()}");
      _contador = 0;
    }
  }

  void _showToast(BuildContext context, String messagem) {
    final snackBar = SnackBar(content: Text(messagem));
    if(snackBar != null){
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Widget _Elemento( label , valor ){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),              
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelOpensans(label ,tamanho: 17,bold: true,cor: Color(int.parse( Funcoes.converterCorStringColor( _colorLetra ) ) ),),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: LabelQuicksand(valor ,tamanho: 15 , cor: Colors.grey,bold: true,),
          ),
        ],
      ),
    );
  }
}