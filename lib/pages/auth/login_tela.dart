import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/componentes/label/label_quicksand.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/auth/auth_model.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configuracoes/configuracoes_tela.dart';
import '../splash_tela.dart';
import '../tabs_tela.dart';


class LoginTela extends StatefulWidget {
  const LoginTela();

  @override
  State<LoginTela> createState() => _LoginTelaState();
}

class _LoginTelaState extends State<LoginTela> {
  
  AuthModel _auth = new AuthModel();
  ConfiguracaoModel _config = new ConfiguracaoModel();

  bool _flagRequisicao = false;
  Widget _body;
  SharedPreferences _shared;
  List<String> _modalMensagens = [];

  TextEditingController _emailController = new TextEditingController();
  bool _emailFlagErro = false;

  TextEditingController _senhaController = new TextEditingController();
  bool _senhaFlagErro = false;
  bool _flagExibirSenha = false;

  var body;
  bool _modoNoturno = false;
  var _dados = null;
  // CORES TELA
  Color _corAppBarFundo =  Color( int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
  Color _background = Color( int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
  Color _colorContainerFundo = Color( int.parse(Funcoes.converterCorStringColor("#FFFFFF") ) );
  Color _colorContainerBorda = Color( int.parse(Funcoes.converterCorStringColor("#FFFFFF") ) );
  Color _colorFundo = Color( int.parse(Funcoes.converterCorStringColor("#FFFFFF") ) );
  Color _colorLetra = Color( int.parse(Funcoes.converterCorStringColor("#FFFFFF") ) );
  var listaCores ;

  @override
  void initState() {
    _start();
    super.initState();
  }

  _start() async {
    _config = await _config.fetchByChave('debug');
    if( _config.valor.toString().toLowerCase() == "true"){
      _emailController.text = "teste@gmail.com";
      _senhaController.text = "1234";
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
          backgroundColor: _colorContainerFundo,
          elevation: 0,
          actions: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
              child: InkWell(
                onTap: (){ Navigator.push( context , MaterialPageRoute( builder: (context) => ConfiguracoesTela() ) ); },
                child: Icon( MdiIcons.applicationCog , 
                  color: Theme.of(context).primaryColor,
                  size: MediaQuery.of(context).textScaleFactor * 30,
                ) ,
              ),
            ),
          ],
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
                obscureText: _flagExibirSenha,                  
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
                      _modalMensagens.add("ERRO !!!");
                      if( _validar ) {
                        await Funcoes.modalExibir(context, _modalMensagens ,0);
                        return ;                          
                      }

                      _bloquearTela( true );
                      var retorno = await _autenticacaoEmailAndSenha();
                      _bloquearTela( false );

                      print("RETORNO");
                      print(retorno);

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
                      
                      //CHEGOU AO FIM == SUCESSO !!!
                      Navigator.pushReplacement( context,  MaterialPageRoute( builder: (context) => TabsTela() ) );
                    },
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 40,
                    // alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: true,
                          child: FlatButton(
                            child: LabelOpensans("Entrar sem Login", cor: _colorLetra, ),
                            onPressed: (){
                              Navigator.push(context , MaterialPageRoute(builder: (context)=>TabsTela()));
                            },
                          ),
                        ),
                        FlatButton(
                          child: LabelOpensans("Criar Senha", cor: _colorLetra, ),
                          onPressed: (){
                            Navigator.push(context , MaterialPageRoute(builder: (context)=>SplashTela()));
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      child: LabelOpensans("Recuperar Senha" , cor: _colorLetra, ),
                      onPressed: (){
                        Navigator.push(context , MaterialPageRoute(builder: (context)=>SplashTela()));
                      },
                    ),
                  ),
                
                ],
              ),
              SizedBox(height: 20,),
              //BOTAO GOOGLE
              botaoLogarMidiaSocial("Logar com Google", Colors.blue,"assets/images/logo_google.png" ),
              SizedBox(height: 20,),
              botaoLogarMidiaSocial("Logar com Facebok", Colors.indigo,"assets/images/logo_facebook.png" ),
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
              ],
            ),
          )
        ),
      );
    }
    return _body;
  }

  botaoLogarMidiaSocial(String texto , Color cor, String imagem){
    return Container(
      height: 60,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.all( Radius.circular(5)),
      ),
      child: SizedBox.expand(
        child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text( texto , style: TextStyle(
                fontWeight: FontWeight.bold,
                color:Colors.white,
                fontSize: 20,
              ), textAlign:  TextAlign.left,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all( Radius.circular(5)),
                ),
                child: SizedBox(
                  child: Image.asset(imagem.toString()),
                  height: 50,
                  width: 50,
                ),
              )
            ],
          ),
          onPressed: ()=>{},
        ),
      ),
    );
  }
  
  _autenticacaoSalvar( dados ) async {
    bool flagErro = true;
    try{
      await _autenticacaoSalvarDatabase(dados);
    }catch(e){
      print("ERRO DATABASE: ${e.toString()}");      
      flagErro = false;
    }

    try{
      await _autenticacaoSalvarMemoria( dados );
    }catch(e){
      print("ERRO MEMORIA: ${e.toString()}");
      flagErro = false;
    }
    return flagErro;

  }

  _autenticacaoSalvarMemoria( dados ) async {
    try{
      _shared = await SharedPreferences.getInstance();
      _shared.setInt('id',dados['id']);
      _shared.setString('usuario', dados['email'].toString().split("@")[0]);
      _shared.setString('nome', dados['nome']);
      _shared.setString('email', dados['email']);
      _shared.setString('assinatura', dados['assinatura']);
      _shared.setString('token', dados['token']);
      return true;
    }catch(e){
      print("ERRO SALVAR MEMORIA: ${e}");
      return false;
    }
  }

  _autenticacaoSalvarDatabase( dados ) async {
    _auth.id = dados['id'];
    _auth.usuario = dados['email'].toString().split("@")[0];
    _auth.nome = dados['nome'];
    _auth.email = dados['email'];
    _auth.token = dados['assinatura'];
    _auth.datalogin = DateTime.now();
    
    try{
      await _auth.create();
      return true;
    }catch(e){
      print("ERRO SALVAR DATABASE: ${e.toString()}");      
      return false;
    }
  }

  _autenticacaoEmailAndSenha() async {
    var _host = (await ConfiguracaoModel.buscarConstantesAmbiente)['host_auth'].toString();
    var _servico = (await ConfiguracaoModel.buscarConstantesRest)['auth_loging'].toString();

    try{
      return await _auth.authLogin( 
        { 
          "user_name" : _emailController.text.toString().trim(), 
          "user_pass" : _senhaController.text.toString().trim(), 
        }, 
        "${_host+_servico}"
      );
    }catch(e){
      return null;
    }
  }

  get _validar{

    bool flagErro = false;
    if(_emailController.text.toString().trim().length == 0){
      setState(() { _emailFlagErro = true; });
      flagErro = true;
    }

    if(_senhaController.text.toString().trim().length == 0){
      setState(() { _senhaFlagErro = true; });
      flagErro = true;
    }
    
    return flagErro;    
  }

  _bloquearTela( bool flag){ setState(() { _flagRequisicao = flag; }); }
}