import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/label_opensans.dart';
import 'package:me_poupe/componentes/label_quicksand.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/pages/configuracoes/icones_list_tela.dart';

class TesteTela extends StatefulWidget {
  const TesteTela();

  @override
  State<TesteTela> createState() => _TesteTelaState();
}

class _TesteTelaState extends State<TesteTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              child: ListTile(
                onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => IconeListTela())); },
                leading: CircleAvatar(
                  backgroundColor: Color(int.parse(_colorLetra)),
                  child: Icon( Icons.format_paint, color: Color(int.parse(_background)), ),
                ),
                title: LabelOpensans( "Icones", bold: true, cor: Color(int.parse(_colorLetra)), ),
                subtitle: LabelQuicksand( "Lista de Icones", cor: Color(int.parse(_colorLetra)), ),
              ),
            ),
            Divider( color: Color(int.parse(_colorLetra)), ),            
            FlatButton(
              onPressed: () async {
                String teste = await Funcoes.buscarVersao;
                print("TESTE : ${teste.toString()}");
              },
              child: Text("VERSAO"),
            ),
          ],
        ),
      ),
    );
  }
}