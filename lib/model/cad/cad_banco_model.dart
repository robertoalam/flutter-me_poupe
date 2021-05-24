import 'package:me_poupe/helper/database_helper.dart';

class BancoCadModel{
  final int id;
  final String descricao;
  final String apelido;
  final String imageAsset;
  final String imageUrl;
  final String imageBlob;
  final String corPrimaria;
  final String corSecundaria;
  final String corTerciaria;
  final String corCartao;
  final bool destaque;
  final int ordemDestaque;

  final dbHelper = DatabaseHelper.instance;

  static final String TABLE_NAME = "banco_cad";

  BancoCadModel({
    this.id,
    this.descricao,
    this.apelido,
    this.imageAsset,
    this.imageUrl,
    this.imageBlob,
    this.corPrimaria,
    this.corSecundaria,
    this.corTerciaria,
    this.corCartao,
    this.destaque = false,
    this.ordemDestaque = 10000,
  });


  @override
  String toString() {
    return "${this.descricao}";
  }

  factory BancoCadModel.fromJson(Map<String, dynamic> json) {
    return BancoCadModel(
      id: json['_id'],
      descricao: json['descricao'],
      apelido: json['apelido'],
      corPrimaria: json['cor_primaria'],
      corSecundaria: json['cor_secundaria'],
      corTerciaria: json['cor_terciaria'],
      corCartao: json['cor_cartao'],
      imageAsset: json['image_asset'],
      ordemDestaque: json['ordem_destaque'],
    );
  }

  factory BancoCadModel.getDestaque(int destaque) {
    final dbHelper = DatabaseHelper.instance;
    var linha;
    if( destaque !=null || destaque.toString() != "" ) {
      linha = dbHelper.query(TABLE_NAME, where: "destaque = ?", whereArgs: [destaque],orderBy: " ORDER BY ordem_destaque DESC");
      linha = linha.isNotEmpty ? BancoCadModel.fromJson(linha.first) : null;
    }
    return linha;
  }

  fetchByDestaque(int destaque) async {

    var linhas;
    List<BancoCadModel> lista = List<BancoCadModel>();
    if( destaque !=null || destaque.toString() != "" ) {
      linhas = await dbHelper.query(TABLE_NAME, where: "destaque = ?", whereArgs: [destaque]);
      for(int i=0;i < linhas.length ; i++){
        BancoCadModel objeto = new BancoCadModel.fromJson(linhas[i]);
        lista.add(objeto);
      }
    }
    return lista;
  }

  fetchByWhere({String pesquisar,String order}) async {
    String where ="";
    String ordenacao = "";
    String query ;

    if(pesquisar != null) {
      where = pesquisar;
    }

    where = (where != null)? where : "";
    ordenacao = (order != null)? order : " ORDER BY descricao ";

    query = " SELECT * FROM "+TABLE_NAME+" WHERE 1=1 $where $ordenacao ";
    var linhas;
    List<BancoCadModel> lista = List<BancoCadModel>();
    if( destaque !=null || destaque.toString() != "" ) {
      linhas = await dbHelper.queryCustom(query);
      for(int i=0;i < linhas.length ; i++){
        BancoCadModel objeto = new BancoCadModel.fromJson(linhas[i]);
        lista.add(objeto);
      }
    }
    return lista;
  }

  fetchByDestaque2(int destaque,{int notIn}) async {
    String where;
    var argumentos = [];
    if(notIn != null){
      where = "destaque = ? AND _id NOT IN (?) ";
      argumentos = [destaque,notIn];
    }else{
      where = "destaque = ?";
      argumentos = [destaque];
    }

    var linhas;
    List<BancoCadModel> lista = List<BancoCadModel>();
    if( destaque !=null || destaque.toString() != "" ) {
      linhas = await dbHelper.query(TABLE_NAME, where: where, whereArgs: argumentos);
      for(int i=0;i < linhas.length ; i++){
        BancoCadModel objeto = new BancoCadModel.fromJson(linhas[i]);
        lista.add(objeto);
      }
    }
    return lista;
  }

  fetchById(int id) async {
    var linha;
    if( id !=null || id.toString() != "" ) {
      linha = await dbHelper.query(TABLE_NAME, where: "_id = ?", whereArgs: [id]);
      linha = linha.isNotEmpty ? BancoCadModel.fromJson(linha.first) : null;
    }
    return linha;
  }

  fetchByAll() async {
    final linhas = await dbHelper.queryAllRows(TABLE_NAME);
    List<BancoCadModel> lista = List<BancoCadModel>();
    for(int i=0;i < linhas.length ; i++){
      BancoCadModel objeto = new BancoCadModel.fromJson(linhas[i]);
      lista.add(objeto);
    }
    return lista;
  }


}