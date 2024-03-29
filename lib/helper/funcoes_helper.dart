import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:intl/intl.dart';
import 'package:me_poupe/componentes/modal/modal_dialog_generic_typed_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform_device_id/platform_device_id.dart';

class Funcoes{

  static converterCorStringColor(String hexadecimal){
    return hexadecimal.replaceAll('#', '0xff');
  }

  static converterMoedaParaDatabase(String valor) {
    if (valor.length <= 5) {
      return valor.replaceAll(',', '.');
    } else {
      return valor.replaceAll('.', '').replaceAll(',', '.');
    }
  }

  static converterDateParaDataEUAString( data ){
    final DateFormat dataFormatada = DateFormat('yyyy-MM-dd');
    return dataFormatada.format( DateTime.parse( data.toString() ) );
  }

  static verificarTimeStamp(dataTimestamp){
    int posicaoPonto = dataTimestamp.toString().indexOf(".");
    if(posicaoPonto > -1){
      dataTimestamp = dataTimestamp.toString().substring(0, dataTimestamp.toString().length-(dataTimestamp.toString().length-posicaoPonto));
      return dataTimestamp;
    }
    return dataTimestamp;
  }

  static converterDataEUAParaBR(String valor, {bool retornarHorario}) {
    List<String> dataAmericanizada = valor.toString().split(" ");
    List<String> dataAmericanizadaExplode = dataAmericanizada[0].toString().split("-");
    String nova = dataAmericanizadaExplode[2]+"/"+dataAmericanizadaExplode[1]+"/"+dataAmericanizadaExplode[0];
    if(retornarHorario ==null || retornarHorario == false){
      return nova;
    }
    return "${nova+" "+dataAmericanizada[1].toString().split(".")[0].toString()}";
  }

  static somenteData(String valor) {
    List<String> pedacos = valor.split(" ");
    return pedacos[0];
  }

  static somenteHora(String valor) {
    List<String> pedacos = valor.split(" ");
    return pedacos[1].toString().split(".")[0];
  }

  static converterDataBRParaEUA(String valor, {bool retornarHorario}) {
    List<String> dataBrasil = valor.toString().split(" ");
    List<String> dataBrasilExplode = dataBrasil[0].toString().split("/");
    String nova = dataBrasilExplode[2]+"-"+dataBrasilExplode[1]+"-"+dataBrasilExplode[0];
    if(retornarHorario ==null || retornarHorario == false){
      return nova;
    }
    return "${nova+" "+dataBrasil[1]}";
  }

  static dataAtualBr({bool retornarHorario}){
    List<String> somenteData;
    String dataBr ;
    List<String> dataBrTruncado;
    if(retornarHorario ==null || retornarHorario == false){
      somenteData = new DateTime.now().toString().split(" ");
      dataBr = somenteData[0].toString();
      dataBrTruncado = dataBr.split("-");
      return dataBrTruncado[2]+"/"+dataBrTruncado[1]+"/"+dataBrTruncado[0];
    }

    somenteData = Funcoes.verificarTimeStamp( new DateTime.now() ).toString().split(" ");
    dataBr = somenteData[0].toString();
    String horario = somenteData[1].toString();
    dataBrTruncado = dataBr.split("-");
    return dataBrTruncado[2]+"/"+dataBrTruncado[1]+"/"+dataBrTruncado[0]+ " "+horario;
  }

  static dataAtualEUA({bool retornarHorario}){
    if(retornarHorario ==null || retornarHorario == false){
      List<String> somenteData = new DateTime.now().toString().split(" ");
      return somenteData[0];
    }
    return Funcoes.verificarTimeStamp( new DateTime.now() );
  }

  static retornarDiaDataEUA(DateTime data){
    return data.day;
  }

  static retornarMesDataEUA(DateTime data){
    if(data.month == 1){
      return "janeiro";
    }else if(data.month == 2){
      return "fevereiro";
    }else if(data.month == 3){
      return "março";
    }else if(data.month == 4) {
      return "abril";
    }else if(data.month == 5){
      return "maio";
    }else if(data.month == 6) {
      return "junho";
    }else if(data.month == 7){
      return "julho";
    }else if(data.month == 8){
      return "agosto";
    }else if(data.month == 9) {
      return "setembro";
    }else if(data.month == 10){
      return "outubro";
    }else if(data.month == 11) {
      return "novembro";
    }else{
      return "dezembro";
    }
  }

  static gerarIdentificador(usuario , {String data}){
    String usuarioTruncado = usuario.toString().padLeft(7, '0');
    String dataTruncado;
    if(data == null){
      dataTruncado = Funcoes.verificarTimeStamp( Funcoes.dataAtualEUA(retornarHorario: true) ).toString().replaceAll("-","").replaceAll(":","").replaceAll(" ", "");
    }else{
      dataTruncado = data.toString().replaceAll('-', '').replaceAll(':', '').replaceAll(' ', '');
    }
    return "${ dataTruncado + usuarioTruncado }";
  }

  static Future<String> get buscarVersao async {
    return await rootBundle.loadString('assets/git/versao.txt');
  }

  static Future<Directory> get buscarPastaAPP async {
    return Directory( ( ( Directory.systemTemp).path ).toString() );
  }

  static Future<Directory> get buscarPastaLog async {
    return Directory( ( (await getApplicationDocumentsDirectory()).path).toString()+"/logs/" );
  } 

  static Future<String> get buscarDeviceId async {
    try {
      return await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      // GRAVAR ARQUIVO
      await Funcoes.gravarArquivo( ( (await Funcoes.buscarPastaLog).path) .toString() , "rest.txt" , "ERRO BUSCAR DEVICE ID" ,limpar: false);
      return null;    
    }    
  }

  static Future<Directory> criarPasta(String diretorio) async{
    final Directory diretorioNovo = Directory(diretorio); 
    if(await diretorioNovo.exists()){
      return diretorioNovo;
    }else{
      final Directory diretoNovoCriado = await diretorioNovo.create(recursive: true);
      return diretoNovoCriado;
    }
  }    

  static Future<File> criarArquivo(Directory diretorio , String nomeArquivo) async {
    try{
      return File(diretorio.path.toString()+nomeArquivo.toString());
    }catch(e){
      return File("${ (await getApplicationDocumentsDirectory()).path }/default.txt");
    }
  }  

  // METODOS P/GRAVAR LOGS FISICOS
  static Future<File> gravarArquivo(String diretorio, String nomeArquivo , String texto ,  { bool limpar = false}) async {
    texto = texto.toString();
    Directory dir = await Funcoes.criarPasta( diretorio.toString() );
    final File file = await Funcoes.criarArquivo( dir , nomeArquivo );

    if( await file.exists() ) {
      if( limpar == false) { 
        texto += "\n";
        texto += await file.readAsString();
      }
    }
    return file.writeAsString('$texto');
  }

  // METODOS P/GRAVAR LOGS FISICOS
  static Future<File> logGravarRest( log ,  { bool limpar = false}) async {
    return await Funcoes.gravarArquivo( ( (await Funcoes.buscarPastaLog).path) .toString() , "rest.txt" , jsonEncode( log.toMap() ) ,limpar: false);
  }

  // METODOS P/GRAVAR LOGS FISICOS
  static Future<File> logGravar( log ,  { bool limpar = false}) async {
    return await Funcoes.gravarArquivo( ( (await Funcoes.buscarPastaLog).path) .toString() , "error.txt" , jsonEncode( log.toMap() ) ,limpar: false);
  }

  // METODOS P/GRAVAR LOGS FISICOS
  static Future<String> lerArquivo(String diretorio, String nomeArquivo ) async {
    String texto = "";
    Directory dir = Directory( diretorio );
    final File file = File(dir.path.toString()+nomeArquivo.toString());

    if( await file.exists() ) {
      texto = await file.readAsString();
    }
    return texto;
  }

  static modalExibir(context, List mensagens, int tipo, 
    {
      String botaoLabel,
      bool showButtonCancel ,
      String botaoLabelCancelar
    }
  ) async {
      return await showDialog(
      context: context,
      builder: (context) {
        return ModalDialogGenericTypedScreen(context , mensagens,tipo , labelBotaoConfirmar: botaoLabel );
      }
    );
  } 

  // ZIPAR ARQUIVO
  static zipCriarArquivo(String zipLocalDoArquivo , List<File> lista) async {
    final sourceDir = Directory( ( (await Funcoes.buscarPastaAPP).path).toString() );
    // CRIANDO O ARQUIVO ZIP COM O NOME ESCOLHIDO
    final zipFile = File( zipLocalDoArquivo );
    try {
      await ZipFile.createFromFiles(sourceDir: sourceDir, files: lista, zipFile: zipFile , includeBaseDirectory: true);  
      return true;
    } catch (e) {
      
      // GRAVAR LOG
      // LogModel log = new LogModel(tipo: "ERRO",operacao: "", classe: "Funcoes", metodo: "zipCriarArquivo",  tabela: "" , dados: "Erro ao criar arquivo zip: ${e.toString()}" );      
      // log.save();          
      print(e);
      return false;
    }
  }
}