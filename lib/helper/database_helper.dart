import 'dart:io';
import 'package:me_poupe/helper/dummy/banco_dummy.dart';
import 'package:me_poupe/helper/dummy/categoria_dummy.dart';
import 'package:me_poupe/helper/dummy/lancamento_dummy.dart';
import 'package:me_poupe/model/cad/cad_banco_model.dart';
import 'package:me_poupe/model/cad/cad_cartao_tipo_model.dart';
import 'package:me_poupe/model/cad/cad_categoria_model.dart';
import 'package:me_poupe/model/cad/cad_frequencia_model.dart';
import 'package:me_poupe/model/cad/cad_frequencia_periodo_model.dart';
import 'package:me_poupe/model/cad/cad_lancamento_tipo_model.dart';
import 'package:me_poupe/model/cad/cad_pagamento_forma.dart';
import 'package:me_poupe/model/configuracoes/configuracao_model.dart';
import 'package:me_poupe/model/conta/cartao_model.dart';
import 'package:me_poupe/model/conta/conta_model.dart';
import 'package:me_poupe/model/conta/conta_tipo_model.dart';
import 'package:me_poupe/model/lancamento/lancamento_frequencia_detalhe_model.dart';
import 'package:me_poupe/model/lancamento/lancamento_frequencia_model.dart';
import 'package:me_poupe/model/lancamento/lancamento_model.dart';
import 'package:me_poupe/model/lancamento/lancamento_pagamento_forma_model.dart';
import 'package:me_poupe/model/usuario/usuario_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'funcoes_helper.dart';

class DatabaseHelper {

  static final _databaseName = "me_poupe.db";
  static final _databaseVersion = 1;
  static final _versionAPP = "0.0.1 beta";

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
    Future<Database> get database async {
        if (_database != null) return _database;
        // lazily instantiate the db the first time it is accessed
        _database = await _initDatabase();
        return _database;
    }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String path = join(documentsDirectory.path, _databaseName);

        if(false){
          await deleteDatabase(path);
        }

        return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
    }

    // SQL code to create the database table
    Future _onCreate(Database db, int version) async {
        //CADs
        // await usuarioTipoCadCriar(db);
        await configuracoesCadCriar(db);
        await configuracoesPopular(db);
        await bancoCadCriar(db);
        await bancoCadPopular(db);
        await usuarioCadCriar(db);
        await usuarioPopular(db);

        await pagamentoFormaCadCriar(db);
        await pagamentoFormaCadPopular(db);
        await pagamentoStatusCadCriar(db);
        await pagamentoStatusCadPopular(db);

        await contaTipoCadCriar(db);
        await contaTipoPopular(db);

        await cartaoTipoCadCriar(db);
        await cartaoTipoCadPopular(db);

        await contaCriar(db);
        // await contaBancariaCriar(db);
        // await carteiraCriar(db);
        // await carteiraPopular(db);

        await categoriaCadCriar(db);
        await categoriaCadPopular(db);
        // LANCAMENTO CAD
        await lancamentoTipoCadCriar(db);
        await lancamentoFrequenciaCadCriar(db);
        await lancamentoFrequenciaPeriodoCadCriar(db);
        await cartaoCriar(db);

        //LANCAMENTO POPULAR
        await lancamentoTipoCadPopular(db);
        await lancamentoFrequenciaCadPopular(db);
        await lancamentoFrequenciaPeriodoCadPopular(db);
        await lancamentoCriarTable(db);
        await lancamentoPagamentoCriarTable(db);
        await lancamentoFrequenciaCriarTable(db);
        await lancamentoFrequenciaDetalheCriarTable(db);
        // await lancamentoFrequenciaCriar(db);
        // await usuarioTipoCadPopular(db);

        await seedTestes(db);
    }

  // usuarioTipoCadCriar(Database db) async {
  //   await db.execute(" CREATE TABLE IF NOT EXISTS usuario_tipo_cad ( id INTEGER PRIMARY KEY, descricao VARCHAR(70) ); ");
  // }

  configuracoesCadCriar(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS "+ConfiguracaoModel.TABLE_NAME+" ( chave TEXT , valor TEXT ); ");
  }

  iconesCadCriar(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS icone_cad ( _id INTEGER PRIMARY KEY , codigo VARCHAR(20) , familia VARCHAR(70) , tags TEXT); ");
  }

  usuarioCadCriar(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS "+UsuarioModel.tableName+" ( id INTEGER PRIMARY KEY, id_webserver INTEGER, id_usuario_pai INTEGER ,email TEXT, password TEXT, descricao VARCHAR(70) , imagem blob , dt_update DATETIME ); ");
  }
  bancoCadCriar(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS "+BancoCadModel.TABLE_NAME+" ( _id INTEGER PRIMARY KEY, descricao VARCHAR(70), apelido VARCHAR(30), cor_primaria VARCHAR(20), cor_secundaria VARCHAR(20) , cor_terciaria VARCHAR(20), cor_cartao VARCHAR(20) ,image_asset TEXT , image_url TEXT , image blob ,destaque BOOL , ordem_destaque INTEGER ); ");
  }

  cartaoTipoCadCriar(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS "+CartaoTipoCadModel.TABLE_NAME+" ( _id INTEGER PRIMARY KEY, descricao VARCHAR(70) ); ");
  }

  pagamentoFormaCadCriar(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS "+PagamentoFormaCadModel.TABLE_NAME+" ( _id INTEGER PRIMARY KEY, descricao VARCHAR(70), icone VARCGAR(50) , ordem INTEGER ); ");
  }

  pagamentoStatusCadCriar(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS pagamento_status_cad ( _id INTEGER PRIMARY KEY, descricao VARCHAR(70), ordem INTEGER  ); ");
  }

  cartaoCriar(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS "+CartaoModel.tableName+" ( id INTEGER PRIMARY KEY, id_webserver INTEGER, id_conta INTEGER ,id_cartao_tipo INTEGER, descricao VARCHAR(100) , vl_saldo FLOAT, vl_limite FLOAT, dia_fechamento INTEGER, dia_vencimento INTEGER, st_protected INTEGER, st_deleted INTEGER DEFAULT 0 ,dt_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP, dt_deleted TIMESTAMP DEFAULT null); ");
  }

  lancamentoCriarTable(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS "+LancamentoModel.TABLE_NAME+" ( id INTEGER PRIMARY KEY, id_webserver INTEGER, st_chave_unica VARCHAR(24), id_lancamento_tipo INTEGER,id_usuario INTEGER, descricao VARCHAR(70), id_categoria INTEGER, dt_lancamento Datetime, st_protected INTEGER, dt_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP , dt_delete DEFAULT null ); ");
  }

  lancamentoPagamentoCriarTable(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS "+PagamentoModel.TABLE_NAME+" ( id INTEGER PRIMARY KEY, id_lancamento INTEGER, st_chave_unica VARCHAR(24), id_pagamento_forma INTEGER, id_cartao INTEGER); ");
  }

  lancamentoFrequenciaCriarTable(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS "+FrequenciaModel.TABLE_NAME+" ( id INTEGER PRIMARY KEY, id_lancamento INTEGER, st_chave_unica VARCHAR(24), id_frequencia INTEGER, id_frequencia_periodo INTEGER, no_quantidade INTEGER, vl_integral FLOAT); ");
  }

  lancamentoFrequenciaDetalheCriarTable(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS "+FrequenciaDetalheModel.TABLE_NAME+" ( id INTEGER PRIMARY KEY, id_lancamento INTEGER, st_chave_unica VARCHAR(24), id_lancamento_frequencia INTEGER, no_frequencia INTEGER, dt_detalhe Datetime, dt_mes INTEGER, dt_ano INTEGER, vl_valor FLOAT); ");
  }

  carteiraCriar(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS carteira ( id INTEGER PRIMARY KEY, id_cartao INTEGER, descricao VARCHAR(70), st_protected INTEGER); ");
  }

	contaTipoCadCriar(Database db) async {
		await db.execute(" CREATE TABLE IF NOT EXISTS "+ContaTipoModel.TABLE_NAME+" ( _id INTEGER PRIMARY KEY, descricao VARCHAR(70) ); ");
	}

  contaCriar(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS "+ContaModel.tableName+" ( id INTEGER PRIMARY KEY, id_webserver INTEGER, id_banco INTEGER , id_conta_tipo INTEGER , descricao VARCHAR(30), st_deleted INTEGER DEFAULT 0, dt_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP, dt_deleted TIMESTAMP DEFAULT null); ");
  }

  // contaBancariaCriar(Database db) async {
	// 	await db.execute(" CREATE TABLE IF NOT EXISTS conta_bancaria ( id INTEGER PRIMARY KEY, id_banco INTEGER , id_conta_tipo INTEGER , descricao VARCHAR(30) , saldo FLOAT ); ");
	// }

	categoriaCadCriar(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS "+CategoriaCadModel.TABLE_NAME+" ( _id INTEGER PRIMARY KEY, id_pai INTEGER , descricao VARCHAR(50) , icone VARCHAR(40) , ordem INTEGER); ");
  }

  lancamentoTipoCadCriar(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS "+LancamentoTipoCadModel.TABLE_NAME+" ( _id INTEGER PRIMARY KEY , descricao VARCHAR(50) ); ");
  }

  lancamentoFrequenciaCadCriar(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS "+FrequenciaCadModel.TABLE_NAME+" ( _id INTEGER PRIMARY KEY , descricao VARCHAR(50) ); ");
  }

  lancamentoFrequenciaPeriodoCadCriar(Database db) async {
    await db.execute(" CREATE TABLE IF NOT EXISTS "+FrequenciaPeriodoCadModel.TABLE_NAME+" ( _id INTEGER PRIMARY KEY , descricao VARCHAR(50) , dias INTEGER , st_exibir INTEGER); ");
  }
  // POPULAR
  configuracoesPopular(Database db) async {
    // VERSAO
    await db.execute(" INSERT INTO "+ConfiguracaoModel.TABLE_NAME+" VALUES ('no_version','${_versionAPP}' );  ");
    await db.execute(" INSERT INTO "+ConfiguracaoModel.TABLE_NAME+" VALUES ('no_aberturas','0' );  ");
    // NORMAL / NOTURNO
    await db.execute(" INSERT INTO "+ConfiguracaoModel.TABLE_NAME+" VALUES ('exibir_saldo','true' );  ");
    await db.execute(" INSERT INTO "+ConfiguracaoModel.TABLE_NAME+" VALUES ('modo','normal' );  ");
    return 1;
  }

  iconeCadPopular(Database db) async{
//    Dummy dummy = new Dummy();
//    List<IconeCadModel> lista = dummy.buscarListaIcones;
//
//    lista.map( (objeto) async {
//      int id = objeto.id;
//      String codigo = objeto.codigo;
//      String familia = objeto.familia;
//      String pacote = objeto.pacote;
////      String tags = objeto.tags;
//
//      String query = "INSERT INTO icone_cad (_id, codigo ,familia , pacote ) VALUES ("+id.toString()+" , '"+codigo+"', '"+familia.toString()+"', '"+pacote.toString()+"');";
//      await db.execute(query);
//    }).toList();
  }

	usuarioPopular(Database db) async {
		// String senha = md5("flamengo");
    await db.execute(" INSERT INTO usuario (id,id_usuario_pai,email,password,descricao,dt_update) VALUES (1,0,'admin@vidabugada.net','Flamengo+1981+App','admin', date('now') );  ");
    await db.execute(" INSERT INTO usuario (id,id_usuario_pai,email,password,descricao,dt_update) VALUES (2,0,'scarapa@gmail.com','flamengo','Roberto', date('now') );  ");
    await db.execute(" INSERT INTO usuario (id,id_usuario_pai,email,password,descricao,dt_update) VALUES (3,1,'tonialcf@gmail.com','luisa','Tonia', date('now') );  ");
		return 1;
  }

  pagamentoFormaCadPopular(Database db) async {
    await db.execute(" INSERT INTO "+PagamentoFormaCadModel.TABLE_NAME+"  (descricao,icone,ordem) VALUES ('Dinheiro','dinheiro-01',10 );  ");
    await db.execute(" INSERT INTO "+PagamentoFormaCadModel.TABLE_NAME+"  (descricao,icone,ordem) VALUES ('Cartão','cartao-credito-01',20 );  ");
    await db.execute(" INSERT INTO "+PagamentoFormaCadModel.TABLE_NAME+"  (descricao,icone,ordem) VALUES ('Cheque','cheque-01',30 );  ");
    return 1;
  }

  pagamentoStatusCadPopular(Database db) async {
    await db.execute(" INSERT INTO pagamento_status_cad (descricao,ordem) VALUES ('A pagar',10 );  ");
    await db.execute(" INSERT INTO pagamento_status_cad (descricao,ordem) VALUES ('Vencida',20 );  ");
    await db.execute(" INSERT INTO pagamento_status_cad (descricao,ordem) VALUES ('Pago',30 );  ");
    return 1;
  }

  bancoCadPopular(Database db) async{
    BancoDummy dummy = new BancoDummy();
    List<BancoCadModel> lista = dummy.lista;

    lista.map( (objeto) async {
      int id = objeto.id;
      String descricao = objeto.descricao;
      String corPrimaria = ( objeto.corPrimaria != null ) ? objeto.corPrimaria : "#FFFFFF";
      String corSecundaria = ( objeto.corSecundaria != null ) ? objeto.corSecundaria : "#FFFFFF";
      String corTerciaria = ( objeto.corTerciaria != null ) ? objeto.corTerciaria : "#FFFFFF";
      String corCartao = ( objeto.corCartao != null ) ? objeto.corCartao : "#FFFFFF";
      String imagemAsset = ( objeto.imageAsset != null ) ? objeto.imageAsset : "assets/images/bancos/logo/00.png";
      int destaque = (objeto.destaque)? 1 : 0;
      int ordemDestaque = objeto.ordemDestaque;
      String query = "INSERT INTO "+BancoCadModel.TABLE_NAME+" (_id,descricao,cor_primaria,cor_secundaria,cor_terciaria,cor_cartao,image_asset,destaque,ordem_destaque) VALUES ("+id.toString()+" , '"+descricao+"', '"+corPrimaria.toString()+"', '"+corSecundaria.toString()+"', '"+corTerciaria.toString()+"', '"+corCartao.toString()+"','"+imagemAsset.toString()+"','"+destaque.toString()+"',"+ordemDestaque.toString()+");";
      await db.execute(query);
    }).toList();
  }

  categoriaCadPopular(Database db) async{
    CategoriaDummy dummy = new CategoriaDummy();
    List<CategoriaCadModel> lista = dummy.lista;

    lista.map( (objeto) async {
      int id = objeto.id;
      int id_pai = objeto.idPai;
      String descricao = objeto.descricao;
      String icone = objeto.icone.toString();
      int ordem = objeto.order;
      String query = "INSERT INTO "+CategoriaCadModel.TABLE_NAME+" ( _id , id_pai , descricao , icone , ordem) VALUES ("+id.toString()+" ,"+id_pai.toString()+", '"+descricao+"' , '"+icone.toString()+"',"+ordem.toString()+");";
      await db.execute(query);
    }).toList();
  }

  carteiraPopular(Database db) async {
    await db.execute(" INSERT INTO carteira (id, id_cartao, descricao, st_protected) VALUES (1,null,'Minha Carteira',1);  ");
    return 1;
  }

  lancamentoTipoCadPopular(Database db) async {
    await db.execute(" INSERT INTO "+LancamentoTipoCadModel.TABLE_NAME+" (descricao) VALUES ('Despesa');  ");
    await db.execute(" INSERT INTO "+LancamentoTipoCadModel.TABLE_NAME+" (descricao) VALUES ('Receita');  ");
    return true;
  }

  lancamentoFrequenciaCadPopular(Database db) async {
    await db.execute(" INSERT INTO "+FrequenciaCadModel.TABLE_NAME+" (descricao) VALUES ('Única');  ");
    await db.execute(" INSERT INTO "+FrequenciaCadModel.TABLE_NAME+" (descricao) VALUES ('Fixa');  ");
    await db.execute(" INSERT INTO "+FrequenciaCadModel.TABLE_NAME+" (descricao) VALUES ('Parcelada');  ");
    return true;
  }

  lancamentoFrequenciaPeriodoCadPopular(Database db) async {
    await db.execute(" INSERT INTO "+FrequenciaPeriodoCadModel.TABLE_NAME+" (descricao,dias,st_exibir) VALUES ('Diária',1,1);");
    await db.execute(" INSERT INTO "+FrequenciaPeriodoCadModel.TABLE_NAME+" (descricao,dias,st_exibir) VALUES ('Semanal',7,1);");
    await db.execute(" INSERT INTO "+FrequenciaPeriodoCadModel.TABLE_NAME+" (descricao,dias,st_exibir) VALUES ('Quinzenal',15,0);");
    await db.execute(" INSERT INTO "+FrequenciaPeriodoCadModel.TABLE_NAME+" (descricao,dias,st_exibir) VALUES ('Mensal',30,1);");
    await db.execute(" INSERT INTO "+FrequenciaPeriodoCadModel.TABLE_NAME+" (descricao,dias,st_exibir) VALUES ('Bimestral',60,0);");
    await db.execute(" INSERT INTO "+FrequenciaPeriodoCadModel.TABLE_NAME+" (descricao,dias,st_exibir) VALUES ('Trimestral',90,0);");
    await db.execute(" INSERT INTO "+FrequenciaPeriodoCadModel.TABLE_NAME+" (descricao,dias,st_exibir) VALUES ('Quadrimestral',120,0);");
    await db.execute(" INSERT INTO "+FrequenciaPeriodoCadModel.TABLE_NAME+" (descricao,dias,st_exibir) VALUES ('Semestral',180,0);");
    await db.execute(" INSERT INTO "+FrequenciaPeriodoCadModel.TABLE_NAME+" (descricao,dias,st_exibir) VALUES ('Anual',365,1);");
    return true;
  }

  cartaoTipoCadPopular(Database db) async {
    await db.execute(" INSERT INTO "+CartaoTipoCadModel.TABLE_NAME+" (descricao) VALUES ('outros');  ");
    await db.execute(" INSERT INTO "+CartaoTipoCadModel.TABLE_NAME+" (descricao) VALUES ('cartão de crédito');  ");
    await db.execute(" INSERT INTO "+CartaoTipoCadModel.TABLE_NAME+" (descricao) VALUES ('cartão de débito');  ");
    await db.execute(" INSERT INTO "+CartaoTipoCadModel.TABLE_NAME+" (descricao) VALUES ('cartão poupança');  ");
    await db.execute(" INSERT INTO "+CartaoTipoCadModel.TABLE_NAME+" (descricao) VALUES ('cartão vale-alimentação');  ");
    await db.execute(" INSERT INTO "+CartaoTipoCadModel.TABLE_NAME+" (descricao) VALUES ('cartão vale-refeição');  ");
    return true;
  }

  contaTipoPopular(Database db) async {
    await db.execute(" INSERT INTO "+ContaTipoModel.TABLE_NAME+" (descricao) VALUES ('conta corrente');  ");
    await db.execute(" INSERT INTO "+ContaTipoModel.TABLE_NAME+" (descricao) VALUES ('poupanca');  ");
    await db.execute(" INSERT INTO "+ContaTipoModel.TABLE_NAME+" (descricao) VALUES ('salário');  ");
    await db.execute(" INSERT INTO "+ContaTipoModel.TABLE_NAME+" (descricao) VALUES ('conjunta');  ");
    await db.execute(" INSERT INTO "+ContaTipoModel.TABLE_NAME+" (descricao) VALUES ('familiar');  ");
    return true;
  }

  // contaBancariaPopular(Database db) async {
  //   await db.execute(" INSERT INTO conta (id_banco , id_cartao_tipo , descricao , vl_saldo , vl_limite , dia_fechamento , dia_vencimento) VALUES ('cc');  ");
  // }

  seedTestes(Database db) async {
    await seedPopularConta(db);
    await seedPopularCartao(db);
    await seedPopularLancamentos(db);
    // await seedPopularCarteiras(db);
    return true;

  }

  seedPopularConta(Database db) async {
    await db.execute(" INSERT INTO "+ContaModel.tableName+" ( id_banco, id_conta_tipo , descricao ) VALUES (22,1,'banri');  ");
    await db.execute(" INSERT INTO "+ContaModel.tableName+" ( id_banco, id_conta_tipo , descricao ) VALUES (52,1,'roxinho');  ");
    await db.execute(" INSERT INTO "+ContaModel.tableName+" ( id_banco, id_conta_tipo , descricao ) VALUES (44,1,'itau pai');  ");
    await db.execute(" INSERT INTO "+ContaModel.tableName+" ( id_banco, id_conta_tipo , descricao ) VALUES (80,3,'green card');  ");
  }
   seedPopularCartao(Database db) async {
    await db.execute(" INSERT INTO "+CartaoModel.tableName+" (id_conta , id_cartao_tipo , descricao , vl_saldo , vl_limite , dia_fechamento , dia_vencimento) VALUES (1,3,'debito',null,4500.0,null,null);  ");
    await db.execute(" INSERT INTO "+CartaoModel.tableName+" (id_conta , id_cartao_tipo , descricao , vl_saldo , vl_limite , dia_fechamento , dia_vencimento) VALUES (1,2,'credito',null,7000.0,26,6);  ");
    await db.execute(" INSERT INTO "+CartaoModel.tableName+" (id_conta , id_cartao_tipo , descricao , vl_saldo , vl_limite , dia_fechamento , dia_vencimento) VALUES (2,2,'credito',2500.0,null,25,5);  ");
    await db.execute(" INSERT INTO "+CartaoModel.tableName+" (id_conta , id_cartao_tipo , descricao , vl_saldo , vl_limite , dia_fechamento , dia_vencimento) VALUES (3,3,'debito',10000.0,null,0,0);  ");
    await db.execute(" INSERT INTO "+CartaoModel.tableName+" (id_conta , id_cartao_tipo , descricao , vl_saldo , vl_limite , dia_fechamento , dia_vencimento) VALUES (4,5,'greencard',3000.0,null,0,0);  ");
    await db.execute(" INSERT INTO "+CartaoModel.tableName+" (id_conta , id_cartao_tipo , descricao , vl_saldo , vl_limite , dia_fechamento , dia_vencimento) VALUES (1,4,'poupanca moto',3000.0,null,null,null);");
  }

  // seedPopularCarteiras(Database db) async {
  //   await db.execute(" INSERT INTO carteira (id , id_cartao, descricao, st_protected) VALUES (2,3,'Banri',0);  ");
  //   await db.execute(" INSERT INTO carteira (id , id_cartao, descricao, st_protected) VALUES (3,4,'Banri',0);  ");
  // }

  seedPopularLancamentos(Database db) async {
    LancamentosDummy dummy = new LancamentosDummy();
    List linhas = dummy.lista;

    // PERCORRENDO A LISTA E SALVANDO
    linhas.map( (linha) async {

      Map<String,dynamic> linhaLancamento = Map();
      String chaveUnica = Funcoes.gerarIdentificador(linha['id_usuario'],data: linha['dt_lancamento'].toString());
      linhaLancamento['id_usuario'] = linha['id_usuario'];
      linhaLancamento['st_chave_unica'] = chaveUnica;
      linhaLancamento['descricao'] = linha['descricao'];
      linhaLancamento['id_lancamento_tipo'] = linha['id_lancamento_tipo'];
      linhaLancamento['id_categoria'] = linha['id_categoria'];
      linhaLancamento['dt_lancamento'] = linha['dt_lancamento'] ;
      int lancamentoId;
      try{
        lancamentoId = await db.insert("lancamento", linhaLancamento);
        print("ID : ${lancamentoId}");
      }catch(e){
        print("ERRO TABELA LANCAMENTO: $e");
        return;
      }

      //lancamento pagamento
      Map<String,dynamic> linhaLancamentoPagamento = Map();
      linhaLancamentoPagamento['id_lancamento'] = lancamentoId;
      linhaLancamentoPagamento['st_chave_unica'] = chaveUnica;
      linhaLancamentoPagamento['id_pagamento_forma'] = linha['id_pagamento_forma'];
      linhaLancamentoPagamento['id_cartao'] = linha['id_cartao'];
      try{
        await db.insert("lancamento_pagamento", linhaLancamentoPagamento);
      }catch(e){
        print("ERRO TABELA lancamento_pagamento :$e");
        return;
      }

      //lancamento frequencia
      Map<String,dynamic> linhaFrequencia = Map();
      linhaFrequencia['id_lancamento'] = lancamentoId;
      linhaFrequencia['st_chave_unica'] = chaveUnica;
      linhaFrequencia['id_frequencia'] = linha['id_frequencia'];
      linhaFrequencia['id_frequencia_periodo'] = linha['id_frequencia_periodo'];
      linhaFrequencia['no_quantidade'] = linha['no_quantidade'];
      linhaFrequencia['vl_integral'] = linha['vl_integral'];
      int lancamentoFrequenciaId = await db.insert("lancamento_frequencia", linhaFrequencia);

      // BUSCAR FREQUENCIA PERIODO CAD
      var linhaFrequenciaPeriodoCad = await db.query("frequencia_periodo_cad", where: "_id = ?", whereArgs: [linha['id_frequencia_periodo']]);

      // lancamento frequencia detalhe
      int numeroDias = linhaFrequenciaPeriodoCad[0]['dias'];
      int numeroTotalPeriodos = linhaFrequencia['no_quantidade'];
      double linhaFrequenciaDetalheValor = (linha['id_frequencia'] == 2)?  linha['vl_integral'] :  linha['vl_integral'] / linhaFrequencia['no_quantidade'];
      int salto;
      int numeroFrequencia;

      for(int i = 0 ; i < numeroTotalPeriodos ; i++){
        numeroFrequencia = i+1;
        salto = numeroDias * i;
        DateTime dataOriginal = DateTime.parse( linhaLancamento['dt_lancamento'] );
        DateTime dataParcela;

        // DEFINICAO DE SOMAR A DATA CONFORME O PERIODO
        if(linhaFrequencia['id_frequencia_periodo'] == 4){
          dataParcela = new DateTime(
              dataOriginal.year ,
              dataOriginal.month + i,
              dataOriginal.day
          );
          // periodo ANUAL
        }else if(linhaFrequencia['id_frequencia_periodo'] == 9){
          dataParcela = new DateTime(
              dataOriginal.year+i ,
              dataOriginal.month,
              dataOriginal.day
          );
        }else{
          dataParcela = new DateTime(
              dataOriginal.year ,
              dataOriginal.month ,
              dataOriginal.day
          ).add(Duration(days: salto));
        }

        // FREQUENCIA DETALHE
        Map<String,dynamic> linhaFrequenciaDetalhe = Map();
        linhaFrequenciaDetalhe['id_lancamento'] = lancamentoId;
        linhaFrequenciaDetalhe['st_chave_unica'] = chaveUnica;
        linhaFrequenciaDetalhe['id_lancamento_frequencia'] = lancamentoFrequenciaId;
        linhaFrequenciaDetalhe['no_frequencia'] = numeroFrequencia;
        linhaFrequenciaDetalhe['dt_detalhe'] = Funcoes.somenteData( dataParcela.toString() );
        linhaFrequenciaDetalhe['dt_mes'] = dataParcela.month;
        linhaFrequenciaDetalhe['dt_ano'] = dataParcela.year;
        linhaFrequenciaDetalhe['vl_valor'] = linhaFrequenciaDetalheValor;

        try{
          await db.insert("lancamento_frequencia_detalhe", linhaFrequenciaDetalhe);
        }catch(e){
          print("ERRO TABELA lancamento_frequencia_detalhe :$e");
          return;
        }
      }
      //print("linhaFrequenciaPeriodoCad: ${linhaFrequenciaPeriodoCad[0]}");
    }).toList();
    print('CONCLUIDO');

}


// Helper methods
  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(tabela,Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tabela, row);
  }

  Future<List<Map<String, dynamic>>> executarQuery(String query,{List where , String order= "" , String limit = ""}) async {
    Database db = await this.database;
    List<Map> list = await db.rawQuery(query);
    return list;
  }

  Future<int> executar(String comando) async {
    Database db = await instance.database;
    await db.execute(comando);
    return 1;
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(tabela) async {
    Database db = await instance.database;
    return await db.query(tabela);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount(tabela) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tabela'));
  }

  Future<List<Map<String, dynamic>>> queryCustom(sql) async {
    Database db = await instance.database;
    List<Map> list = await db.rawQuery(sql);
    return list;
  }

  Future<dynamic> query(String tabela, {
    bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}
      ) async {
    Database db = await this.database;
    return db.query(tabela,columns: columns,where: where,whereArgs: whereArgs,groupBy: groupBy,orderBy: orderBy);
  }
  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.

  Future<int> update(tabela , primaryKey , Map<String, dynamic> row) async {
    Database db = await instance.database;
    String primaryValue = row["${primaryKey}"].toString() ;
    return await db.update(tabela, row, where:" $primaryKey = $primaryValue ");
  }

  Future<int> delete(tabela,{int valor, String coluna }) async {
    Database db = await this.database;
    if( valor == null  || coluna == null){
      var retorno = Map<String,dynamic>();
      retorno['seq'] = 0;
      db.update("sqlite_sequence" , retorno , where: 'name = ?', whereArgs: [tabela] );
      return await db.delete(tabela);
    }else{
      return await db.delete(tabela, where: "$coluna = ?", whereArgs: ["$valor"]);
    }
  }

//  Future<int> update(Map<String, dynamic> row) async {
//    Database db = await instance.database;
//    int id = row[columnId];
//    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
//  }
//
//  // Deletes the row specified by the id. The number of affected rows is
//  // returned. This should be 1 as long as the row exists.
//  Future<int> delete(int id) async {
//    Database db = await instance.database;
//    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
//  }
}