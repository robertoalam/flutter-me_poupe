import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../pages/configuracoes/configuracoes_index_tela.dart';
import '../splash_tela.dart';
import '../tabs_tela.dart';

class SigninTela extends StatelessWidget {
  const SigninTela();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
            child: InkWell(
              onTap: (){ Navigator.push( context , MaterialPageRoute( builder: (context) => ConfiguracoesIndexTela() ) ); },
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
        color: Colors.white,
        child: ListView(
          children: [
            SizedBox(
              width: 128,
              height: 128,
              child: Image.asset("assets/images/porco_01.png"),
            ),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                  color:Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                )
              ),
              style: TextStyle(fontSize: 20),
            ),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(
                  color:Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                )
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20, ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                // 	begin: Alignment.topLeft,
                // 	end: Alignment.bottomRight,
                // 	stops: [0.2,1],
                // 	colors: [Color(0XFFF58524),Color(0XFFF92B7F)],
                // ),
                borderRadius: BorderRadius.all( Radius.circular(5)),
              ),
              child: SizedBox.expand(
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  child: Text("LOGAR",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                  onPressed: ()=>{},
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
                          child: Text("Entrar sem Login" ),
                          onPressed: (){
                            Navigator.push(context , MaterialPageRoute(builder: (context)=>TabsTela()));
                          },
                        ),
                      ),
                      FlatButton(
                        child: Text("Criar Senha" ),
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
                    child: Text("Recuperar Senha" ),
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
}