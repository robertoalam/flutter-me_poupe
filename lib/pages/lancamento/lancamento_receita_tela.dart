import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/componentes/label/label_simples_widget.dart';


class LancamentoReceitaTela extends StatefulWidget {
  @override
  _LancamentoReceitaTelaState createState() => _LancamentoReceitaTelaState();
}

class _LancamentoReceitaTelaState extends State<LancamentoReceitaTela> {

  TextEditingController _descricaoController = new TextEditingController();

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LabelOpensans("+",cor: Colors.white,tamanho: 32,bold: true,),
                  Row(
                    children: [
                      LabelOpensans("65,79",cor: Colors.white,tamanho: 32,bold: true,),
                      Icon(Icons.attach_money , color: Colors.white,size: 32,),
                    ],
                  )
                ],
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Column(
              children: [

                // DESCRICAO
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelSimples("Descrição" , tamanho: 19.0,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 15, 0, 0),
                            child: Icon(Icons.edit),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                            height: 50,
                            width: MediaQuery.of(context).size.width * .8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey)
                            ),
                            child: TextFormField(
                              controller: _descricaoController,
                              decoration: InputDecoration(
                                hintText: "opcional",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}