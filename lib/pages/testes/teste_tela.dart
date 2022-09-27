import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/componentes/label/label_quicksand.dart';
import 'package:me_poupe/helper/ftp_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/logs/log_model.dart';
import 'package:me_poupe/pages/testes/teste_rest_tela.dart';
import 'package:me_poupe/pages/testes/teste_variaveis_constantes.dart';
import '../configuracoes/icones_list_tela.dart';

class TesteTela extends StatefulWidget {
  const TesteTela();

  @override
  State<TesteTela> createState() => _TesteTelaState();
}

class _TesteTelaState extends State<TesteTela> {
	// CORES TELA
	var listaCores ;
	Color _corAppBarFundo = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorBackground = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorContainerFundo = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorContainerBorda = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorFundo = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorLetra = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );

  ConfiguracaoModel _config = new ConfiguracaoModel();
  var _status = null;
  IconData icone;
  String _mensagem = "";
  List _lista = [];

  @override
  void initState() {
    _start();
    super.initState();
  }
	  
	_start() async { await montarTela(); }
	
	montarTela() async {
		listaCores = await ConfiguracaoModel.buscarEstilos;
		setState(() {
		  _corAppBarFundo = Color(int.parse( Funcoes.converterCorStringColor( listaCores['corAppBarFundo'] ) ) );
		  _colorBackground = Color(int.parse( Funcoes.converterCorStringColor( listaCores['background'] ) ) );
		  _colorContainerFundo = Color(int.parse( Funcoes.converterCorStringColor( listaCores['containerFundo'] ) ) );
		  _colorContainerBorda = Color(int.parse( Funcoes.converterCorStringColor( listaCores['containerBorda'] ) ) );
		  _colorLetra = Color(int.parse( Funcoes.converterCorStringColor( listaCores['textoPrimaria'] ) ) );
		});
		return;
	}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorBackground ,
      appBar: AppBar(
        title: Text("Testes"),
        backgroundColor: _corAppBarFundo,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            _Elemento( context , Icons.format_paint , "Icones" , "Lista de Icones" , IconeListTela() ),
            Divider( color: _colorLetra, ),
            _Elemento( context , Icons.cloud , "Variaveis & Constantes" , "na sharedpreferences e database" , TesteVariaveisConstantes()),
            Divider( color: _colorLetra, ),             
            _Elemento( context , Icons.cloud , "REST" , "lista de servicos " , TesteRestTela()),
            Divider( color: _colorLetra, ), 
            InkWell(
              onTap: () async { await _ftpConnecte(); },
              child: _ElementoSemRota( context , Icons.cloud_download , "FTP Connect" , "enviar logs por FTP "),
            ),           
            Divider( color: _colorLetra, ), 
            InkWell(
              onTap: () async { await _exportarFTP; },
              child: _ElementoSemRota( context , Icons.cloud_download , "FTP" , "enviar logs por FTP "),
            ),           
            Divider( color: _colorLetra, ), 

          ],
        ),
      ),
    );
  }

get _exportarFTP async {
  setState(() { _status = null; _mensagem = "criando arquivo de exportação"; });    
  String diretorio = ( await Funcoes.buscarPastaLog).path.toString() ;
  String deviceId = await Funcoes.buscarDeviceId;
  String arquivoDDL = "rest.txt";
  String arquivoDML = "error.txt";
  
  // ZIPAR ARQUIVO
  List<File> listaArquivo = new List<File>();
  listaArquivo.add( File( "${diretorio.toString()}${arquivoDDL.toString()}") );
  listaArquivo.add( File( "${diretorio.toString()}${arquivoDML.toString()}") );
  String arquivoZipLocal = ( ( await Funcoes.buscarPastaAPP).path.toString() );
  String arquivoZipNome = "database-${deviceId.toString()}.zip";
  String arquivoZipLocalNome = (arquivoZipLocal+"/"+arquivoZipNome);

  try{
    await Funcoes.zipCriarArquivo( arquivoZipLocalNome , listaArquivo );
  } catch ( e ){
    print("ERRO [1]: ${e.toString()}");
    // GRAVAR LOG
    await Funcoes.logGravar( new LogModel( Tipo.ERRO, e.toString() ) );
    
    await Funcoes.modalExibir(context,['ERRO AO ZIPAR ARQUIVO'] as List<String>, 0 );      
    return ; 
  }
  
  // 3º ENVIAR ARQUIVO
  try{
    setState(() { _mensagem = "enviando arquivo para servidor"; });  
    await _databaseArquivoEnviar( arquivoZipLocal , arquivoZipNome );
  } catch(e){
    print("ERRO [2]: ${e.toString()}");    
    // GRAVAR LOG
    await Funcoes.logGravar( new LogModel( Tipo.ERRO, e.toString() ) );

    await Funcoes.modalExibir(context,['ERRO AO ENVIAR ARQUIVO'] as List<String> , 0 );
    return ;      
  }

  await Funcoes.modalExibir(context,['ENVIADO COM SUCESSO !'] as List<String>, 1 );    
  setState(() { _status = "1"; });
  return;
}

  _databaseArquivoEnviar(String diretorio , String nome ) async {
    await FTPHelper.send( "${diretorio.toString()}/${nome.toString()}" );
    return ;
  }

_ftpConnecte() async {
  String ftpHost = (await ConfiguracaoModel.buscarConstantesAmbiente)['ftp_host'].toString();
  String ftpHostUser = (await ConfiguracaoModel.buscarConstantesAmbiente)['ftp_host_user'].toString();
  String ftpHostPass = (await ConfiguracaoModel.buscarConstantesAmbiente)['ftp_host_pass'].toString();
  FTPConnect ftpConnect;
  try{
    ftpConnect = FTPConnect( ftpHost ,user: ftpHostUser , pass: ftpHostPass+"11" );  
    await ftpConnect.connect();
  }catch(e){
    // GRAVAR LOG
    await Funcoes.logGravar( new LogModel( Tipo.ERRO, e.toString() ) );      
  }
}

  _ElementoSemRota( context,  icone , titulo , subtitulo ){
    return Container(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _colorLetra,
          child: Icon( icone ,  color: _colorBackground),
        ),
        title: LabelOpensans( titulo , bold: true, cor: _colorLetra ),
        subtitle: LabelQuicksand( subtitulo , cor: _colorLetra ),
      ),
    );
  }

  _Elemento( context,  icone , titulo , subtitulo, rota){
    return Container(
      child: ListTile(
        onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => rota )); },
        leading: CircleAvatar(
          backgroundColor: _colorLetra,
          child: Icon( icone ,  color: _colorBackground),
        ),
        title: LabelOpensans( titulo , bold: true, cor: _colorLetra ),
        subtitle: LabelQuicksand( subtitulo , cor: _colorLetra ),
      ),
    );
  }
}