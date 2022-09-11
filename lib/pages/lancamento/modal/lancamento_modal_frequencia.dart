import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/componentes/label/label_simples_widget.dart';
import 'package:me_poupe/model/cad/cad_frequencia_model.dart';
import 'package:me_poupe/model/cad/cad_frequencia_periodo_model.dart';

class LancamentoModalFrequencia extends StatefulWidget {
  FrequenciaCadModel frequencia;
  List<FrequenciaPeriodoCadModel> lista;
  LancamentoModalFrequencia(this.frequencia , this.lista);

  @override
  _LancamentoModalFrequenciaState createState() => _LancamentoModalFrequenciaState();
}

class _LancamentoModalFrequenciaState extends State<LancamentoModalFrequencia> {
  var body;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _itemSelecionado;
  List<FrequenciaPeriodoCadModel> listaFrequenciaPeriodo = new  List<FrequenciaPeriodoCadModel>();
  FrequenciaPeriodoCadModel periodo = new FrequenciaPeriodoCadModel();

  TextEditingController _quantidadeController = new TextEditingController();
  TextEditingController _frequenciaController = new TextEditingController();

  @override
  void initState() {
    listaFrequenciaPeriodo = null;
    listaFrequenciaPeriodo = widget.lista;
    montarTela();
  }

  montarTela(){
    setState(() {
      listaFrequenciaPeriodo;
      _dropDownMenuItems = getDropDownMenuItems( listaFrequenciaPeriodo );
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems( lista ) {
    List<DropdownMenuItem<String>> items = new List();
    for (var linha in lista) {
      items.add(
        new DropdownMenuItem(
          value: linha.id.toString(), child: new Text(linha.descricao)
        )
      );
    }
    return items;
  }


  @override
  Widget build(BuildContext context) {

    if( listaFrequenciaPeriodo != null){
      body = Center(
        child: Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelOpensans(widget.frequencia.descricao , tamanho: 23,bold: true,),
                Divider(height: 10,),
                Row(
                  children: [
                    LabelSimples("Quantidade"),
                    SizedBox( width: 10,),
                    Container(
                      width: 60,
                      height: 40,
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextField(
                        controller: _quantidadeController,
                        onSubmitted: (_) => {
                          // Navigator.of(context).pop(),
                          print('teste'),
                        },
                        textAlignVertical: TextAlignVertical.bottom,
                        keyboardType: TextInputType.numberWithOptions(decimal: false),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          counter: Offstage(),
                          hintText: '0',
                        ),
                        maxLength: 3,
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    LabelSimples("Frequencia"),
                    SizedBox( width: 15,),
                    Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(

                          side: BorderSide(width: 1.0, style: BorderStyle.solid  , color: Colors.grey),
                          borderRadius: BorderRadius.all(
                              Radius.circular(5.0)
                          ),
                        ),
                      ),
                      child: DropdownButton(
                        underline: SizedBox(),
                        items: _dropDownMenuItems,
                        value: _itemSelecionado,
                        onChanged: (value){
                          setState(() {
                            _itemSelecionado = value;
                          });
                        },
                        hint: Text("Selecione"),
                      ),
                    ),
                  ],
                ),
                Divider(height: 10,),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,

                  children: [
                    FlatButton(
                      onPressed: (){ Navigator.pop(context); },
                      child: Text("cancelar" , style: TextStyle(color: Theme.of(context).primaryColor,),),
                    ),
                    SizedBox(width: 10,),
                    RaisedButton(
                      onPressed: () async {
                        if(_validarForm()){
                          periodo = await periodo.fetchById(int.parse(_itemSelecionado ) );
                          Map<String,dynamic> retorno = Map();
                          retorno['quantidade'] = _quantidadeController.text;
                          retorno['periodo'] = periodo;
                          Navigator.of(context).pop(retorno);
                        }
                      },
                      child: Text("OK"),
                    ),
                  ],
                )
              ],
            )
        ),
      );
    }else{
      body = Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black12,
      body: body
    );
  }

  _validarForm(){
    if(_quantidadeController.text == "0") return false;
    if(_itemSelecionado == null) return false;
    return true;
  }
  // _builder(int index) {
  //   return Card(
  //     child: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         color: Colors.red,
  //       ),
  //       child: Center(
  //           child: Text("Card ${index}",
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 20,
  //             ),
  //           )
  //       ),
  //     ),
  //   );
  // }
}
