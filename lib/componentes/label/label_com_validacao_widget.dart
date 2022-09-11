import 'package:flutter/material.dart';

import 'label_opensans.dart';


class LabelComValidacao extends StatefulWidget {
  final BuildContext context;
  final String label;
  final String descricao;
  LabelComValidacao(this.context , this.label , this.descricao);

  @override
  _LabelComValidacaoState createState() => _LabelComValidacaoState();
}

class _LabelComValidacaoState extends State<LabelComValidacao> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: LabelOpensans(widget.label , tamanho: 16.0,bold: true,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 9,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  height: 40,
                  width: MediaQuery.of(context).size.width ,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Text(
                    "${widget.descricao.toString().toUpperCase()}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.arrow_forward_ios)
              ),              
            ],
          ),      
        ],
      )
    );
  }
}