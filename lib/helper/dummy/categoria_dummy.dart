import 'package:me_poupe/model/cad/cad_categoria_model.dart';

class CategoriaDummy{
  List<CategoriaCadModel> get lista {
    return [
      CategoriaCadModel(id: 1 , idPai: 0 , descricao: "",icone: 'ajuda-01' ,order: 0),
      CategoriaCadModel(id: 10 , idPai: 0 , descricao: "Alimentação",icone: 'alimentar-01' ,order: 10),
      CategoriaCadModel(id: 20 , idPai: 0 , descricao: "Saúde",icone: 'saude-pasta-01',order: 20),
      CategoriaCadModel(id: 30 , idPai: 0 , descricao: "Lazer",icone: 'lazer-01',order: 30),
      CategoriaCadModel(id: 40 , idPai: 0 , descricao: "Compras",icone: 'comprar-01',order: 40),
      CategoriaCadModel(id: 50 , idPai: 0 , descricao: "Casa",icone: 'home-01',order: 50),
      CategoriaCadModel(id: 60 , idPai: 0 , descricao: "Educação",icone: 'school-01' ,order: 60),
      CategoriaCadModel(id: 70 , idPai: 0 , descricao: "Transporte",icone:'transporte',order: 70),
      CategoriaCadModel(id: 80 , idPai: 0 , descricao: "Trabalho",icone: 'trabalhar-01',order: 80),
      CategoriaCadModel(id: 90 , idPai: 0 , descricao: "Outros",icone: 'help-01' ,order: 90),
      CategoriaCadModel(id: 100 , idPai: 0 , descricao: "Receitas",icone: 'money-01' ,order: 100),
      CategoriaCadModel(id: 110 , idPai: 0 , descricao: "Financeiro",icone: 'money-01' ,order: 100),
      CategoriaCadModel(id: 120 , idPai: 0 , descricao: "Contas Fixas",icone: 'money-01' ,order: 100),

      //ALIMENTACAO
      CategoriaCadModel(id: 1001 , idPai: 10 , descricao: "Almoço",icone:"alimentar-02"),
      CategoriaCadModel(id: 1002 , idPai: 10 , descricao: "Lanche",icone: 'alimentar-03'),
      CategoriaCadModel(id: 1003 , idPai: 10 , descricao: "Bar",icone: 'bebida-01'),
      CategoriaCadModel(id: 1004 , idPai: 10 , descricao: "Supermercado",icone: 'comprar-03'),
      CategoriaCadModel(id: 1005 , idPai: 10 , descricao: "Doces",icone: 'doce-01'),
      CategoriaCadModel(id: 1006 , idPai: 10 , descricao: "Padaria",icone: 'pao-01'),
      CategoriaCadModel(id: 1007 , idPai: 10 , descricao: "Restaurante",icone: 'alimentar-01'),

      //SAUDE
      CategoriaCadModel(id: 2001 , idPai: 20 , descricao: "Remédio",icone:"saude-remedio-02"),
      CategoriaCadModel(id: 2002 , idPai: 20 , descricao: "Consulta",icone:"saude-pessoa-01"),
      CategoriaCadModel(id: 2003 , idPai: 20 , descricao: "Exame",icone:"saude-03"),

      //LAZER
      CategoriaCadModel(id: 3001 , idPai: 30 , descricao: "Esportes",icone:"esporte-futebol-01"),
      CategoriaCadModel(id: 3002 , idPai: 30 , descricao: "Academia",icone:"esporte-academia-pessoa-01"),
      CategoriaCadModel(id: 3003 , idPai: 30 , descricao: "Viagem",icone:"mala-01"),
      CategoriaCadModel(id: 3004 , idPai: 30 , descricao: "Piscina",icone:"piscina-01"),

      // COMPRAS
      CategoriaCadModel(id: 4001 , idPai: 40 , descricao: "Roupas",icone:"roupa-01"),
      CategoriaCadModel(id: 4002 , idPai: 40 , descricao: "Pets",icone:"pets-01"),

      //CASA
      CategoriaCadModel(id: 5001 , idPai: 50 , descricao: "Decoração",icone:"home-03"),
      CategoriaCadModel(id: 5002 , idPai: 50 , descricao: "Móveis",icone:"casa-moveis-01"),
      CategoriaCadModel(id: 5003 , idPai: 50 , descricao: "Artigos p/banho",icone:"casa-banheiro-01"),
      CategoriaCadModel(id: 5004 , idPai: 50 , descricao: "Eletrodoméstico",icone:"eletro-01"),
      CategoriaCadModel(id: 5005 , idPai: 50 , descricao: "Peças encanamento",icone:"eletro-01"),
      CategoriaCadModel(id: 5006 , idPai: 50 , descricao: "Peças hidraulica",icone:"eletro-01"),
      CategoriaCadModel(id: 5007 , idPai: 50 , descricao: "Torneira",icone:"eletro-01"),

      //Educação
      CategoriaCadModel(id: 6001 , idPai: 60 , descricao: "Creche",icone:"pessoa-bebe-01"),
      CategoriaCadModel(id: 6002 , idPai: 60 , descricao: "Colégio",icone:"school-04"),
      CategoriaCadModel(id: 6003 , idPai: 60 , descricao: "Faculdade",icone:"school-01"),
      CategoriaCadModel(id: 6004 , idPai: 60 , descricao: "Curso de Idiomas",icone:"school-03"),
      CategoriaCadModel(id: 6005 , idPai: 60 , descricao: "Material Escolar",icone:"school-06"),
      CategoriaCadModel(id: 6006 , idPai: 60 , descricao: "Fotocopia",icone:"copiar-01"),
      CategoriaCadModel(id: 6007 , idPai: 60 , descricao: "Aulas Particulares",icone:"pessoa-professor-01"),

      //TRANSPORTE
      CategoriaCadModel(id: 7001 , idPai: 70 , descricao: "Combustível",icone:"combustivel-01"),
      CategoriaCadModel(id: 7002 , idPai: 70 , descricao: "Aplicativos de carros",icone:"celular-01"),
      CategoriaCadModel(id: 7003 , idPai: 70 , descricao: "Onibus",icone:"transporte-02"),
      CategoriaCadModel(id: 7004 , idPai: 70 , descricao: "Passagem Aerea",icone:"transporte-03"),
      CategoriaCadModel(id: 7005 , idPai: 70 , descricao: "Estacionamento",icone:"estacionamento-01"),
      CategoriaCadModel(id: 7006 , idPai: 70 , descricao: "Lavagem",icone:"estacionamento-01"),

      //RECEITAS
      CategoriaCadModel(id: 10001 , idPai: 100 , descricao: "Salário",icone:"money-01"),
      CategoriaCadModel(id: 10002 , idPai: 100 , descricao: "Empréstimo",icone:"money-01"),
      CategoriaCadModel(id: 10003 , idPai: 100 , descricao: "Investimento",icone:"money-01"),
      CategoriaCadModel(id: 10004 , idPai: 100 , descricao: "Outras receitas",icone:"money-01"),

      //FINANCAS
      CategoriaCadModel(id: 11001 , idPai: 110 , descricao: "Financiamento",icone:"money-03"),
      CategoriaCadModel(id: 11002 , idPai: 110 , descricao: "Emprestimo",icone:"money-03"),
      CategoriaCadModel(id: 11003 , idPai: 110 , descricao: "Titulo de Capitalização",icone:"money-02"),
      CategoriaCadModel(id: 11004 , idPai: 110 , descricao: "Consórcio",icone:"money-03"),
      CategoriaCadModel(id: 11005 , idPai: 110 , descricao: "Mensalidade Cartao de Crédito",icone:"televisao-01"),

      CategoriaCadModel(id: 12001 , idPai: 120 , descricao: "Condominio",icone:"predio-01"),
      CategoriaCadModel(id: 12002 , idPai: 120 , descricao: "Conta de luz",icone:"luz-01"),
      CategoriaCadModel(id: 12003 , idPai: 120 , descricao: "Conta de água",icone:"agua-01"),
      CategoriaCadModel(id: 12004 , idPai: 120 , descricao: "Conta de internet",icone:"arroba-01"),
      CategoriaCadModel(id: 12005 , idPai: 120 , descricao: "Plano telefônico",icone:"celular-01"),
      CategoriaCadModel(id: 12006 , idPai: 120 , descricao: "TV a cabo",icone:"televisao-01"),
    ];
  }
}