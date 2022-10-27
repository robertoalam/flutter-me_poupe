import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/logs/log_model.dart';
import 'package:me_poupe/model/logs/log_rest_model.dart';

class APIHelper {
  
  Dio dio;
  CancelToken token;
  String fullUrl;
  String ambiente;
  Map<String,dynamic> retorno = new Map();

  APIHelper(){
    dio = new Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: ( 
          RequestOptions options
        ) async {
          token = CancelToken();
          options.cancelToken = token;
          return options; //continue
        }
      )
    ); 
  }

  post( opcoes ) async {
    fullUrl = opcoes['url'].toString();
    ambiente = await ConfiguracaoModel.buscarConfiguracaoAmbiente;
    
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: ( 
          RequestOptions options
        ) async {
          token = CancelToken();
          options.cancelToken = token;
          return options; //continue
        }
      )
    );    

    Response response;

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
      retorno['cancel'] = false;
      retorno['status'] = response.statusCode;
      retorno['mensagem'] = "correto";
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

  fetch ( opcoes ) async {
    fullUrl = opcoes['url'].toString();
    ambiente = await ConfiguracaoModel.buscarConfiguracaoAmbiente;
    
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: ( 
          RequestOptions options
        ) async {
          token = CancelToken();
          options.cancelToken = token;
          return options; //continue
        }
      )
    );    

    Response response;

    try{
      response = await dio.get( 
        opcoes['url']
      );

      LogRestModel log = new LogRestModel(
        data: DateTime.now(),
        ambiente: ambiente.toString(),
        url: fullUrl.toString(),
        verbo: "GET",
        statusCode: response.statusCode,
        dadosEnviado: opcoes['data'],
        dadosRecebido: json.decode ( response.data )['dados'],
      );
      await Funcoes.gravarArquivo( ( (await Funcoes.buscarPastaLog).path) .toString() , "rest.txt" , jsonEncode( log.toMap() ) ,limpar: false);

      retorno['success'] = true;
      retorno['cancel'] = false;
      retorno['status'] = response.statusCode;
      retorno['mensagem'] = "correto";
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

  get cancelar {
    retorno['cancel'] = true;
    return token.cancel();
  }
}