import 'package:flutter/material.dart';
import 'package:me_poupe/componentes/label_opensans.dart';
import 'package:me_poupe/componentes/label_quicksand.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/conta/cartao_model.dart';

class LancamentoModalCartao extends StatefulWidget {

  List<CartaoModel> lista;
  LancamentoModalCartao(this.lista);

  @override
  _LancamentoModalCartaoState createState() => _LancamentoModalCartaoState();
}

class _LancamentoModalCartaoState extends State<LancamentoModalCartao> {

  List<CartaoModel> lista = new List<CartaoModel>();
  double modalAltura = .6;

  @override
  void initState() {
    montarTela();
  }

  montarTela(){
    lista = widget.lista;
    if(lista.length < 3){
      modalAltura = .3;
    }else if(lista.length < 5){
      modalAltura = .5;
    }else {
      modalAltura = .6;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width * .8,
          height: MediaQuery.of(context).size.height * modalAltura,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  Navigator.pop(context , lista[index]);
                },
                child:  thumb( lista[index] ),
              );
            },
          ),
        ),
      ),
    );
  }

  thumb(CartaoModel objeto){
    // 20210524
    return Card(
      color: Color(int.parse( Funcoes.converterCorStringColor("#CCCCCC") ) ),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 1, 2, 1),
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: Color(int.parse( (objeto.conta.banco.corSecundaria != null ) ? Funcoes.converterCorStringColor( objeto.conta.banco.corSecundaria ) :  Funcoes.converterCorStringColor( "#FFFFFF" ) ) ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Image.asset(objeto.conta.banco.imageAsset),
              )
          ),
          title: LabelOpensans("${objeto.conta.banco.descricao}"),
          subtitle: LabelQuicksand("${objeto.tipo.descricao}"),
        ),
      ),
    );
  }
}
