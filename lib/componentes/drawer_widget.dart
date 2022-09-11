import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/pages/auth/logout_screen.dart';
import 'package:me_poupe/pages/configuracoes/configuracoes_tela.dart';
import 'package:me_poupe/pages/tabs/tab_inicio_tela.dart';

import 'label/label_opensans.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

  List _listaMenu = [
    {'icone':Icons.home ,'label':'Home','rota':TabInicioTela()},
    {'icone':MdiIcons.newspaperVariant,'label':'Notícias','rota':TabInicioTela()},
    {'icone':Icons.home ,'label':'Dicas','rota':TabInicioTela()},
    {'icone':Icons.home ,'label':'Faturas','rota':TabInicioTela()},
    {'icone':Icons.home ,'label':'Relatórios','rota':TabInicioTela()},
    {'icone':Icons.home ,'label':'Metas','rota':TabInicioTela()},
    {'icone':Icons.home ,'label':'Desafio','rota':TabInicioTela()},
    {'icone':Icons.home ,'label':'Carteira','rota':TabInicioTela()},
    // {'icone':Icons.help ,'label':'Suporte','rota':TabInicioTela()},
    // {'icone':MdiIcons.file ,'label':'Termos e políticas','rota':TabInicioTela()},
  ];

  List _listaRedeSociais = [
    {'icone':MdiIcons.facebook ,'rota':TabInicioTela()},
    {'icone':MdiIcons.instagram ,'rota':TabInicioTela()},
    {'icone':MdiIcons.twitter ,'rota':TabInicioTela()},
    {'icone':MdiIcons.youtube ,'rota':TabInicioTela()},
  ];

  @override
  Widget build(BuildContext context) {

    _thumbRedeSociais(BuildContext context , objeto){
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon( objeto['icone'] ),
      );
    }

    _thumbMenu(BuildContext context , objeto){
      return ListTile(
        title: Column(
          children: [
            Row(
              children: [
                Icon( objeto['icone'] ),
                SizedBox(width: 10,),
                Text(objeto['label'] , style:
                  TextStyle( fontWeight: FontWeight.bold, ),
                ),
              ],
            ),
          ],
        ),
        onTap: () { Navigator.pop(context); },
      );
    }

    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 125,
            child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purple,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0 ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: (){ Navigator.push( context , MaterialPageRoute( builder: (context) => ConfiguracoesTela() ) ); },
                              child: Icon( MdiIcons.applicationCog , size: 33, ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        LabelOpensans("Bom Dia," , cor: Colors.black, tamanho: 15 ,bold: true,),
                        LabelOpensans("Roberto !" , cor: Colors.black, tamanho: 20 ,bold: true,),
                      ],
                    ),
                    InkWell(
                      onTap: ()=> Navigator.push(context, MaterialPageRoute( builder: (context) => LogoutTela() ) ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LabelOpensans("Sair" , cor: Colors.black, tamanho: 15 ,bold: true,),
                          Icon(Icons.home),
                        ],
                      ),
                    ),
                    
                  ],
                )
            ),
          ),
          for(var item in _listaMenu) _thumbMenu(context, item),
          Divider(color:Colors.grey),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: LabelOpensans("Redes Sociais",bold: true,),
          ),
          SizedBox(height: 10,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for(var item in _listaRedeSociais) _thumbRedeSociais(context, item),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Divider(color:Colors.grey),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .15,
                child: Image.asset("assets/images/porco_02.png",scale: .1,),
              ),
              Text(" | "),
              LabelOpensans("Versão: 0.0.1.beta",bold: true,),
            ],
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}

