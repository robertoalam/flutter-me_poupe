import 'dart:convert';
import 'package:me_poupe/helper/funcoes_helper.dart';

class LogModel {
  DateTime data;
  dynamic tipo;
  String metodo;
  String mensagem;
  String texto;
  String observacao;

  static final String ARQUIVO = "error.txt";

  LogModel( 
    this.tipo, this.mensagem, 
    { this.metodo , this.data, this.texto, this.observacao }
  );

  @override
  String toString() { return '${this.data}, ${this.mensagem}'; }

	Map toMap(){
		var map = new Map<String, dynamic>();
		map["data"] = DateTime.now().toString().split(".")[0];
		map["tipo"] = this.tipo.toString().split(".")[1];
		map["metodo"] = this.metodo.toString();
		map["mensagem"] = this.mensagem;
		map["texto"] = this.texto;
		map["observacao"] = this.observacao;
		return map;
	}

  factory LogModel.fromJson(Map<String, dynamic> json) {
		return LogModel(
      json['tipo'],
      json['mensagem'],
			metodo: json['metodo'],
			data: DateTime.parse( json['data'] ),
			texto: json['texto'],
			observacao: json['observacao'],
		);
  }

  get buscarArquivoLog async {
    var texto = await Funcoes.lerArquivo( ( (await Funcoes.buscarPastaLog).path) .toString() , ARQUIVO);
    texto = texto.replaceAll("'", '"');

    List<LogModel> _lista = new List<LogModel>();
    LineSplitter.split(texto)
      .map((line) {
        LogModel _log = LogModel.fromJson( json.decode( line ) );
        _lista.add( _log );
      }).toList();
    return _lista;
  }
}

enum Tipo{
  INFO,
  AVISO,
  ERRO
}
