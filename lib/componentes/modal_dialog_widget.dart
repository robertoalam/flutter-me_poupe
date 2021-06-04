import 'package:flutter/material.dart';

class ModalDialogWidget extends StatelessWidget {

  final BuildContext context;
  final String titulo;
  final String mensagem;
  final void Function(bool) onSubmit;
  final IconData icone;
  final Color iconeColor;
  final Color iconeBackground;
  final Color botaoTexto;
  final Color botaoTextoColor;
  final Color botaoColor;
  final bool exibirBotaoCancelar;

  ModalDialogWidget(
    this.context,
    this.titulo,
    this.onSubmit,
    {
      this.mensagem,
      this.icone,
      this.iconeColor,
      this.iconeBackground,
      this.botaoTexto,
      this.botaoTextoColor,
      this.botaoColor ,
      this.exibirBotaoCancelar
    }
  );

  @override
  Widget build(BuildContext context) {

    // VARIAVEIS
      // ICONE
    IconData icone = (this.icone != null)? this.icone : Icons.check;
    Color iconeColor = (this.iconeColor != null) ? Colors.white : this.iconeColor;
    Color iconeBackground = (this.iconeBackground != null) ? Theme.of(context).primaryColor : this.iconeBackground;

      // MENSAGEM
    String mensagem = (this.mensagem != null)? this.mensagem.toString() : '';

      // BOTOES
    String botaoTexto = (this.botaoTexto == null)? "OK":this.botaoTexto;
    Color botaoTextoColor = (this.botaoTextoColor != null)?this.botaoTextoColor: Colors.white;
    bool botaoCancelar = (this.exibirBotaoCancelar != null) ? this.exibirBotaoCancelar : false;
    Color botaoColor = (this.botaoColor !=null)?this.botaoColor:Theme.of(context).primaryColor;


      // ALTURA DO MODAL
    double alturaModal = (this.mensagem != null)? .40 : .30 ;


    // CONSTANTES
    double modalPadding = 20;
    double modalAvatarRadius = 45;

    return Scaffold(
      backgroundColor: Colors.black12,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: modalPadding,
                      top: modalAvatarRadius + modalPadding,
                      right: modalPadding,
                      bottom: modalPadding,
                  ),
                  margin: EdgeInsets.only(top: modalAvatarRadius),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(0,10),
                            blurRadius: 10
                        ),
                      ]
                  ),
                  width: MediaQuery.of(context).size.width * .8,
                  height: MediaQuery.of(context).size.height * alturaModal,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        titulo,
                        style:TextStyle(
                          fontWeight: FontWeight.bold ,
                          fontSize: 30 ,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Visibility(
                        visible: (mensagem.length >0)?true:false,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            mensagem.toString(),
                            style: TextStyle(
                              fontStyle: FontStyle.italic ,
                              fontWeight: FontWeight.bold ,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: botaoCancelar,
                              child: RaisedButton(
                                onPressed: (){ Navigator.pop(context); },
                                color: Colors.transparent,
                                child: Text(
                                  "cancelar",
                                  style: TextStyle(
                                    color: botaoColor
                                  ),
                                ),
                              ),
                            ),
                            SizedBox( width: 20 ,),
                            RaisedButton(
                              onPressed: (){
                                // SE HOUVER FUNCAO RETORNAVEL , APLICA
                                // if(this.onSubmit != null){ this.onSubmit(true); }

                                // VOLTAR A TELA ANTERIOR
                                Navigator.pop(context);
                              },
                              color: botaoColor,
                              child: Text(
                                botaoTexto.toString() ,
                                style: TextStyle(
                                    color: botaoTextoColor
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: modalPadding ,
                  right: modalPadding,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: modalAvatarRadius ,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                          Radius.circular( modalAvatarRadius )
                      ),
                      child:  Icon(
                        icone ,
                        size: 45,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
