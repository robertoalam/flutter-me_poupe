import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_poupe/helper/configuracoes_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/cad/cad_banco_model.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
// import 'package:me_poupe/model/configuracoes/icone_cad_model.dart';
import 'package:me_poupe/model/conta/conta_model.dart';
import 'package:me_poupe/model/conta/conta_tipo_model.dart';

class BancoEditTela extends StatefulWidget {
    
    final BancoCadModel banco;
    BancoEditTela({this.banco});

    @override
    _BancoEditTelaState createState() => _BancoEditTelaState();
}

class _BancoEditTelaState extends State<BancoEditTela> {

    // final _formKey = GlobalKey<FormState>();
    // final _scaffoldKey = GlobalKey<ScaffoldState>();

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
    
    // VALIDACAO
    bool _flag;
    List<bool> _listaFlag = [];


    BancoCadModel _banco = null;
    ContaModel _conta = new ContaModel();
      // TIPO DE CONTA
    ContaBancariaTipoModel _contaTipo = new ContaBancariaTipoModel();
    List<ContaBancariaTipoModel> _contaTipoLista = new List<ContaBancariaTipoModel>();
    String _contaTipoDescricaoSelecionada = "Clique aqui";
    bool _contaTipoValidate = false;

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
                    SizedBox(height: 10,),
                    InkWell(
                        onTap: () async { 
                            var retorno = await _cortinaTipoConta( context );
                            if(retorno != null){
                                _setarTipoConta(retorno);
                            }                                
                        },
                        child:  Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                            decoration: BoxDecoration(
                                border: Border.all( width: 2, color: Color(int.parse( _colorLetra) ) ),
                                borderRadius: BorderRadius.circular(10)
                            ),                                
                            child: Text("${_contaTipoDescricaoSelecionada}" ,style: TextStyle(
                                    color: Color( int.parse( _colorLetra) ),
                                    fontSize: 18,
                                    fontFamily: "Quicksand"
                                ),           
                            ),
                        ),
                    ),
                    Visibility(
                        visible: _contaTipoValidate,
                        child: Text("Campo obrigatório")
                    ),
                ],
            );
        }

        return Scaffold(
            appBar: AppBar(
                title: Text('Banco'),
                backgroundColor: Color(int.parse(_colorAppBar) ),
            ),    
            floatingActionButton: FloatingActionButton(
                onPressed: (){
                    if(_validarForm() ){
                        _salvar();
                    }else{
                        print('ERRO NA TELA');
                    }
                },

                backgroundColor: Color(int.parse( _colorAppBar) ),
                child: Icon(Icons.save , color: Colors.black, size: 32,),
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

    _validarForm(){
        print("ENTROU 1");
        _flag = _validarTipoConta();
        _listaFlag.add(_flag);

        return (_listaFlag.contains(true))? true : false;
    }

    _validarTipoConta(){
        if( _conta.tipo == null ) {
            _contaTipoValidate = true;
            print("CHEGOU ${_contaTipoValidate}");
            setState(() { _contaTipoValidate; });
            return false;
        }

        return true;
    }

    _salvar(){
        _conta.save();
    }
    _setarTipoConta(ContaBancariaTipoModel objeto){
        if(objeto != null){
            _contaTipoDescricaoSelecionada = objeto.descricao;
            _conta.tipo = objeto;
        }else{
            // SETAR O PADRAO
            _conta.tipo = null;
        }

        setState(() { _contaTipoDescricaoSelecionada; });

    }
 
    _cortinaTipoConta(BuildContext context){
        return  showModalBottomSheet(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            context: context,
            builder: (BuildContext context) {
                return Container(
                    // height: MediaQuery.of(context).size.height * .4,
                    decoration: BoxDecoration(
                        color: (_dados['modo'] == "normal")? Colors.white:Colors.grey,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                        ),
                    ),
                    child: ListView(
                        children: [
                            for(ContaBancariaTipoModel objeto in _contaTipoLista) InkWell(
                                onTap: (){ Navigator.pop(context , objeto); },
                                child: Column(
                                    children: [
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(5, 15, 0, 15),
                                            child: Text("${objeto.descricao}",style: TextStyle(color: Color(int.parse( _colorAppBar)), fontSize: 20.0) ),
                                        ),
                                        Visibility(
                                            visible: (objeto.id != _contaTipoLista.last.id)? true:false,
                                            child: Divider( color: Color(int.parse( _colorLetra)),),
                                        )
                                    ],
                                )
                            )
                        ],
                    ),
                );
            },
        );
    }
}
