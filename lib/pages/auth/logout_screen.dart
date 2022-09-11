import 'dart:async';
import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/label/label_quicksand.dart';
import 'package:me_poupe/model/auth/auth_model.dart';
import 'package:me_poupe/pages/splash_tela.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LogoutTela extends StatefulWidget {
  const LogoutTela();

  @override
  State<LogoutTela> createState() => _LogoutTelaState();
}

class _LogoutTelaState extends State<LogoutTela> {

  bool flagLogOut = true;
  AuthModel _login = new AuthModel();

  Widget _body;
  @override
  void initState() {
    super.initState();
    start();
  }

  start() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    //ZERANDO A MEMORIA
    await _prefs.clear();
    int retorno = await _login.logOff();
    if( retorno == 1 ){
      setState(() { flagLogOut = false; });
      Timer( Duration(seconds: 2) , (){
        Navigator.pushReplacement( context,  MaterialPageRoute( builder: (context) => SplashTela() ) );
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    if(flagLogOut){
      _body = Container(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(15),
            color: Colors.white,
            height: MediaQuery.of(this.context).size.height * .3,
            width: MediaQuery.of(this.context).size.width * .7,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularProgressIndicator(),
                  LabelQuicksand('desconectando ...')
                ],
              )
            ),
          ),
        )
      );
    }else{
      _body = Container(
        child: Center(
          child: LabelQuicksand('Redirecionando ...',tamanho: 25,),
        )
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: _body,
    );
  }
}
