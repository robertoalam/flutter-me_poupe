import 'dart:async';

class BlocModel {

  double total = 0;
  bool flag = false;
  String modulo = "";

  final StreamController _streamController = StreamController();
  Sink get input => _streamController.sink;
  Stream get output => _streamController.stream;


  adicionar(valor){
    total = total + valor;
    input.add(total);
  }

  moduloAlterar(valor){
    modulo = valor;
    input.add(modulo);
  }


  flagInverter(){
    flag = !flag;
    input.add(flag);
  }

}