import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/icone_gambiarra.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/componentes/label/label_quicksand.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/configuracoes/icone_cad_model.dart';

class IconeListTela extends StatefulWidget {
  @override
  _IconeListTelaState createState() => _IconeListTelaState();
}

class _IconeListTelaState extends State<IconeListTela> {
  var _dados = null;
  var listaBugada = ConfiguracaoModel.icones;
  List<IconeCadModel> _listaOriginal = List<IconeCadModel>();
  List<IconeCadModel> _listaFiltrada = List<IconeCadModel>();

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
    await loadDados();
    await buscarLista();
    _listaFiltrada = _listaOriginal;
    await _atualizarListaFiltrada();

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
      backgroundColor: _colorBackground,
      appBar: AppBar(
        backgroundColor: _corAppBarFundo,
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
            Divider( color: Colors.grey, ),
            Container(
              padding: EdgeInsets.fromLTRB(7, 3, 7, 3),
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
                color: _colorBackground,
              ),
              child: IconeGambiarra(
                objeto,
                cor: _colorLetra,
                tamanho: 50.0,
              ),
            ),
            LabelOpensans( "${objeto.icone}", cor: _colorLetra, ),
            LabelQuicksand("${objeto.familia}", cor: _colorLetra,)
          ],
        ),
      ),
    );
  }
}
