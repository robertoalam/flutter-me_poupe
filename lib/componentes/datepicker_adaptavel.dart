import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatepickerAdaptative extends StatelessWidget {

  final DateTime dataSelecionadaController;
  final Function (DateTime) onDateChanged;
  final bool botao;

  DatepickerAdaptative({
    this.dataSelecionadaController ,
    this.onDateChanged ,
    this.botao
  });


  _showDatePicker(BuildContext context){
    showDatePicker(
      context: context ,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2200),
    ).then( (pickedDate){
      if( pickedDate == null){
        return;
      }
      onDateChanged(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    var body ;
    if( Platform.isIOS ){
      body = CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: DateTime.now(),
          minimumDate: DateTime(2021),
          maximumDate: DateTime.now(),
          onDateTimeChanged: onDateChanged
      );
    } else if( this.botao == null || this.botao){
      body = Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child:Text( dataSelecionadaController == null ? "Nenhuma data selecionada !" : "${DateFormat('dd/MM/y').format(dataSelecionadaController)}" , style: TextStyle(fontWeight: FontWeight.bold), ),
          ),
          FlatButton(
            textColor: Theme.of(context).primaryColor,
            onPressed: () => _showDatePicker(context),
            child: Text("Selecionar Data" , style: TextStyle( fontWeight: FontWeight.bold ), ),
          )
        ],
      );
    } else if( this.botao != null && this.botao == false){
      body = InkWell(
          onTap: ()=>_showDatePicker(context),
          child: Text( dataSelecionadaController == null ? "Nenhuma data selecionada !" : "${DateFormat('dd/MM/y').format(dataSelecionadaController)}" , style: TextStyle(fontWeight: FontWeight.bold),),
      );
    }
    return body;
  }
}
