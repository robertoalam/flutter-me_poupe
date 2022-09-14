import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/logs/log_model.dart';
import 'package:me_poupe/model/logs/log_rest_model.dart';

class APIHelper {

  static post( opcoes ) async {

    String fullUrl = opcoes['url'].toString();
    String ambiente = await ConfiguracaoModel.buscarConfiguracaoAmbiente;
    
    Dio dio = new Dio();
    Response response;
    Map<String,dynamic> retorno = new Map();

    try{
      response = await dio.post( 
        opcoes['url'] ,
        data: opcoes['data']
      );

      LogRestModel log = new LogRestModel(
        data: DateTime.now(),
        ambiente: ambiente.toString(),
        url: fullUrl.toString(),
        verbo: "POST",
        statusCode: response.statusCode,
        dadosEnviado: opcoes['data'],
        dadosRecebido: json.decode ( response.data )['dados'],
      );
      await Funcoes.gravarArquivo( ( (await Funcoes.buscarPastaLog).path) .toString() , "rest.txt" , jsonEncode( log.toMap() ) ,limpar: false);

      retorno['success'] = true;
      retorno['mensagem'] = "";
      retorno['dados'] = json.decode ( response.data )['dados'];
      return retorno;
    
    }on DioError catch (e){

      await Funcoes.logGravar( 
        new LogModel( Tipo.ERRO, e.toString() ) 
      );

      retorno['success'] = false;
      retorno['mensagem'] = e.toString();
      retorno['dados'] = null;
      return retorno;
    }
  }


}