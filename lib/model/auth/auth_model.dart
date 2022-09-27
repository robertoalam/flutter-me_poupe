import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:me_poupe/helper/api_helper.dart';
import 'package:me_poupe/helper/database_helper.dart';
import 'package:me_poupe/helper/funcoes_helper.dart';

class AuthModel{
  int id;
  String usuario;
  String nome;
  String email;
  String senha;  
  String token;
  int ativo;
  DateTime datalogin;

  static final String TABLE_NAME = "login";

  final dbHelper = DatabaseHelper.instance;

  AuthModel({
    this.id,
    this.usuario,
    this.nome,
    this.email,
    this.senha,
    this.token,
    this.ativo,
    this.datalogin
  });

  @override
  String toString() {
    return "${this.id} ${this.usuario} ${this.nome} ${this.email} ${this.token} ${this.datalogin}";
  }

  Map database() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["usuario"] = this.usuario;
    map["nome"] = this.nome;
    map["email"] = this.email;
    map["token"] = this.token;
    map["senha"] = this.senha;
    map["ativo"] = ativo;
    // map["dt_login"] = datalogin;
    return map;
  }

  authLogin(data , host ) async {
    if( data == null) return null;
    if( host == null) return null;

    Map<String,dynamic> resposta;
    
    try{
      resposta = await APIHelper.post({'url':host,'data':data});
      if(resposta == null) return null;
      return resposta;

    }catch(e){
      print("ERRO: ${e.toString()}");
      return resposta = null;
    }
  }

  create( dados ) async {
    this.id = dados['id'];
    this.usuario = dados['email'].toString().split("@")[0];
    this.nome = dados['nome'];
    this.email = dados['email'];
    this.token = dados['assinatura'];
    this.datalogin = DateTime.now();

    var id;
    try{
      this.ativo = 1;
      this.senha = null;
      id = await dbHelper.insert( TABLE_NAME , this.database()  );
    }catch(error){
      id = 0;
    }
    return id;
  }

  // verificar se existe login ativo
  getLoginAtivo() async {
    final dbHelper = DatabaseHelper.instance;
    String query = " SELECT * FROM "+TABLE_NAME+" WHERE ativo = 1 ORDER BY dt_login DESC; ";
    var linhas = await dbHelper.executarQuery( query );
    return (linhas.length > 0)? true:false;
  }

  // DESLOGAR TODOS USUARIOS
  logOff() async {
    final dbHelper = DatabaseHelper.instance;
    String query = " UPDATE "+TABLE_NAME+" SET ativo = 0;";
    return await dbHelper.executar( query );
  }
}