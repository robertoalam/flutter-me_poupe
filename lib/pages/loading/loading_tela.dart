import 'package:flutter/material.dart';

class LoadingTela extends StatefulWidget {
  @override
  _LoadingTelaState createState() => _LoadingTelaState();
}

class _LoadingTelaState extends State<LoadingTela> {
  Widget _body;


  @override
  Widget build(BuildContext context) {

    _body = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LinearProgressIndicator(),

      ],
    );

    return Scaffold(
      body: _body,
    );
  }
}
