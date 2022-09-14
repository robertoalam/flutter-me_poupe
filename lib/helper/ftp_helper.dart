
import 'dart:io';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/logs/log_model.dart';
import 'funcoes_helper.dart';

class FTPHelper {
  
  static send( arquivo ) async {

    String ftpHost = (await ConfiguracaoModel.buscarConstantesAmbiente)['ftp_host'].toString();
    String ftpHostUser = (await ConfiguracaoModel.buscarConstantesAmbiente)['ftp_host_user'].toString();
    String ftpHostPass = (await ConfiguracaoModel.buscarConstantesAmbiente)['ftp_host_pass'].toString();

    FTPConnect ftpConnect = FTPConnect( ftpHost ,user: ftpHostUser , pass: ftpHostPass );
    try {
      File fileToUpload = File( arquivo );
      await ftpConnect.connect();
      await ftpConnect.uploadFile(fileToUpload);
      await ftpConnect.disconnect();
      return true;
    } catch (e) {
      print("ERRO [3]: ${e.toString()}");      
      // GRAVAR LOG
      await Funcoes.logGravar( new LogModel( Tipo.ERRO, e.toString() ) );   
      return false;
    }

  }
}