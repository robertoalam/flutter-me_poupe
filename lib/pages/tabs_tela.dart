import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/componentes/drawer_widget.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/pages/lancamento/lancamento_tab_tela.dart';
import 'package:me_poupe/pages/tabs/tab_inicio_tela.dart';
import 'package:me_poupe/pages/tabs/tab_lancamento_lista_tela.dart';

import 'configuracoes/configuracoes_tela.dart';


class TabsTela extends StatefulWidget {

  @override
  _TabsTelaState createState() => _TabsTelaState();
}

class _TabsTelaState extends State<TabsTela> {

  DrawerWidget _drawerWidget = new DrawerWidget();

  bool _flagExibirSaldo = false;
  IconData _iconeExibirSaldo = Icons.visibility;

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    TabInicioTela(),
    Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
    TabLancamentoListaTela(),
  ];

  void _onItemTapped(int index) {
    // SE FOR DIFERENTE DO ICONE DO MEIO QUE ESTA OCULTO ,
    // INCLUE NO FRAME
    if(index != 1){
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  _clicFlagMostrarSaldo() async {
    _flagExibirSaldo = !_flagExibirSaldo;
    if(_flagExibirSaldo){
      _iconeExibirSaldo = Icons.visibility;
      // _saldoGeral = _balancete.diferenca.toStringAsFixed(2);
    }else{
      _iconeExibirSaldo = Icons.visibility_off;
      String regex = "[^\W_]";
      // _saldoGeral = _balancete.diferenca.toStringAsFixed(2).replaceAll(RegExp(regex),"-");
    }
    await ConfiguracaoModel.alterarExibirSaldo( _flagExibirSaldo );
    setState(() {
      _iconeExibirSaldo;
      // _saldoGeral;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: ( ) {
              _clicFlagMostrarSaldo();
            },
            child: Icon( _iconeExibirSaldo, size: 45,color: Colors.black ) ,
          ),
          SizedBox(width:5),
        ],
      ),
      drawer: _drawerWidget,
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
          BottomNavigationBarItem( icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem( icon: Icon(Icons.arrow_drop_down), title: Text('') ,),
          BottomNavigationBarItem( icon: Icon(Icons.list), title: Text('Lanç.'), ),
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
