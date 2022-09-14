import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/componentes/label/label_quicksand.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/logs/log_model.dart';

class LogTela extends StatefulWidget {
  const LogTela();

  @override
  State<LogTela> createState() => _LogTelaState();
}

class _LogTelaState extends State<LogTela> {

  Widget _body;
  LogModel _log = new LogModel("","");
  List<LogModel> _lista = new List<LogModel>();
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
    _lista = await _log.buscarArquivoLog;
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
          return _ElementoCard( context , _lista[index] , Colors.black , Icon(Icons.ac_unit) );
        },
      );
    }

    return Scaffold(
      backgroundColor: Color(int.parse(_background) ),
      appBar: AppBar(
        backgroundColor: Color(int.parse(_corAppBarFundo) ),
        title: LabelOpensans( "LOGs", bold: true, cor: Colors.white, ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: _body,
        ),
      ),
    );
  }

  _ElementoCard(BuildContext context , LogModel objeto, Color cor , Icon icone){
    return Card(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ( objeto.tipo.toString().toLowerCase() == "erro") ? Colors.red : Colors.green,
            ),
            child: Row(
              children: [
                Icon( MdiIcons.cloudUpload ),
                SizedBox(width: 10,),
                LabelQuicksand( objeto.tipo , bold: true,),
                SizedBox(width: 10,),
                Align(
                  alignment: Alignment.bottomRight,
                  child: LabelQuicksand("", bold: true,),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.all(7),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          LabelOpensans("DATA: ",),
                          LabelQuicksand( Funcoes.converterDataEUAParaBR( objeto.data.toString().split(".")[0] ) , bold: true,),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,                      
                      child: Row(
                        children: [
                          LabelOpensans("HORA: ",),
                          LabelQuicksand( Funcoes.somenteHora( objeto.data.toString() ) , bold: true,),
                        ],
                      ),
                    ),
                  ],
                ),

                Align(
                  alignment: Alignment.bottomLeft,
                  child: LabelOpensans("MENSAGEM: ",), 
                ),
                Container( child: LabelQuicksand( objeto.mensagem.toString() , maximoLinhas: 5,) ),
              ],
            ),
          ),
        ],
      ),
    );    
  }
}