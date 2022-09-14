import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/componentes/label/label_quicksand.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/logs/log_rest_model.dart';

class LogRestTela extends StatefulWidget {
  const LogRestTela();

  @override
  State<LogRestTela> createState() => _LogRestTelaState();
}

class _LogRestTelaState extends State<LogRestTela> {
  Widget _body;
  LogRestModel _log = new LogRestModel();
  List<LogRestModel> _lista = new List<LogRestModel>();
  ConfiguracaoModel _config = new ConfiguracaoModel();
  Map<String,dynamic> _listagem = new Map<String,dynamic>();
  bool _flagAtualizando = false;

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
    _buscarDados();
    super.initState();
  }

  _buscarDados() async {
    setState(() { _flagAtualizando = true; });    
    _lista = await _log.buscarLogRest;
    setState(() { _flagAtualizando = false; });
  }

  _start() async {
    await montarTela();
    _listagem = await ConfiguracaoModel.getConfiguracoes();
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

    if( _flagAtualizando){
      _body = Center(
        child: CircularProgressIndicator(),
      );
    }else{
      _body = ListView.builder(
        itemCount: _lista.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ( _lista[index].verbo.toString().toLowerCase() == "post") ? Colors.blue : Colors.green,
                  ),
                  child: Row(
                    children: [
                      Icon(  ( _lista[index].verbo.toString().toLowerCase() == "post") ? MdiIcons.cloudUpload : MdiIcons.cloudDownload ),
                      SizedBox(width: 10,),
                      LabelQuicksand(_lista[index].verbo , bold: true,),
                      SizedBox(width: 10,),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: LabelQuicksand(_lista[index].statusCode.toString(), bold: true,),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          LabelOpensans("DATA: ",),
                          LabelQuicksand( Funcoes.converterDataEUAParaBR( _lista[index].data.toString().split(".")[0] ) , bold: true,),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,                      
                      child: Row(
                        children: [
                          LabelOpensans("HORA: ",),
                          LabelQuicksand( Funcoes.somenteHora( _lista[index].data.toString() ) , bold: true,),
                        ],
                      ),
                    ),                    
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          LabelOpensans("AMBIENTE: ",),
                          LabelQuicksand( _lista[index].ambiente , bold: true,),
                        ],
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LabelOpensans("URL: ",),
                    Expanded(
                      flex: 1,
                      child: LabelQuicksand(  _lista[index].url.toString() , bold: true, maximoLinhas: 3,),
                    )
                  ],
                ),

                // Text( _lista[index].statusCode.toString() ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Color(int.parse(_background) ),
      appBar: AppBar(
        backgroundColor: Color(int.parse(_corAppBarFundo) ),
        title: LabelOpensans( "LOGs REST", bold: true, cor: Colors.white, ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: _body,
        ),
      ),
    );
  }
}