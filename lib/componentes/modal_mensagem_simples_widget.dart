import 'package:flutter/material.dart';

class ModalMensagemSimplesWidget extends StatelessWidget {

  final BuildContext context;
  final String mensagem;
  final String action;
  final Color background;
  final String botaoTexto;
  Color botaoCor;
  void Function(String) onSubmit;

  ModalMensagemSimplesWidget({
    this.context ,
    this.mensagem ,
    this.action,
    this.onSubmit,
    this.background,
    this.botaoTexto ,
    this.botaoCor,
  });

  @override
  Widget build(BuildContext context) {

    String botaoTexto = (this.botaoTexto == null)? "OK":this.botaoTexto;
    Color backGroundColor = (this.background ==null)? Theme.of(context).primaryColor : this.background;
    this.botaoCor = (this.botaoCor == null )? Colors.white: this.botaoCor;

    return Scaffold(
        backgroundColor: Colors.black12,
        body: Container(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: backGroundColor ,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: MediaQuery.of(this.context).size.height * .3,
                width: MediaQuery.of(this.context).size.width * .7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(''),
                    SizedBox(height: 10,),
                    Text(
                      "${this.mensagem} " ,
                      style: TextStyle(
                        fontSize: 22 ,
                        fontWeight: FontWeight.bold,
                        color: this.botaoCor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: RaisedButton(
                        color: this.botaoCor,
                        onPressed: ()=> Navigator.pop(this.context , this.action),
                        child: Text("${botaoTexto}" , style: TextStyle(
                            color: backGroundColor ,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        )
    );
  }

}
