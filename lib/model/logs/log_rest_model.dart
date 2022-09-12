import 'dart:convert';

import 'package:me_poupe/helper/funcoes_helper.dart';

class LogRestModel {
  DateTime data;
  String ambiente;
  String url;
  String token;
  String rest;
  dynamic dados;
  int statusCode;
  String texto;
  String observacao;

  LogRestModel({ 
    this.data, this.ambiente, this.url, this.token, this.statusCode, this.rest, this.dados,
    this.texto, this.observacao
  });


  @override
  String toString() {
    return '${this.data}, ${this.ambiente}';
  }

	Map toMap(){
		var map = new Map<String, dynamic>();
		map["data"] = DateTime.now().toString().split(".")[0];
		map["ambiente"] = this.ambiente;
		map["url"] = this.url;
		map["rest"] = this.rest;
		map["dados"] = this.dados;
		map["status"] = this.statusCode;
		map["texto"] = this.texto;
		map["observacao"] = this.observacao;
		return map;
	}

  factory LogRestModel.fromJson(Map<String, dynamic> json) {
		return LogRestModel(
			data: json['data'],
			ambiente: json['ambiente'],
			url: json['url'],
			token: json['token'],
      rest: json['rest'],
			dados: json['dados'],
		);
  }

  get buscarLogRest async {
    var texto = await Funcoes.lerArquivo( ( (await Funcoes.buscarPastaLogRest).path) .toString() , "rest.txt");
    texto = texto.replaceAll("'", '"');

    List<LogRestModel> _lista = new List<LogRestModel>();

    LineSplitter.split(texto)
      .map((line) {
        var temp = json.decode( line );
        LogRestModel _log = new LogRestModel();
        _log.data = DateTime.parse( temp['data'].toString() );
        _log.ambiente =  temp['ambiente'];
        _log.rest =  temp['rest'];
        _lista.add( _log );
      }).toList();
    return _lista;
  }

}