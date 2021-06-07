import 'package:me_poupe/helper/database_helper.dart';

import 'usuario_tipo_model.dart';

class UsuarioModel{
  int id;
  int webserverId;
//  UsuarioTipoModel tipo;
  UsuarioModel usuarioPai;
  String apelido;
  String imagem;
  String identificador;
  String password;

  final dbHelper = DatabaseHelper.instance;

  static final String tableName = "usuario";

}