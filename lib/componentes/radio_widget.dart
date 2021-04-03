import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/label_opensans.dart';
class RadioWidget extends StatefulWidget {
  String texto;
  int index;

  RadioWidget(this.texto, this.index);

  @override
  _RadioWidgetState createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {

  bool selecionado = false;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => changeIndex(widget.index),
      color: (selecionado) ? Colors.purple : Colors.grey ,
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0) ),
      child: LabelOpensans(
        widget.texto ,
        cor:(selecionado) ?Colors.white : Colors.white ,
        bold: (selecionado),
      ),
    );

  }
  void changeIndex(int index){
    setState(() {
      selecionado = !selecionado;
    });
  }
}
