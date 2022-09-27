import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/label/label_opensans.dart';
import 'package:me_poupe/helper/api_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TesteRestTela extends StatefulWidget {
  const TesteRestTela();

  @override
  State<TesteRestTela> createState() => _TesteRestTelaState();
}

class _TesteRestTelaState extends State<TesteRestTela> {

	// CORES TELA
	var listaCores ;
	Color _colorAppBarFundo = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorBackground = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorContainerFundo = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorContainerBorda = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorFundo = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
	Color _colorLetra = Color(int.parse( Funcoes.converterCorStringColor("#FFFFFF") ) );
  
    @override
	  void initState() {
		_start();
		super.initState();
	  }
	  
	_start() async {
		await montarTela();
	}
	
	montarTela() async {
		listaCores = await ConfiguracaoModel.buscarEstilos;
		setState(() {
		  _colorAppBarFundo = Color(int.parse( Funcoes.converterCorStringColor( listaCores['corAppBarFundo'] ) ) );
		  _colorBackground = Color(int.parse( Funcoes.converterCorStringColor( listaCores['background'] ) ) );
		  _colorContainerFundo = Color(int.parse( Funcoes.converterCorStringColor( listaCores['containerFundo'] ) ) );
		  _colorContainerBorda = Color(int.parse( Funcoes.converterCorStringColor( listaCores['containerBorda'] ) ) );
		  _colorLetra = Color(int.parse( Funcoes.converterCorStringColor( listaCores['textoPrimaria'] ) ) );    
		});
		return;
	}

  @override
  Widget build(BuildContext context) {
    SharedPreferences _prefs;
    CancelToken token;

    return Scaffold(
      backgroundColor: _colorBackground,
      appBar: AppBar(
        title: Text("Teste REST"),
        backgroundColor: _colorAppBarFundo,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 15,
                  child: RaisedButton(
                    onPressed: () async { 
                      var retorno = await APIHelper.post("");
                      print("RETORNO: ${retorno}");
                    },
                    color: _colorContainerBorda,
                    child: LabelOpensans("LOGIN",cor: _colorAppBarFundo,bold: true,)
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: ( MediaQuery.of(context).size.width / 2 ) - 25,
                      child: RaisedButton(
                        onPressed: () async {
                          try {
                            Dio dio = new Dio();
                            dio.interceptors.add(InterceptorsWrapper(
                              onRequest: (RequestOptions options) async {
                              token = CancelToken();
                              options.cancelToken = token;
                              return options; //continue
                              })
                            );

                            var res = await dio.post(
                              "http://192.168.0.110/i9tecnosul.com.br/auth/api/v1/basic/logon",
                              data: {	"user_name":"robertoaa1981@gmail.com","user_pass":"8671b3HJ+11"}                              
                            );

                            print(res.data);
                          } catch (e) {
                            if (CancelToken.isCancel(e)) {
                              print('cancelled by dio');
                            } else {
                              print('error${e.toString()}');
                            }
                          }                          
                        },
                        child: Text("LOGIN"),
                      ),
                    ),
                    Container(
                      width: ( MediaQuery.of(context).size.width / 2 ) - 25,
                      child: RaisedButton(
                        onPressed: (){
                          token?.cancel('c');
                        },
                        child: Text("CANCEL"),
                      ),
                    ),                    
                  ],
                ),
                Divider(thickness: 5,color: _colorLetra,),

                Container(
                  width: MediaQuery.of(context).size.width - 15,
                  child: RaisedButton(
                    onPressed: () async { 
                      _prefs = await SharedPreferences.getInstance();
                      print( _prefs.getString("usuario"));
                      Map opcoes = new Map();
                      var configuracoes = await ConfiguracaoModel.buscarConstantesAmbiente;
                      opcoes['url'] = configuracoes['host_url'];
                      opcoes['data'] = {
                        "id":  1 , 
                        "assinatura": _prefs.getString("assinatura")
                      };

                      var retorno = await APIHelper.post(opcoes);
                      print("RETORNO: ${retorno}");
                    },
                    color: _colorContainerBorda,
                    child: LabelOpensans("BUSCAR LANCAMENTOS",cor: _colorAppBarFundo,bold: true,)
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}