import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/componentes/label/label_quicksand.dart';
import 'package:me_poupe/helper/api_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/auth/auth_model.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/logs/log_model.dart';

class TesteRestLogonCancelTela extends StatefulWidget {
  const TesteRestLogonCancelTela();

  @override
  State<TesteRestLogonCancelTela> createState() => _TesteRestLogonCancelTelaState();
}

class _TesteRestLogonCancelTelaState extends State<TesteRestLogonCancelTela> {

  AuthModel _auth = new AuthModel();
  ConfiguracaoModel _config = new ConfiguracaoModel();

  bool _flagRequisicao = false;
  Widget _body;
  List<String> _modalMensagens = [];

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _senhaController = new TextEditingController();
  bool _flagExibirSenha = false;

  var body;
  // CORES TELA
  Color _corAppBarFundo =  Color( int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
  Color _background = Color( int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
  Color _colorContainerFundo = Color( int.parse(Funcoes.converterCorStringColor("#FFFFFF") ) );
  Color _colorContainerBorda = Color( int.parse(Funcoes.converterCorStringColor("#FFFFFF") ) );
  Color _colorFundo = Color( int.parse(Funcoes.converterCorStringColor("#FFFFFF") ) );
  Color _colorLetra = Color( int.parse(Funcoes.converterCorStringColor("#FFFFFF") ) );
  var listaCores ;

  APIHelper _apiHelper = new APIHelper();

  @override
  void initState() {
    _start();
    super.initState();
  }

  _start() async {
    _config = await _config.fetchByChave('debug');
    if( _config.valor.toString().toLowerCase() == "true"){
      _emailController.text = "robertoaa1981@gmail.com";
      _senhaController.text = "8671b3HJ+11";
    }    
    await montarTela();
    buscarDados();
  }

  montarTela() async {
    listaCores = await ConfiguracaoModel.buscarEstilos;
    setState(() {
      _corAppBarFundo =  Color( int.parse( Funcoes.converterCorStringColor( listaCores['corAppBarFundo'] ) ) );
      _background = Color( int.parse(Funcoes.converterCorStringColor( listaCores['background'] ) ) );
      _colorContainerFundo = Color( int.parse(Funcoes.converterCorStringColor( listaCores['containerFundo'] ) ) ) ;
      _colorContainerBorda = Color( int.parse(Funcoes.converterCorStringColor( listaCores['containerBorda'] ) ) );
      _colorLetra = Color( int.parse(Funcoes.converterCorStringColor( listaCores['textoPrimaria'] ) ) );
    });
    return;
  }

  buscarDados() async {
    // await montarTela();
    _flagRequisicao = false;
  }

  @override
  Widget build(BuildContext context) {

    if( !_flagRequisicao ){
      _body = Scaffold(
        appBar: AppBar(
          title: LabelOpensans("TESTE CANCELAR LOGON"),
          backgroundColor: _colorContainerFundo,
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.only(top:20 , left: 40 , right: 40),
          color: _colorContainerFundo,
          child: ListView(
            children: [
              SizedBox(
                width: 128,
                height: 128,
                child: Image.asset("assets/images/porco_01.png"),
              ),
              TextFormField(
                controller: _emailController,                
                // autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: _colorLetra,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  )
                ),
                style: TextStyle(fontSize: 20,color: _colorLetra),
              ),

              TextFormField(
                controller: _senhaController,
                // autofocus: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Senha",
                  labelStyle: TextStyle(
                    color:_colorLetra,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() { _flagExibirSenha = !_flagExibirSenha; }),
                    child: Icon( _flagExibirSenha ? Icons.visibility : Icons.visibility_off , color: _colorLetra,),
                  ),
                ),
                obscureText: false,                  
                style: TextStyle(fontSize: 20,color: _colorLetra),
              ),
              SizedBox(height: 20, ),
              Container(
                height: 60,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all( Radius.circular(5)),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    color: Theme.of(context).primaryColor,
                    child: LabelQuicksand("LOGAR", cor: _colorLetra , bold: true, tamanho: 20 ),
                    onPressed: () async {
                      _modalMensagens.clear();
                      _bloquearTela( true );
                      var retorno = await _autenticacaoEmailAndSenha();
                      _bloquearTela( false );

                      // SALVAR NA MEMORIA DADO USUARIO
                      if( retorno['cancel'] == true){
                        _modalMensagens.add("Requisição de login, CANCELADA !");
                        await Funcoes.modalExibir(context, _modalMensagens ,3);
                        return;
                      }

                      // SALVAR NA MEMORIA DADO USUARIO
                      if( retorno['success'] == false){
                        _modalMensagens.add("ERRO: email ou senha incorretos !");
                        await Funcoes.modalExibir(context,_modalMensagens,0);
                        return;
                      }

                      if ( await _autenticacaoSalvar( retorno['dados'] ) != true){
                        _modalMensagens.add("ERRO: autenticação não foi salva !");
                        await Funcoes.modalExibir(context,_modalMensagens,0);
                        return;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      _body = Scaffold(
        body: SafeArea(
          child: Container(
            color: _colorContainerFundo,
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 15,),
                LabelQuicksand(" enviando ... ",bold: true,tamanho: 22,cor: _colorLetra,),
                SizedBox(height: 50,),
                InkWell(
                  onTap: () { _apiHelper.cancelar; },
                  child: LabelOpensans("cancelar requisição !?",bold: true,cor: Colors.red,),
                ),

              ],
            ),
          )
        ),
      );
    }
    return _body;
  }

  
  _autenticacaoSalvar( dados ) async {
    bool flagErro = true;
    try{
      await _auth.create( dados );
    }catch(e){
      print("ERRO DATABASE: ${e.toString()}");      
      flagErro = false;
    }

    try{
      await ConfiguracaoModel.sharedPreferencesSalvarDados(dados);
    }catch(e){
      print("ERRO MEMORIA: ${e.toString()}");
      flagErro = false;
    }
    return flagErro;

  }


  _autenticacaoEmailAndSenha() async {
    var constantes = await ConfiguracaoModel.buscarConstantesAmbiente;
    var _host = constantes['host_auth'].toString();
    var _servico = constantes['auth_loging'].toString();

    try{
      return await _apiHelper.post({
        "data":{
          "user_name" : _emailController.text.toString().trim(), 
          "user_pass" : _senhaController.text.toString().trim(), 
        },
        "url": "${_host+_servico}"
      });
    }on DioError catch (e){
      print("ERROR: ${e.toString()}");
      await Funcoes.logGravar( new LogModel( Tipo.ERRO, e.toString() ) );      
      return null;
    }
  }

  _bloquearTela( bool flag){ setState(() { _flagRequisicao = flag; }); }
}

