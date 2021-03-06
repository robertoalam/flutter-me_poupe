import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/icone_gambiarra.dart';
import 'package:me_poupe/componentes/label_opensans.dart';
import 'package:me_poupe/componentes/label_quicksand.dart';
import 'package:me_poupe/helper/configuracoes_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/configuracoes/icone_cad_model.dart';

class IconeListTela extends StatefulWidget {
  @override
  _IconeListTelaState createState() => _IconeListTelaState();
}

class _IconeListTelaState extends State<IconeListTela> {
  var _dados = null;
  var listaBugada = Configuracoes.icones;
  List<IconeCadModel> _listaOriginal = List<IconeCadModel>();
  List<IconeCadModel> _listaFiltrada = List<IconeCadModel>();

  // CORES TELA
  String _background = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorAppBar = Funcoes.converterCorStringColor("#FFFFFF");
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
    await buscarLista();
    _listaFiltrada = _listaOriginal;
    await _atualizarListaFiltrada();
    montarTela();
  }

  buscarLista() {
    listaBugada.forEach((m) {
      IconeCadModel icone = new IconeCadModel(
          icone: m['icone'],
          codigo: m['codigo'],
          familia: m['familia'],
          pacote: m['pacote']);
      _listaOriginal.add(icone);
    });
    setState(() {
      _listaOriginal;
    });
  }

  _atualizarListaFiltrada() async {
    setState(() {
      _listaFiltrada;
    });
  }

  _filtrar(String palavra) async {
    _listaFiltrada = _listaOriginal
        .where((item) =>
            item.icone.toLowerCase().contains(palavra.toString().toLowerCase()))
        .toList();
    await _atualizarListaFiltrada();
  }

  montarTela() {
    setState(() {
      _colorAppBar = Funcoes.converterCorStringColor( Configuracoes.cores[_dados['modo']]['corAppBar']);
    //   print("APPBAR: ${Configuracoes.cores[_dados['modo']]['corAppBar']}");
      _background = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['background']);
      _colorContainerFundo = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['containerFundo']);
      _colorContainerBorda = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['containerBorda']);
      _colorFundo = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['background']);
      _colorLetra = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['textoPrimaria']);
    });
    return;
  }

  loadDados() async {
    _dados = await ConfiguracaoModel.getConfiguracoes().then((list) {
      return list;
    });
    setState(() { _dados; });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse(_background)),
      appBar: AppBar(
        backgroundColor: Color(int.parse(_colorAppBar)),
        title: Text("Lista de Icones"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (valor) => _filtrar(valor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  icon: Icon(
                    Icons.help,
                    color: Colors.black38,
                    size: 50,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                itemCount: _listaFiltrada.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return _thumb(context, _listaFiltrada[index]);
                },
              ),
            ),
          ],
        ),
      )),
    );
  }

  _thumb(BuildContext context, IconeCadModel objeto) {
    return Card(
      color: Colors.grey,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Color(int.parse(_background)),
              ),
              child: IconeGambiarra(
                objeto,
                cor: Color(int.parse(_colorLetra)),
                tamanho: 50.0,
              ),
            ),
            LabelOpensans(
              "${objeto.icone}",
              cor: Color(int.parse(_colorLetra)),
            ),
            LabelQuicksand("${objeto.familia}",
                cor: Color(int.parse(_colorLetra))),
          ],
        ),
      ),
    );
  }
}
