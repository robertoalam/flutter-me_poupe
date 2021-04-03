import 'package:flutter/material.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/cad/cad_banco_model.dart';


class CartaoListTela extends StatefulWidget {
  @override
  _CartaoListTelaState createState() => _CartaoListTelaState();
}

class _CartaoListTelaState extends State<CartaoListTela> {
  BancoCadModel _banco = new BancoCadModel();
  List<BancoCadModel> _lista = new List<BancoCadModel>();
  List<BancoCadModel> _listaFiltrada = new List<BancoCadModel>();

  final TextEditingController _pesquisaController = new TextEditingController();
  @override
  void initState() {

    super.initState();
//    buscarDadosConfiguracao();
    buscarDados();
  }

  buscarDados() async {
    _lista = await _banco.fetchByDestaque2(0,notIn: 1);
    _listaFiltrada = _lista;
    setState(() {
      _listaFiltrada;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar instituição"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 25,),
                    Container(
                      width: MediaQuery.of(context).size.width * .7,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Pesquisar"
                        ),
                        controller: _pesquisaController,
                        onChanged: (value) => setState(() => _filtrar()),
                      ),
                    ),

                  ],
                )
              ),
              Expanded(
                flex: 6,
                child: ListView(
                  children:
                    _listaFiltrada.map((banco) =>
                      Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(int.parse( (banco.corSecundaria != null )? Funcoes.converterCorStringColor( banco.corSecundaria ) :  Funcoes.converterCorStringColor( "#FFFFFF" ) )),
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Image.asset(banco.imageAsset),
                                  )
                                ),
                                SizedBox(width: 10,),
                                Text(banco.descricao),
                              ],
                            ),
                          )
                        ),
                      ),
                    ).toList(),
                ),
              )
            ],
          ),
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
