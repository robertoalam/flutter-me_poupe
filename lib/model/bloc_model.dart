import 'dart:async';
import 'package:flutter/material.dart';

class MeuBlocModel {

  Color color;
  int pagina = 0;

  final StreamController _streamController = StreamController();
  Sink get input => _streamController.sink;
  Stream get output => _streamController.stream;


  setPagina( page ){
    pagina = page;
    input.add(pagina);
  }
}