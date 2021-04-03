import 'package:flutter/material.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/cad/cad_banco_model.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/pages/cartao/cartao_edit_tela.dart';
import 'package:me_poupe/pages/cartao/cartao_list_tela.dart';

class CartaoIndexTela extends StatefulWidget {
  @override
  _CartaoIndexTelaState createState() => _CartaoIndexTelaState();
}

class _CartaoIndexTelaState extends State<CartaoIndexTela> {

  BancoCadModel _banco = new BancoCadModel();
  List<BancoCadModel> _lista = new List<BancoCadModel>();

  @override
  void initState() {
    super.initState();
    buscarDadosConfiguracao();
    buscarDados();
  }

  buscarDados() async {
    _lista = await _banco.fetchByDestaque(1);
    setState(() {
      _lista;
    });
  }

  buscarDadosConfiguracao() async {
    var dados = await ConfiguracaoModel.getConfiguracoes().then( (list) {
      return list;
    });
    print('DADOS');
    print(dados);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text("Escolha a instituição financeira",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                ),

              Expanded(
                flex: 10,
                child: GridView.count(
                    crossAxisCount:3,
                    children: List.generate( _lista.length , (index) {
                      return thumbGrid( _lista[index] );
                    })
                ),
              ),

            ],
          ),
      ),
    );
  }
  
  thumbGrid(BancoCadModel objeto){
    String color;
    if (objeto.corPrimaria != null && objeto.corPrimaria == "#FFFFFF"){
      color = Funcoes.converterCorStringColor( objeto.corSecundaria ) ;
    }else if( objeto.corSecundaria != null && objeto.corSecundaria == "#FFFFFF" ){
      color = Funcoes.converterCorStringColor( objeto.corTerciaria );
    }else if( objeto.corTerciaria != null && objeto.corTerciaria == "#FFFFFF" ){
      color = Funcoes.converterCorStringColor( "#EEEEEE" );
    }else{
      color = Funcoes.converterCorStringColor( "#C1C1C1" );
    }
    // color = (objeto.corTerciaria != null )? Funcoes.converterCorStringColor( objeto.corTerciaria ) :  Funcoes.converterCorStringColor( "#FFFFFF" );
    color = Funcoes.converterCorStringColor( objeto.corCartao ) ;
    String imagem = "assets/images/bancos/logo/${objeto.id.toString()}.png";

    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: CircleAvatar(
          backgroundColor:  Color(int.parse(color)),
          radius: 30,
          child: SizedBox(
            height: 50, width: 50,
            child: Image.asset(objeto.imageAsset),
          ),
        ),
      ),
      onTap: (){ _navegar(objeto); },
    );
  }

  _navegar(BancoCadModel objeto){
    // SE FOR OUTROS
    if(objeto.id == 54){
      Navigator.push( context , MaterialPageRoute( builder: (context) => CartaoListTela() ) );
    }else{
      Navigator.push( context , MaterialPageRoute( builder: (context) => CartaoEditTela(bancoModel: objeto,) ) );

    }

  }
}
