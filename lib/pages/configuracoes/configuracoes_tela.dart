import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/label_opensans.dart';
import 'package:me_poupe/componentes/label_quicksand.dart';
import 'package:me_poupe/helper/configuracoes_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/pages/configuracoes/icones_list_tela.dart';
import 'package:me_poupe/pages/configuracoes/sobre_tela.dart';
import 'package:me_poupe/pages/testes/teste_tela.dart';

class ConfiguracoesTela extends StatefulWidget {
  ConfiguracoesTela();

  @override
  State<ConfiguracoesTela> createState() => _ConfiguracoesTelaState();
}

class _ConfiguracoesTelaState extends State<ConfiguracoesTela> {
var body;
  bool _modoNoturno = false;
  var _dados = null;
  // CORES TELA
  String _colorAppBar = Funcoes.converterCorStringColor("#FFFFFF");
  String _background = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorContainerFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorContainerBorda = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorLetra = Funcoes.converterCorStringColor("#FFFFFF");

  @override
  void initState() {
    buscarDados();
    super.initState();
  }

  buscarDados() async {
    await loadDados();
    montarTela();
  }

  montarTela() {
    setState(() {
      _colorAppBar = Funcoes.converterCorStringColor( Configuracoes.cores[_dados['modo']]['corAppBar']);
      _background = Funcoes.converterCorStringColor( Configuracoes.cores[_dados['modo']]['background']);
      _colorContainerFundo = Funcoes.converterCorStringColor( Configuracoes.cores[_dados['modo']]['containerFundo']);
      _colorContainerBorda = Funcoes.converterCorStringColor( Configuracoes.cores[_dados['modo']]['containerBorda']);
      _colorLetra = Funcoes.converterCorStringColor( Configuracoes.cores[_dados['modo']]['textoPrimaria']);
    });
    return;
  }

  loadDados() async {
    _dados = await ConfiguracaoModel.getConfiguracoes().then((list) {
      return list;
    });
    setState(() {
      _modoNoturno = (_dados['modo'] == 'normal') ? false : true;
      _dados;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    if (_dados != null) {
      body = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: ListTile(
                onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => SobreTela())); } ,
                leading: CircleAvatar(
                  backgroundColor: Color(int.parse(_colorLetra)),
                  child: Icon( Icons.settings_cell, color: Color(int.parse(_background)), ),
                ),
                title: LabelOpensans("Sobre", bold: true, cor: Color(int.parse(_colorLetra)), ),
              ),
            ),
            Divider( color: Color(int.parse(_colorLetra)), ),        


            Container(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(int.parse(_colorLetra)),
                  child: Icon(
                    Icons.remove_red_eye,
                    color: Color(int.parse(_background)),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LabelOpensans(
                      "Modo Noturno",
                      bold: true,
                      cor: Color(int.parse(_colorLetra)),
                    ),
                    Container(
                      child: Switch(
                        value: _modoNoturno,
                        onChanged: (value) async {
                          _setarModo(value);
                          await buscarDados();
                          setState(() {
                            _modoNoturno = value;
                          });
                        }
                      ),
                    )
                  ],
                ),
                subtitle: LabelQuicksand( "Altera as cores da aplicação", cor: Color(int.parse(_colorLetra)), ),
              ),
            ),
            Divider( color: Color(int.parse(_colorLetra)), ),



            Container(
              child: ListTile(
                onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => TesteTela())); },
                leading: CircleAvatar(
                  backgroundColor: Color(int.parse(_colorLetra)),
                  child: Icon( CupertinoIcons.gear , color: Color(int.parse(_background)), ),
                ),
                title: LabelOpensans( "Testes", bold: true, cor: Color(int.parse(_colorLetra)), ),
                subtitle: LabelQuicksand( "Tela de testes", cor: Color(int.parse(_colorLetra)), ),
              ),
            ),
    
          ],
        ),
      );
    } else {
      body = Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Color(int.parse(_background)),
      appBar: AppBar(
        backgroundColor: Color(int.parse(_colorAppBar)),
        title: LabelOpensans( "Configurações", bold: true, cor: Colors.white, ),
      ),
      body: SafeArea(
        child: body,
      ),
    );
  }

  _setarModo(bool valor) async {
    String novoValor = (valor) ? "escuro" : "normal";
    await ConfiguracaoModel.alterarModo(novoValor);
    return;
  }
}
