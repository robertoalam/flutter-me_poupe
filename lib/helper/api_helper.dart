import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/logs/log_rest_model.dart';

class APIHelper {

  static post( opcoes ) async {

    String fullUrl = opcoes['url'].toString();
    String ambiente = await ConfiguracaoModel.buscarConfiguracaoAmbiente;
    
    LogRestModel log = new LogRestModel(
      data: DateTime.now(),
      ambiente: ambiente.toString(),
      url: fullUrl.toString(),
      rest: "ENVIADO",
      dados: opcoes['data'],
    );
    await Funcoes.gravarArquivo( ( (await Funcoes.buscarPastaLogRest).path) .toString() , "rest.txt" , jsonEncode( log.toMap() ) ,limpar: false);

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
        token: opcoes['token'].toString(),
        rest: "RECEBIDO",
        statusCode: response.statusCode,
        dados: json.decode ( response.data )['dados'],
      );
      await Funcoes.gravarArquivo( ( (await Funcoes.buscarPastaLogRest).path) .toString() , "rest.txt" , jsonEncode( log.toMap() ) ,limpar: false);

      retorno['success'] = true;
      retorno['mensagem'] = "";
      retorno['dados'] = json.decode ( response.data )['dados'];
      return retorno;
    
    }on DioError catch (e){

      print("ERRO REQUISICAO: ${e.toString()}");
      LogRestModel log = new LogRestModel(
        ambiente: ambiente.toString(),
        url: fullUrl.toString(),
        rest: "RECEBIDO",
        dados: response.data,
      );
      await Funcoes.gravarArquivo( ( (await Funcoes.buscarPastaLogRest).path) .toString() , "rest.txt" , jsonEncode( log.toMap() ) ,limpar: false);

      retorno['success'] = false;
      retorno['mensagem'] = e.toString();
      retorno['dados'] = null;
      return retorno;
    }
  }
}
