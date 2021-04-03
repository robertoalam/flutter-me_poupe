import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';
import 'package:me_poupe/model/bloc_model.dart';
import 'package:me_poupe/model/cad/cad_categoria_model.dart';
import 'package:me_poupe/model/cad/cad_frequencia_periodo_model.dart';
import 'package:me_poupe/model/cartao_model.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/pages/lancamento/lancamento_despesa_tela.dart';
import 'package:me_poupe/pages/lancamento/lancamento_receita_tela.dart';

class LancamentoTabTela extends StatefulWidget {
  @override
  _LancamentoTabTelaState createState() => _LancamentoTabTelaState();
}

class _LancamentoTabTelaState extends State<LancamentoTabTela>  with SingleTickerProviderStateMixin {
  var body;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  MeuBlocModel bloc = MeuBlocModel();
  TabController _tabController ;
  int _currentIndex = 0;
  String corTopo = Funcoes.converterCorStringColor("#FF0000");
  var _dados = null;
  CategoriaCadModel categoria = new CategoriaCadModel();
  List<CategoriaCadModel> listaCategoria = new List<CategoriaCadModel>();
  CartaoModel _cartao = new CartaoModel();
  List<CartaoModel> _listaCartao = new List<CartaoModel>();

  FrequenciaPeriodoCadModel _frequenciaPeriodo = new FrequenciaPeriodoCadModel();
  List<FrequenciaPeriodoCadModel> _frequenciaPeriodoLista = new List<FrequenciaPeriodoCadModel>();


  @override
  void initState() {
    super.initState();
    setState(() {
      _frequenciaPeriodoLista = null;
    });
    buscarDados();
  }

  buscarDados() async {
    await buscarDadosConfiguracao();
    await buscarCategoriaDespesa();
    await buscarListaCartoes();
    await buscarLancamentoFrequenciaPeriodo();

    montarTela();
  }

  montarTela() async {
    await atualizarDadosConfiguracao();
    _tabController = TabController( vsync: this , length: 2);
    _tabController.addListener(_handleTabSelection);

    //alterarCorTopo("0");
    definirCorTopo();
  }
  atualizarDadosConfiguracao(){
    setState(() {
      _dados;
    });
  }

  buscarDadosConfiguracao() async {
    _dados = await ConfiguracaoModel.getConfiguracoes().then( (list) {
      return list;
    });
    return _dados;
  }

  buscarCategoriaDespesa() async {
    listaCategoria = await categoria.fetchByAll();
    setState(() {
      listaCategoria;
    });
  }
  buscarListaCartoes() async {
    _listaCartao = await _cartao.fetchByAll();
    setState(() {
      _listaCartao;
    });
  }

  buscarLancamentoFrequenciaPeriodo() async {
    _frequenciaPeriodoLista = await _frequenciaPeriodo.fetchByDestaque(1);
    setState(() {
      _frequenciaPeriodoLista;
    });
  }

  @override
  Widget build(BuildContext context) {

    if( _dados != null && _frequenciaPeriodoLista != null ){

      body = TabBarView(
        controller: _tabController,
        children: [
          LancamentoDespesaTela( _listaCartao , _frequenciaPeriodoLista ),
          LancamentoReceitaTela(),
        ],
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            actions: [
              GestureDetector(
                  onTap: (){},
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: Icon(Icons.list , ),
                  )
              )

            ],
            shadowColor: Colors.transparent,
            backgroundColor: Color(int.parse(corTopo)),
            title: Text("Lançamento ${_currentIndex}"),
            bottom: TabBar(
              labelPadding: EdgeInsets.fromLTRB(0, 4, 0, 4),
              indicatorColor: Colors.black,
              indicatorWeight: 9.0,
              indicator: CircleTabIndicator(color: Colors.white , radius: 3),
              controller: _tabController,

              onTap: (value) {
                // bloc.setPagina(value);
                // alterarCorTopo(value.toString());
                _handleTabSelection();
              },
              tabs: [
                Text("Despesa"),
                Text("Receita"),
              ],
            ),
          ),
          body: body
      ),
    );
  }

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
    definirCorTopo();
  }

  definirCorTopo(){
    if(_dados != null) {
      if (_dados['modo'] == "normal") {
        //GAMBIARRA
        corTopo = (_currentIndex == 0) ? Funcoes.converterCorStringColor("#FF5C4A"): Funcoes.converterCorStringColor("#4CAF50");
      } else {
        corTopo = (_currentIndex == 0) ? Funcoes.converterCorStringColor("#7A0004") : Funcoes.converterCorStringColor("#00640E");
      }
    }
    setState(() {
      corTopo;
    });
  }

}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius - 5);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}


//
// class LancamentoTab extends StatefulWidget {
//
//   @override
//   _LancamentoTabState createState() => _LancamentoTabState();
// }
//
// class _LancamentoTabState extends State<LancamentoTab> with SingleTickerProviderStateMixin{
//
// }