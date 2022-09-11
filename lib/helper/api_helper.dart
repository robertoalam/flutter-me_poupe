import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';

class APIHelper {

  static post( opcoes ) async {
    String logTexto = "";
    int contador = 0;
    String fullUrl = opcoes.url + opcoes.apiUrl;
    String ambiente = await ConfiguracaoModel.buscarConfiguracaoAmbiente;
    logTexto += "DATETIME \t[0${(++contador).toString()}]: ${new DateTime.now().toString().split(".")[0]}";
    logTexto += "\nAMBIENTE \t[0${(++contador).toString()}]: ${ambiente.toString()}";
    logTexto += "\nURL \t\t[0${(++contador).toString()}]: ${fullUrl.toString()}";
    logTexto += "\nTOKEN \t\t[0${(++contador).toString()}]: ${opcoes.token.toString()}";
    logTexto += "\nDADOS SAIDA [0${(++contador).toString()}]: ${jsonEncode(opcoes.data).toString()}";
  
    Dio dio = new Dio();
    Response response;
    var retorno;
    try{
      response = await dio.post(
        "http://192.168.0.110/i9tecnosul.com.br/auth/api/v1/basic/logon",
        data: {	"user_name":"robertoaa1981@gmail.com","user_pass":"8671b3HJ+11"}
      );
      print("DIO: ${response.data}");
      return response.data;
    }on DioError catch (e){
      print("ERRO REQUISICAO: ${e.toString()}");
      retorno['success'] = false;
      retorno['mensagem'] = e.toString();

      return retorno = false;
    }


    await Funcoes.gravarArquivo( ( (await Funcoes.buscarPastaLogRest).path) .toString() , "rest.txt" , logTexto ,limpar: false);
  }
}