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
    return "${nova+" "+dataAmericanizada[1]}";
  }

  static somenteData(String valor) {
    List<String> pedacos = valor.split(" ");
    return pedacos[0];
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



}