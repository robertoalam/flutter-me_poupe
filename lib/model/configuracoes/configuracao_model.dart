import 'package:me_poupe/helper/database_helper.dart';

class ConfiguracaoModel{

    List<Map<String,dynamic>> lista;

    ConfiguracaoModel({this.lista});

    static final String TABLE_NAME = "configuracoes";

    final dbHelper = DatabaseHelper.instance;

    getConfiguracao() async {
        List<Map> maps = await dbHelper.queryAllRows(TABLE_NAME);
        if (maps.length > 0) {
            return maps;
        } else {
            return null;
        }

    }

    static getConfiguracoes() async {
        final dbHelper = DatabaseHelper.instance;

        Map<String,dynamic> retorno = Map();
        List<Map<String,dynamic>> maps = await dbHelper.queryAllRows(TABLE_NAME);
        maps.forEach( (elemento) {
            String chave = elemento['chave'];
            String valor = elemento['valor'];
            retorno['$chave'] = valor;
        });
        return retorno;
    }

    static incrementAbertura() async {
        final dbHelper = DatabaseHelper.instance;

        String query = "UPDATE "+TABLE_NAME+" SET valor = valor + 1 WHERE chave = 'no_aberturas' ;";
        return await dbHelper.executar( query );
    }

    static alterarModo(valor) async {
        final dbHelper = DatabaseHelper.instance;

        String query = "UPDATE "+TABLE_NAME+" SET valor = '"+valor+"' WHERE chave = 'modo' ;";
        return await dbHelper.executar( query );
    }

    static alterarExibirSaldo(valor) async {
        final dbHelper = DatabaseHelper.instance;

        String query = "UPDATE "+TABLE_NAME+" SET valor = '"+valor.toString()+"' WHERE chave = 'exibir_saldo' ;";
        return await dbHelper.executar( query );
    }
}

