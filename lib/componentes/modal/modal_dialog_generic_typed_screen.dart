import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';

class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
}

class ModalDialogGenericTypedScreen extends StatefulWidget {

  final BuildContext context;
  final List<String> mensagens;
  final int tipo;
  final String titulo;
  final String labelBotaoConfirmar;
  final String labelBotaoCancelar;
  final bool flagExibirBotaoCancelar;

  const ModalDialogGenericTypedScreen(
    this.context ,
    this.mensagens,
    this.tipo,
    {this.titulo,this.labelBotaoConfirmar,this.labelBotaoCancelar,this.flagExibirBotaoCancelar}    
  );

  @override
  State<ModalDialogGenericTypedScreen> createState() => _ModalDialogGenericTypedScreenState();
}

class _ModalDialogGenericTypedScreenState extends State<ModalDialogGenericTypedScreen> {
  IconData _icone;
  var _iconeColor;
  var _colorPrimaria;
  var _colorSecundaria;
  String _labelTela;
  String _labelBotaoConfirmar;
  String _labelBotaoCancelar;
  MainAxisAlignment _alinhamentoBotoes;
  bool _flagExibirBotaoCancelar = false;
  Widget _botaoCancelar = RaisedButton();

  @override
  void initState() {
    super.initState();
    start();    
  }
  
  start(){

    _labelTela = widget.titulo;
    _iconeColor = Colors.white;
    _labelBotaoConfirmar = "CONFIRME";
    _labelBotaoCancelar = "cancel";
    _flagExibirBotaoCancelar = (widget.flagExibirBotaoCancelar == null)?false:widget.flagExibirBotaoCancelar;
    _alinhamentoBotoes = MainAxisAlignment.center;
    
    // ERROR
    if( widget.tipo == 0 ){

      _icone = Icons.close;
      _colorPrimaria = Colors.red;
      if(widget.titulo == null) _labelTela = "ERRO";
      if(widget.labelBotaoConfirmar != null) _labelBotaoConfirmar = widget.labelBotaoConfirmar.toString();

    }else if( widget.tipo == 1 ){
      
      _icone = Icons.check;
      _colorPrimaria = Colors.green;
      if(widget.titulo == null) _labelTela = "SUCESSO";
      if(widget.labelBotaoConfirmar != null) _labelBotaoConfirmar = widget.labelBotaoConfirmar.toString();
      if(widget.labelBotaoCancelar != null) _labelBotaoCancelar = widget.labelBotaoCancelar.toString();

    }else if( widget.tipo == 2 ){

      _icone = Icons.warning;
      _iconeColor = Colors.black;
      _colorPrimaria = Colors.yellow;
      if(widget.titulo == null) _labelTela = "AVISO";
      if(widget.labelBotaoConfirmar != null) _labelBotaoConfirmar = widget.labelBotaoConfirmar.toString();

    }else if( widget.tipo == 3 ){

      _icone = FontAwesomeIcons.info;
      _colorPrimaria = Colors.blue;
      if(widget.titulo == null) _labelTela = "";
      if(widget.labelBotaoConfirmar != null) _labelBotaoConfirmar = widget.labelBotaoConfirmar.toString();
      if(widget.labelBotaoCancelar != null) _labelBotaoCancelar = widget.labelBotaoCancelar.toString();

      _alinhamentoBotoes = MainAxisAlignment.center;     
       
      _botaoCancelar = Expanded(
        flex: 2,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: new FlatButton(
            color: Colors.white,
            onPressed: (){  Navigator.of(context).pop(false); },
            child: Text( "${_labelBotaoCancelar.toString()}" , 
              style: TextStyle(fontSize: 18,color: _colorPrimaria), 
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ) ,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                color: _colorPrimaria,
                width: 1,
                style: BorderStyle.solid
              ), borderRadius: BorderRadius.circular(5)
            ),        
          ),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context){
    
    // print(MediaQuery.of(context).size.height);
    // print(MediaQuery.of(context).size.height * 0.35);

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: Constants.padding,top: Constants.avatarRadius + Constants.padding, 
            right: Constants.padding,bottom: Constants.padding
          ),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(Constants.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black,offset: Offset(0,10),
                blurRadius: 10
              ),
            ]
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                LabelOpensans(_labelTela , tamanho: 29,bold: true,cor: _colorPrimaria,),
                SizedBox(height: 15,),
                Visibility(
                  child: Container(
                    height: 85,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.mensagens.length ,
                      itemBuilder: (context, index) {
                        return Text("• ${widget.mensagens[index].toString()}",
                          style: TextStyle(fontSize: 16,fontFamily: "OpenSans",)
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 22,),
                Row(
                  mainAxisAlignment: _alinhamentoBotoes,
                  children: [
                    Visibility(
                      visible: _flagExibirBotaoCancelar,
                      child: _botaoCancelar,
                    ),
                    Expanded(
                      flex: 2,
                      child: FlatButton(
                        color: _colorPrimaria,
                        onPressed: (){  Navigator.of(context).pop(true); },
                        child: LabelOpensans( _labelBotaoConfirmar ,bold: true , tamanho: 18 ,cor: Colors.white , ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: _colorPrimaria ,
            radius: Constants.avatarRadius,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Icon( _icone, color: _iconeColor ,size: 55,)
              ),
            ),
          ),
        ),
      ],
    );
  }
}