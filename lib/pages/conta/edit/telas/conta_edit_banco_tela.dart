import 'package:flutter/material.dart';
import 'package:me_poupe/helper/configuracoes_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/cad/cad_banco_model.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';

class ContaBancoEditTela extends StatefulWidget {

  void Function(BancoCadModel bancoCad) onSubmit;
  BancoCadModel banco;

  ContaBancoEditTela(this.onSubmit , this.banco);

  @override
  _ContaBancoEditTelaState createState() => _ContaBancoEditTelaState();
}

class _ContaBancoEditTelaState extends State<ContaBancoEditTela> {

  Widget _body;

  // CORES TELA
  String _background = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorAppBar = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorContainerFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorContainerBorda = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorFundo = Funcoes.converterCorStringColor("#FFFFFF");
  String _colorLetra = Funcoes.converterCorStringColor("#FFFFFF");

  BancoCadModel _banco = new BancoCadModel();
  List<BancoCadModel> _lista = new List<BancoCadModel>();
  List<BancoCadModel> _listaFiltrada = new List<BancoCadModel>();

  final TextEditingController _pesquisaController = new TextEditingController();
  var _dados = null;


  @override
  void initState() {
    super.initState();
    _lista = null;
    _start();
  }

  _start() async {
    await _getDataConfig();
    await _setDataConfig();
    await _getData();
  }

  _getDataConfig() async {
    _dados = await ConfiguracaoModel.getConfiguracoes().then((list) {
      return list;
    });
    return;
  }

  _setDataConfig() async {
    setState(() {
      _background = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['background']);
      _colorAppBar = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['corAppBar']);
      _colorContainerFundo = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['containerFundo']);
      _colorContainerBorda = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['containerBorda']);
      _colorLetra = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['textoPrimaria']);
    });
  }

  _getData() async {
    String pesquisa = "";
    // if(widget.where != null){
    //   pesquisa = widget.where;
    // }
    //
    // if(widget.order != null){
    //
    // }
    _lista = await _banco.fetchByWhere(pesquisar: pesquisa);
    _listaFiltrada = _lista;
    setState(() { _listaFiltrada; });
  }

  @override
  Widget build(BuildContext context) {

    if( _lista == null){
      _body = Center(
        child: CircularProgressIndicator(),
      );
    } else {
      _body = SingleChildScrollView(
        child: Column(
          children: [
            // PESQUISAR
            Container(
              padding: EdgeInsets.all(10),
              height: 110,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search , color: Color(int.parse(_colorLetra)),),
                      SizedBox( width: 25, ),
                      Container(
                        width: MediaQuery.of(context).size.width * .8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(int.parse(_colorContainerFundo)),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all( width: 1.0 , color: Color(int.parse( _colorLetra ) ) ),
                          ),

                          child: TextField(
                            style: TextStyle(
                              color: Color(int.parse( _colorLetra) ),
                            ),
                            cursorColor: Colors.purple,
                            controller: _pesquisaController,
                            onChanged: (value) => setState(() => _filtrar()),
                            decoration: InputDecoration(
                              fillColor: Colors.red,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              hintText: "Pesquisar" ,
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Divider( color: Color(int.parse(_colorLetra)),),
                ],
              ),
            ),
            // LISTA
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 110,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _listaFiltrada.length,
                itemBuilder: (context, index) {
                  return _thumbItem(context , _listaFiltrada[index]);
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse(_colorAppBar)),
        title: Text("Pesquisar instituição"),
      ),
      backgroundColor: Color( int.parse( _colorContainerFundo ) ),
      body: SafeArea(
        child: _body,
      ),
    );
  }

  Widget _thumbItem(BuildContext context ,BancoCadModel objeto){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          widget.onSubmit( objeto );
          Navigator.pop(context , objeto);
        },
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .15,
                  child: CircleAvatar(
                      backgroundColor: Color(int.parse( (objeto.corSecundaria != null) ? Funcoes.converterCorStringColor(objeto.corSecundaria): Funcoes.converterCorStringColor("#FFFFFF"))),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Image.asset(objeto.imageAsset),)
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                  width: MediaQuery.of(context).size.width * .60,
                  child: Text( objeto.descricao , style: TextStyle(
                      fontSize: 22,
                      color: Color(int.parse( _colorLetra ) )
                  ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .15,
                  child: Align(
                    alignment:Alignment.centerRight,
                    child: Icon(Icons.arrow_forward_ios , color: Color(int.parse( _colorLetra ) ) ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: (_listaFiltrada.last.id != objeto.id)? true : false ,
              child: Divider( color: Color( int.parse( _colorLetra) ), ),
            )

          ],
        ),
      ),
    );
  }

  _filtrar(){
    if( _pesquisaController.text.toString().length > 0 ){
      _listaFiltrada = _lista.where( (item) => item.descricao.toLowerCase().contains( _pesquisaController.text.toString() ) ).toList();
    }else{
      _listaFiltrada = _lista;
    }

  }
}
