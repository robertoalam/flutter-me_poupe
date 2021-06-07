import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/pages/tabs/tab_inicio_tela.dart';

import 'label_opensans.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

  List _lista = [
    {'icone':Icons.home ,'label':'Home','rota':TabInicioTela()},
    {'icone':MdiIcons.newspaperVariant,'label':'Notícias','rota':TabInicioTela()},
    {'icone':Icons.home ,'label':'Faturas','rota':TabInicioTela()},
    {'icone':Icons.home ,'label':'Relatórios','rota':TabInicioTela()},
    {'icone':Icons.home ,'label':'Carteira','rota':TabInicioTela()},
    {'icone':Icons.help ,'label':'Suporte','rota':TabInicioTela()},
  ];

  @override
  Widget build(BuildContext context) {

    _item(BuildContext context , objeto){
      return ListTile(
        title: Column(
          children: [
            Row(
              children: [
                Icon( objeto['icone'] ),
                SizedBox(width: 10,),
                Text(objeto['label'] , style:
                TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.pop(context);
        },
      );
    }

    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 90,
            child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purple,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        LabelOpensans("Bom Dia," , cor: Colors.black, tamanho: 15 ,bold: true,),
                        LabelOpensans("Roberto !" , cor: Colors.black, tamanho: 20 ,bold: true,),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LabelOpensans("Sair" , cor: Colors.black, tamanho: 15 ,bold: true,),
                        Icon(Icons.logout),
                      ],
                    ),
                  ],
                )
            ),
          ),
          for(var item in _lista) _item(context, item),
        ],
      ),
    );
  }
}

