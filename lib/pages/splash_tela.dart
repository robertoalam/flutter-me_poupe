import 'dart:async';

import 'package:flutter/material.dart';
import 'package:me_poupe/helper/database_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/pages/login/login_tela.dart';
import 'package:me_poupe/pages/tabs_tela.dart';


class SplashTela extends StatefulWidget {
  @override
  _SplashTelaState createState() => _SplashTelaState();
}

class _SplashTelaState extends State<SplashTela> {

	final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();

  }

  @override
  Widget build(BuildContext context) {
	return Container(
    color: Colors.grey,
      child: Center(
        child: Image.asset("assets/images/i9tecnosul.png"),
      ),
	   );
  }

	void _init() async {
    ConfiguracaoModel.incrementAbertura();

		Timer( Duration(seconds: 2) , ()=>
      Navigator.pushReplacement( context,  MaterialPageRoute( builder: (context) => LoginTela() ) ),
		);
  }
}