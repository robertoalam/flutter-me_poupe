import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/pages/lancamento/lancamento_tab_tela.dart';
import 'package:me_poupe/pages/tabs/tab_inicio_tela.dart';
import 'package:me_poupe/pages/tabs/tab_lancamento_lista_tela.dart';


class TabsTela extends StatefulWidget {

  @override
  _TabsTelaState createState() => _TabsTelaState();
}

class _TabsTelaState extends State<TabsTela> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    TabInicioTela(),
    Text( 'Noticias', style: optionStyle,),
    Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
    Text( 'Carteira', style: optionStyle,),
    TabLancamentoListaTela(),
  ];

  void _onItemTapped(int index) {
    // SE FOR DIFERENTE DO ICONE DO MEIO QUE ESTA OCULTO ,
    // INCLUE NO FRAME
    if(index != 2){
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(MdiIcons.rocketLaunch),
        onPressed: (){
          Navigator.push( context , MaterialPageRoute( builder: (context) => LancamentoTabTela() ) );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(

        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem( icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem( icon: Icon(MdiIcons.newspaperVariant ), label: 'Notícias' ,),
          BottomNavigationBarItem( icon: Icon(Icons.arrow_drop_down), label: '' ,),
          BottomNavigationBarItem( icon: Icon(Icons.monetization_on_outlined), label: 'Carteira', ),
          BottomNavigationBarItem( icon: Icon(Icons.list), label: 'Lanç.', ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        unselectedLabelStyle: TextStyle(color: Colors.purple),
        onTap: _onItemTapped,
      ),
    );
  }
}
