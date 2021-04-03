import 'package:me_poupe/helper/arquivo_helper.dart';
import 'package:me_poupe/helper/database_helper.dart';

class BalanceteModel {
	double despesa;
	double receita;
	double valor;
	double diferenca;

  	final dbHelper = DatabaseHelper.instance;

  	BalanceteModel({this.despesa, this.receita, this.valor, this.diferenca});

  	factory BalanceteModel.fromJson(Map<String, dynamic> json) {
		return BalanceteModel(
			despesa: json['vl_despesa'],
			receita: json['vl_receita'],
			diferenca: json['vl_diferenca'],
		);
  	}

  	balancoGeral({Map periodo}) async {
		String pesquisarPeriodo;
		String pesquisarMes;
		String pesquisarAno;

		if( periodo != null ){
			pesquisarMes = (periodo['mes'] != null)?? " AND lfd.dt_mes = ${periodo['mes']} " ;
			pesquisarAno = (periodo['ano'] != null)?? " AND lfd.dt_ano = ${periodo['ano']} " ;
			pesquisarPeriodo = " ${pesquisarMes.toString()} ${pesquisarAno.toString()} ";
		}else{
			pesquisarPeriodo = " AND lfd.dt_detalhe < DATETIME('NOW','localtime') ";
		}

		// String query = " SELECT SUM( lfd.vl_valor ) vl_despesa  FROM lancamento_frequencia_detalhe lfd LEFT JOIN lancamento_frequencia lf ON (lfd.id_lancamento = lf.id_lancamento AND lfd.st_chave_unica = lf.st_chave_unica) LEFT JOIN lancamento l ON (l.id = lfd.id_lancamento AND l.st_chave_unica = lfd.st_chave_unica) WHERE 1=1  AND l.id_lancamento_tipo = 1 AND dt_delete IS NULL  AND lfd.dt_detalhe < DATETIME('NOW','localtime') ";

		String query = " "+
		" SELECT *,(vl_receita-vl_despesa) as vl_diferenca FROM ( " +
		" SELECT " +
		"    SUM( lfd.vl_valor ) vl_receita " +
		"  FROM lancamento_frequencia_detalhe lfd " +
		"    LEFT JOIN lancamento_frequencia lf ON (lfd.id_lancamento = lf.id_lancamento AND lfd.st_chave_unica = lf.st_chave_unica) " +
		"    LEFT JOIN lancamento l ON (l.id = lfd.id_lancamento AND l.st_chave_unica = lfd.st_chave_unica) " +
		"  WHERE 1=1 " +
		"    AND l.id_lancamento_tipo = 2 AND dt_delete IS NULL " +
		"    ${pesquisarPeriodo.toString()} " +
		"  ) receita , (" +
		"  SELECT "
			"   SUM( lfd.vl_valor ) vl_despesa " +
		"  FROM lancamento_frequencia_detalhe lfd " +
		"    LEFT JOIN lancamento_frequencia lf ON (lfd.id_lancamento = lf.id_lancamento AND lfd.st_chave_unica = lf.st_chave_unica) " +
		"    LEFT JOIN lancamento l ON (l.id = lfd.id_lancamento AND l.st_chave_unica = lfd.st_chave_unica) " +
		"  WHERE 1=1 " +
		"    AND l.id_lancamento_tipo = 1 AND dt_delete IS NULL " +
		"    ${pesquisarPeriodo.toString()} " +
		"  ) despesa ";

		ArquivoHelper gravar = new ArquivoHelper(nomeArquivo: "teste");
		gravar.writeFile(query.toString());

		var linha;
		try{
			linha = await dbHelper.queryCustom(query);
			print("LINHA: ${linha.toString()}");
			linha = linha.isNotEmpty ? BalanceteModel.fromJson(linha.first) : null;
		}catch(e){
			linha = null;
			print("ERROR ${e}");
		}

		return linha;
	}

// balancaoMesAtual(int id) async {
//   var linha;
//   if( id !=null || id.toString() != "" ) {
//     linha = await dbHelper.query(TABLE_NAME, where: "_id = ?", whereArgs: [id]);
//     if (linha.isNotEmpty || linha != null) {
//       CartaoModel cartao = new CartaoModel();
//       return await cartao.fromDatabase(linha[0]);
//     }else{
//       return null;
//     }
//   }else{
//     return null;
//   }
}
