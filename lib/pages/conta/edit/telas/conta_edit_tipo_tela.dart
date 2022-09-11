import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/conta/conta_tipo_model.dart';
class ContaEditTipoTela extends StatefulWidget {

  void Function(ContaTipoModel tipo) onSubmit;
  ContaTipoModel tipo;

  ContaEditTipoTela(this.onSubmit , this.tipo);
  @override
  _ContaEditTipoTelaState createState() => _ContaEditTipoTelaState();
}

class _ContaEditTipoTelaState extends State<ContaEditTipoTela> {

  // CORES TELA
  String _background = Funcoes.converterCorStringColor("#FFFFFF");
  String _corAppBarFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorContainerFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorContainerBorda = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorLetra = Funcoes.converterCorStringColor("#FFFFFF");

  // VARIAVEIS
  Widget _body;
  var _dados = null;


  ContaTipoModel _contaTipo = new ContaTipoModel();
  List<ContaTipoModel> _lista = new List<ContaTipoModel>();

  @override
  void initState() {
    _start();
  }

  _start() async {
    _lista = null;
    await _getDataConfig();
    await _setDataConfig();
    await _getData();
  }

  _getData() async {
    _lista = await _contaTipo.fetchByAll();
    setState(() { _lista; });
  }

  _setDataConfig() async {
    setState(() {
      _background = Funcoes.converterCorStringColor(ConfiguracaoModel.cores[_dados['modo']]['background']);
      _corAppBarFundo = Funcoes.converterCorStringColor(ConfiguracaoModel.cores[_dados['modo']]['corAppBar']);
      _colorContainerFundo = Funcoes.converterCorStringColor(ConfiguracaoModel.cores[_dados['modo']]['containerFundo']);
      _colorContainerBorda = Funcoes.converterCorStringColor(ConfiguracaoModel.cores[_dados['modo']]['containerBorda']);
      _colorLetra = Funcoes.converterCorStringColor(ConfiguracaoModel.cores[_dados['modo']]['textoPrimaria']);
    });
  }

  _getDataConfig() async {
    _dados = await ConfiguracaoModel.getConfiguracoes().then((list) {
      return list;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {

    final appBar = AppBar(
      title: Text("Banco"),
      backgroundColor: Color(int.parse(_corAppBarFundo) ),
    );
    final alturaDisponivel = MediaQuery.of(context).size.height - appBar.preferredSize.height;
    final larguraDisponivel = MediaQuery.of(context).size.width;


    if(_lista == null){
      _body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      );
    }else{
      _body = Padding(
        padding: EdgeInsets.all(10),
        child:
        ListView(
          children: [
            for(ContaTipoModel item in _lista) _thumb(context , item),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: larguraDisponivel,
            height: alturaDisponivel,
            child: _body,
          ),
        ),
      ),
    );
  }

  Widget _thumb(BuildContext context , ContaTipoModel objeto){
    return InkWell(
      onTap: (){
        widget.onSubmit( objeto );
        Navigator.pop(context , objeto);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Row(
              children: [
                Icon(Icons.arrow_back_ios,color: Colors.grey,),
                SizedBox( width: 10,),
                Text(objeto.descricao.toUpperCase() ,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Divider( color: Colors.grey, )
          ],
        ),
      ),
    );
  }
}
