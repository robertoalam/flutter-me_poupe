import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ArquivoHelper {

  String nomeArquivo;

  ArquivoHelper({this.nomeArquivo});


  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/"+this.nomeArquivo+".txt");
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(String texto) async {
    texto = texto.toString();
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$texto');
  }

  writeFile(String arquivoTexto) async{
    arquivoTexto = arquivoTexto.toString();
    final file = await _localFile;

    // Write the file
     await file.writeAsString('$arquivoTexto');
    return;
  }
}