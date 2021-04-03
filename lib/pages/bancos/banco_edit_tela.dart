import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/helper/configuracoes_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/cad/cad_banco_model.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/conta/conta_tipo_model.dart';

class BancoEditTela extends StatefulWidget {
    
    final BancoCadModel banco;
    BancoEditTela({this.banco});

    @override
    _BancoEditTelaState createState() => _BancoEditTelaState();
}

class _BancoEditTelaState extends State<BancoEditTela> {

    final _formKey = GlobalKey<FormState>();
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    // CORES TELA
    String _background = Funcoes.converterCorStringColor("#FFFFFF");
    String _colorAppBar = Funcoes.converterCorStringColor("#FFFFFF");
    String _colorContainerFundo = Funcoes.converterCorStringColor("#FFFFFF");
    String _colorContainerBorda = Funcoes.converterCorStringColor("#FFFFFF");
    String _colorFundo = Funcoes.converterCorStringColor("#FFFFFF");
    String _colorLetra = Funcoes.converterCorStringColor("#FFFFFF");

    // VARIAVEIS
    Widget _body;
    var _dados = null;
    BancoCadModel _banco = null;
    ContaBancariaTipoModel _contaTipo = new ContaBancariaTipoModel();
    List<ContaBancariaTipoModel> _contaTipoLista = new List<ContaBancariaTipoModel>();


    @override
    void initState() {
        super.initState();
        _start();
    }

    _start() async{
        _banco = widget.banco;
        await _getDataConfig();
        await _setDataConfig();
        await _getData();
    }

    _getData() async {
        _contaTipoLista = await _contaTipo.fetchByAll();
    }

    _setDataConfig() async {
        setState(() {
            _background = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['background']);
            _colorAppBar = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['corAppBar']);
            _colorContainerFundo = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['containerFundo']);
            _colorContainerBorda = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['containerBorda']);
            _colorLetra = Funcoes.converterCorStringColor(Configuracoes.cores[_dados['modo']]['textoPrimaria']);
        });
    }

    _getDataConfig() async {
        _dados = await ConfiguracaoModel.getConfiguracoes().then((list) {
            return list;
        });
        return;
    }

    @override
    Widget build(BuildContext context) {

        if( _contaTipoLista == null){
            _body = Center(
                child: CircularProgressIndicator(),
            );
        }else{
            _body = ListView(
                children: [
                    // BANCO
                    Row(
                        children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                child: Icon(MdiIcons.bank , color: Color(int.parse( _colorFundo) ) ),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(50) ,
                                ),
                            ),
                            SizedBox( width: 10,),
                            Text('Banco', style: TextStyle(
                                    fontSize: 22 , color: Color(int.parse( _colorLetra) ) ,
                                    fontWeight: FontWeight.bold,
                                ),
                            ),
                        ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                        decoration: BoxDecoration(
                            border: Border.all( width: 2, color: Color(int.parse( _colorLetra) ) ),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text("${_banco.descricao}" ,style: TextStyle(
                                color: Color( int.parse( _colorLetra) ),
                                fontSize: 18,
                                fontFamily: "Quicksand"
                            ),
                        ),
                    ),
                    SizedBox(height: 20,),
                    Divider( color: Color(int.parse( _colorLetra ) ) ),

                    // DESCRICAO
                    SizedBox(height: 20,),
                    Row(
                        children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                child: Icon(Icons.edit , color: Color(int.parse( _colorFundo) ) ),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(50) ,
                                ),
                            ),
                            SizedBox( width: 10,),
                            Text('Descrição', style: TextStyle(
                                    fontSize: 22 , color: Color(int.parse( _colorLetra) ) ,
                                    fontWeight: FontWeight.bold,
                                ),
                            ),
                        ],
                    ),
                    SizedBox(height: 10,),
                    TextField(
                        enabled: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(int.parse( _colorContainerFundo ) ),
                            hintText: 'Descrição',
                            hintStyle: TextStyle( 
                                color: Colors.grey,fontFamily: "Quicksand", 
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(width: 2,color:  Color(int.parse( _colorLetra) ) ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(width: 2,color: Color(int.parse( _colorLetra) ) ),
                            ),
                        ),
                    ),
                    SizedBox(height: 20,),
                    Divider( color: Color(int.parse( _colorLetra ) ) ),

                    // TIPO CONTA
                    SizedBox(height: 20,),
                    Row(
                        children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                child: Icon( FontAwesomeIcons.piggyBank , color: Color(int.parse( _colorFundo) ) ),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(50) ,
                                ),
                            ),
                            SizedBox( width: 10,),
                            Text('Tipo de Conta', style: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontSize: 22 , color: Color(int.parse( _colorLetra) ) ,
                                    fontWeight: FontWeight.bold,
                                ),
                            ),
                        ],
                    ),
                ],
            );
        }

        return Scaffold(
            appBar: AppBar(
                title: Text('Banco'),
                backgroundColor: Color(int.parse(_colorAppBar) ),
            ),    
            body: SafeArea(
                child: SingleChildScrollView(
                    child: Container(
                        color: Color( int.parse(_colorContainerFundo ) ),
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: _body,
                    )
                ),
            ),
        );
    }
}
