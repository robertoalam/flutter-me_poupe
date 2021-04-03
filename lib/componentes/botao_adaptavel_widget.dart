import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BotaoAdptavelWidget extends StatelessWidget {
    final String label;
    final Function onPressed;
    final Color cor;

    BotaoAdptavelWidget({ this.label , this.onPressed , this.cor});

  @override
  Widget build(BuildContext context) {
    
    Color corBotao = (this.cor != null)? cor : Theme.of(context).primaryColor;

    return Platform.isIOS
        ?
            CupertinoButton(
                child: Text( label ),
                onPressed: onPressed ,
                color: corBotao,
            )
        :
        RaisedButton(
            child: Text( label ),
            onPressed: onPressed ,
            color: Theme.of(context).primaryColor,
            textColor: corBotao ,
        );
    }
}
