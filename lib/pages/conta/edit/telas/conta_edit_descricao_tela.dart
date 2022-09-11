import 'package:flutter/material.dart';

import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';


class ContaEditDescricaoTela extends StatefulWidget {

  void Function(String texto) onSubmit;
  String textoNovo;

  ContaEditDescricaoTela(this.onSubmit , this.textoNovo);

  @override
  _ContaEditDescricaoTelaState createState() => _ContaEditDescricaoTelaState();
}

class _ContaEditDescricaoTelaState extends State<ContaEditDescricaoTela> {

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
  String _appBarDescricao = "";

  //DESCRICAO
  TextEditingController _descricaoController = new TextEditingController();
  String _descricao = "";

  // botao salvar
  bool _botaoSalvarFlag = false;

  @override
  void initState() {
    _start();
  }

  _start() async {

    await _getDataConfig();
    await _setDataConfig();
    await _getData();
  }

  _getData() async {
    _appBarDescricao = "Insira uma descrição";
    if( widget.textoNovo != null){
      _appBarDescricao = "Editar descrição";
      _descricaoController.text = widget.textoNovo.toString();
      _botaoSalvarFlag = true;
    }
    _atualizar();
  }

  _atualizar(){
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
      title: Text("${_appBarDescricao}"),
      backgroundColor: Color(int.parse(_corAppBarFundo) ),
    );
    final alturaDisponivel = MediaQuery.of(context).size.height - appBar.preferredSize.height;
    final larguraDisponivel = MediaQuery.of(context).size.width;

    _body = ListView(
      children: [
        Row(
          children: [
            Icon(Icons.edit , size: 27, color: Color(int.parse( _colorLetra)),),
            SizedBox(width: 5,),
            Text(
              'Descrição para conta',
              style: TextStyle(
                color: Color(int.parse( _colorLetra)),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Container(
          height: alturaDisponivel-250,
          child: TextFormField(
            controller: _descricaoController,
            minLines: 6,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 2,color: Color(int.parse( _colorContainerBorda)) ),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 2,color: Color(int.parse( _colorContainerBorda)))
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 2,color: Color(int.parse( _colorContainerBorda))),
              ),
            ),
          ),
        )
      ],
    );

    _save(){
      widget.onSubmit( _descricaoController.text.toString() );
      Navigator.pop( context );
    }

    return Scaffold(
      appBar: appBar,
      backgroundColor: Color( int.parse( _background ) ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _save();
        },
        backgroundColor: Color(int.parse( _corAppBarFundo ) ),
        child: Icon(Icons.save, color: Color(int.parse( _colorLetra ) ),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            width: larguraDisponivel,
            height: alturaDisponivel,
            child: _body,
          ),
        ),
      ),
    );


  }


}

