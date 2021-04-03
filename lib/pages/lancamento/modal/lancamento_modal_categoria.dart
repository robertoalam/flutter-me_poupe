import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/componentes/icone_gambiarra.dart';
import 'package:me_poupe/helper/configuracoes_helper.dart';
import 'package:me_poupe/model/cad/cad_categoria_model.dart';
import 'package:me_poupe/model/configuracoes/icone_cad_model.dart';

class LancamentoModalCategoria extends StatefulWidget {

  final List listaCategoria;
  LancamentoModalCategoria(this.listaCategoria);

  @override
  _LancamentoModalCategoriaState createState() => _LancamentoModalCategoriaState();
}

class _LancamentoModalCategoriaState extends State<LancamentoModalCategoria> {

  final TextEditingController _pesquisaController = new TextEditingController();
  List<CategoriaCadModel> _lista = new List<CategoriaCadModel>();
  List<CategoriaCadModel> _listaFiltrada = new List<CategoriaCadModel>();
  var _listaIcones = Configuracoes.icones;

  @override
  Widget build(BuildContext context) {

    _lista = widget.listaCategoria;

    var body;
    if(_lista != null){
      body = Center(
        child: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * .8,
          height: MediaQuery.of(context).size.height * .6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(MdiIcons.bottleTonicPlus),
                      SizedBox(width: 25,),
                      Container(
                        width: MediaQuery.of(context).size.width * .6,
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
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _lista.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.pop(context , _lista[index]);
                        },
                        child: thumb(_lista[index]),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }else{
      body = Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black12,
      body: body,
    );
  }

  thumb(objeto){
    var listagem;
    IconeCadModel icone;
    listagem = _listaIcones.where( (item) => item['icone'] == objeto.icone).toList();

    // SENAO ENCONTAR SETA O HOME COMO DEFAULT
    if(listagem.length > 0) {
      icone = new IconeCadModel(
          icone: listagem[0]['icone'],
          codigo: int.parse(listagem[0]['codigo'].toString()),
          familia: listagem[0]['familia'],
          pacote: listagem[0]['pacote']
      );
    }else{
      icone = new IconeCadModel(
          icone: 'home-01',
          codigo: 0xe7ba,
          familia: "MaterialIcons",
          pacote: ""
      );
    }

    return Container(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: IconeGambiarra( icone , tamanho: 22,),
        ),
        title: Text(objeto.descricao),
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
