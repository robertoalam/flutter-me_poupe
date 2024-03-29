import 'package:flutter/material.dart';

class LabelQuicksand extends StatelessWidget {
  final String texto;
  final Color cor;
  final double tamanho;
  final bool bold;
  final int maximoLinhas;

  LabelQuicksand(this.texto,{this.cor,this.tamanho,this.bold = false,this.maximoLinhas =1});

  @override
  Widget build(BuildContext context) {

    Color cor = (this.cor != null) ?  this.cor : Colors.black;
    double size = (this.tamanho != null) ?  this.tamanho : 14;
    var negrito = (this.bold) ? FontWeight.bold : FontWeight.normal ;

    return Text(
      texto , style: TextStyle(
          fontFamily: "Quicksand",
          fontSize: size,
          fontWeight: negrito,
          color: cor ,
        ),
      overflow: TextOverflow.ellipsis,
      maxLines: this.maximoLinhas,
      softWrap: false,
    );
  }
}

