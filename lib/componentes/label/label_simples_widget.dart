import 'package:flutter/material.dart';

class LabelSimples extends StatelessWidget {

  final String texto;
  final double tamanho;

  LabelSimples(this.texto,{this.tamanho});

  @override
  Widget build(BuildContext context) {

    double size = (this.tamanho != null) ?  this.tamanho : 14;

    return Text(texto , style: TextStyle(
        fontFamily: "Quicksand",
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: Colors.grey
    ),);
  }
}
