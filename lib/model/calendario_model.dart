import 'package:flutter/foundation.dart';

class CalendarioModel{

  int mes;
  int ano;
  DateTime data;
  String mesExtenso;
  String mesAbreviado;

  // CalendarioModel({this.mes, this.ano, this.data,this.mesExtenso,this.mesAbreviado});
  CalendarioModel({this.data});

  @override
  String toString() {
    return '{ano: $ano, mesExtenso: $mesExtenso}';
  }


  montarObjeto(DateTime data){
    CalendarioModel calendario = new CalendarioModel();
    calendario.data = data;
    calendario.ano = data.year;
    calendario.mes = data.month;
    calendario.mesAbreviado = this.buscarMesAbreviado(data.month);
    calendario.mesExtenso = this.buscarMesAbreviado(data.month);
    return calendario;
  }

  gerarLista(DateTime dataAtual){

    List<CalendarioModel> lista = new List<CalendarioModel>();
    for(int c = -1 ; c <= 1 ; c++){
      data = new DateTime( dataAtual.year , dataAtual.month+c, 1 );
      CalendarioModel calendario = this.montarObjeto(data);
      lista.add(calendario);
    }
    return lista;
  }

  buscarMesExtenso(int mes){

    if(mes==1){
      return mesExtenso = "Janeiro";
    }else if(mes==2){
      return mesExtenso = "Fevereiro";
    }else if(mes==3){
      return mesExtenso = "Março";
    }else if(mes==4){
      return mesExtenso = "Abril";
    }else if(mes==5){
      return mesExtenso = "Maio";
    }else if(mes==6){
      return mesExtenso = "Junho";
    }else if(mes==7){
      return mesExtenso = "Julho";
    }else if(mes==8){
      return mesExtenso = "Agosto";
    }else if(mes==9){
      return mesExtenso = "Setembro";
    }else if(mes==10){
      return mesExtenso = "Outubro";
    }else if(mes==11){
      return mesExtenso = "Novembro";
    }else{
      return mesExtenso = "Dezembro";
    }
  }

  buscarMesAbreviado(int mes){

    if(mes==1){
      return mesAbreviado = "Jan";
    }else if(mes==2){
      return mesAbreviado = "Fev";
    }else if(mes==3){
      return mesAbreviado = "Mar";
    }else if(mes==4){
      return mesAbreviado = "Abr";
    }else if(mes==5){
      return mesAbreviado = "Mai";
    }else if(mes==6){
      return mesAbreviado = "Jun";
    }else if(mes==7){
      return mesAbreviado = "Jul";
    }else if(mes==8){
      return mesAbreviado = "Ago";
    }else if(mes==9){
      return mesAbreviado = "Set";
    }else if(mes==10){
      return mesAbreviado = "Out";
    }else if(mes==11){
      return mesAbreviado = "Nov";
    }else{
      return mesAbreviado = "Dez";
    }
  }
}