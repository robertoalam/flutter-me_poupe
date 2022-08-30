import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/label_opensans.dart';
import 'package:me_poupe/componentes/label_quicksand.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';

class SobreTela extends StatefulWidget {
  const SobreTela();

  @override
  State<SobreTela> createState() => _SobreTelaState();
}

class _SobreTelaState extends State<SobreTela> {

  ConfiguracaoModel _config = new ConfiguracaoModel();
  Map<String,dynamic> _listagem = new Map<String,dynamic>();

  String _versao = "";
  int _contador = 0;

  @override
  void initState() {
    _listagem.clear();
    _start();
    super.initState();
  }

  _start() async {
    _listagem = await ConfiguracaoModel.getConfiguracoes();
    _listagem['versao'] = await Funcoes.buscarVersao;
    setState(() { });
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
          Visibility(
            visible:  ( _listagem['modo_debug'].toString().toLowerCase() == "true")?true:false,
            child: _Elemento( "modo debug:", _listagem['modo_debug'].toString() ),
          ),
          _Elemento( "environment:" , _listagem['ambiente'].toString() ),
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
      appBar: AppBar( title: Text("Sobre"), 
        actions: [
          InkWell(
            onTap: (){
              ++_contador;
              print("CONTADOR: ${_contador.toString()}");
              if( _contador == 7){
                print("ENTROU");
                _contador = 0;
              }
            },
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

  Widget _Elemento( label , valor ){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),              
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelOpensans(label ,tamanho: 17,bold: true,),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: LabelQuicksand(valor ,tamanho: 15),
          ),
        ],
      ),
    );
  }
}