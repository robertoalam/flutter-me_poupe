import 'package:flutter/material.dart';
import 'package:me_poupe/pages/splash_tela.dart';

class LoginTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
			SizedBox(
              height: 20,
            ),
			Container(
				height: 60,
				alignment: Alignment.centerLeft,
				decoration: BoxDecoration(
					gradient: LinearGradient(
						begin: Alignment.topLeft,
						end: Alignment.bottomRight,

						// stops: [0.2,1],
						// colors: [Color(0XFFF58524),Color(0XFFF92B7F)],
					),
					borderRadius: BorderRadius.all( Radius.circular(5)),
				),
				child: SizedBox.expand(
					child: FlatButton(
						child: Text("LOGAR",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
						onPressed: ()=>{},
					),
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
			SizedBox(
              height: 40,
            ),
			Container(
				height: 60,
				alignment: Alignment.centerLeft,
				decoration: BoxDecoration(
					color: Colors.blue,
					borderRadius: BorderRadius.all( Radius.circular(5)),
				),
				child: SizedBox.expand(
					child: FlatButton(
						child: Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Text("Logar com Google", style: TextStyle(
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
										child: Image.asset("assets/images/logo_google.png"),
										height: 50,
										width: 50,
									),
								)
							],
						),
						onPressed: ()=>{},
					),
				),
			),

			// FACEBOOK
						SizedBox(
              height: 40,
            ),
			Container(
				height: 60,
				alignment: Alignment.centerLeft,
				decoration: BoxDecoration(
					color: Colors.indigo,
					borderRadius: BorderRadius.all( Radius.circular(5)),
				),
				child: SizedBox.expand(
					child: FlatButton(
						child: Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Text("Logar com Facebook", style: TextStyle(
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
										child: Image.asset("assets/images/logo_facebook.png"),
										height: 50,
										width: 50,
									),
								)
							],
						),
						onPressed: ()=>{},
					),
				),
			),
          ],
        ),
      ),
    );
  }
}
