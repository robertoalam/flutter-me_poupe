import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';

class APIHelper {

  static post( opcoes ) async {

    String logTexto = "";
    int contador = 0;
    String fullUrl = opcoes['url'].toString();
    String ambiente = await ConfiguracaoModel.buscarConfiguracaoAmbiente;
    logTexto += "DATETIME \t[0${(++contador).toString()}]: ${new DateTime.now().toString().split(".")[0]}";
    logTexto += "\nAMBIENTE \t[0${(++contador).toString()}]: ${ambiente.toString()}";
    logTexto += "\nURL \t\t[0${(++contador).toString()}]: ${fullUrl.toString()}";
    logTexto += "\nTOKEN \t\t[0${(++contador).toString()}]: ${opcoes['token'].toString()}";
    logTexto += "\nDADOS SAIDA [0${(++contador).toString()}]: ${jsonEncode(opcoes['data']).toString()}";
  
    Dio dio = new Dio();
    Response response;
    Map<String,dynamic> retorno = new Map();

    try{
      response = await dio.post( 
        opcoes['url'] ,
        data: opcoes['data']
      );

      logTexto += "\nDADOS VOLTA [0${(++contador).toString()}]: ${response.data.toString()}";
      await Funcoes.gravarArquivo( ( (await Funcoes.buscarPastaLogRest).path) .toString() , "rest.txt" , logTexto ,limpar: false);      

      retorno['success'] = true;
      retorno['mensagem'] = "";
      retorno['dados'] = json.decode ( response.data )['dados'];
      return retorno;
    
    }on DioError catch (e){

      print("ERRO REQUISICAO: ${e.toString()}");
      logTexto += "\nDADOS VOLTA [0${(++contador).toString()}]: ${e.toString()}";      
      await Funcoes.gravarArquivo( ( (await Funcoes.buscarPastaLogRest).path) .toString() , "rest.txt" , logTexto ,limpar: false);

      retorno['success'] = false;
      retorno['mensagem'] = e.toString();
      retorno['dados'] = null;
      return retorno;
    }
  }
}
