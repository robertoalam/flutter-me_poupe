import 'dart:convert';

import 'package:me_poupe/helper/funcoes_helper.dart';

class LogRestModel {
  DateTime data;
  String ambiente;
  String url;
  String token;
  dynamic verbo;
  dynamic dadosEnviado;
  dynamic dadosRecebido;
  int statusCode;
  String texto;
  String observacao;

  static final String ARQUIVO = "rest.txt";

  LogRestModel({ 
    this.data, this.ambiente, this.url, this.token, this.statusCode, this.verbo, 
    this.dadosEnviado, this.dadosRecebido , this.texto, this.observacao
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
		map["verbo"] = this.verbo;
		map["status"] = this.statusCode;    
		map["dadosEnviado"] = this.dadosEnviado;
		map["dadosRecebido"] = this.dadosRecebido;
		map["texto"] = this.texto;
		map["observacao"] = this.observacao;
		return map;
	}

  factory LogRestModel.fromJson(Map<String, dynamic> json) {
		return LogRestModel(
			data: DateTime.parse( json['data'] ),
			ambiente: json['ambiente'],
			url: json['url'],
			token: json['token'],
      verbo: json['verbo'],
			statusCode: json['status'],
			dadosEnviado: json['dadosEnviado'],
			dadosRecebido: json['dadosRecebido'],
		);
  }

  get buscarLogRest async {
    var texto = await Funcoes.lerArquivo( ( (await Funcoes.buscarPastaLog).path) .toString() , "rest.txt");
    texto = texto.replaceAll("'", '"');

    List<LogRestModel> _lista = new List<LogRestModel>();
    LineSplitter.split(texto)
      .map((line) {
        LogRestModel _log = LogRestModel.fromJson( json.decode( line ) );
        _lista.add( _log );
      }).toList();
    return _lista;
  }
}
