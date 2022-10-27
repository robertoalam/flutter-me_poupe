import 'package:me_poupe/helper/api_helper.dart';
import 'package:me_poupe/model/cad/cad_categoria_model.dart';

class CategoriaService extends CategoriaCadModel{

  CategoriaService(){

  }

  @override
  fetchByAll() {
    APIHelper _apiHelper = new APIHelper();
    _apiHelper.fetch(
      "http://192.168.8.110/i9tecnosul.com.br/me-poupe/api/v1/cad/cartao-tipo/getall",
    );
  }

  @override
  fetchById(int id) {
    // TODO: implement fetchById
    return super.fetchById(id);
  }
}