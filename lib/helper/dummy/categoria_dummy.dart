import 'package:me_poupe/model/cad/cad_categoria_model.dart';

class CategoriaDummy{
  List<CategoriaCadModel> get lista {
    return [
      CategoriaCadModel(id: 1 , idPai: 0 , descricao: "",icone: 'ajuda-01' ,order: 0),
      CategoriaCadModel(id: 10 , idPai: 0 , descricao: "Alimentação",icone: 'alimentar-01' ,order: 10),
      CategoriaCadModel(id: 20 , idPai: 0 , descricao: "Saúde e Higiene",icone: 'saude-pasta-01',order: 20),
      CategoriaCadModel(id: 30 , idPai: 0 , descricao: "Lazer",icone: 'lazer-01',order: 30),
      CategoriaCadModel(id: 40 , idPai: 0 , descricao: "Compras",icone: 'comprar-01',order: 40),
      CategoriaCadModel(id: 50 , idPai: 0 , descricao: "Casa",icone: 'home-01',order: 50),
      CategoriaCadModel(id: 60 , idPai: 0 , descricao: "Educação",icone: 'school-01' ,order: 60),
      CategoriaCadModel(id: 70 , idPai: 0 , descricao: "Transporte",icone:'transporte',order: 70),
      CategoriaCadModel(id: 80 , idPai: 0 , descricao: "Trabalho e Serviços",icone: 'trabalhar-01',order: 80),
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
      CategoriaCadModel(id: 1008 , idPai: 10 , descricao: "Açougue",icone: 'acouge-01'),
      CategoriaCadModel(id: 1009 , idPai: 10 , descricao: "Feira",icone: 'feira-01'),

      //SAUDE
      CategoriaCadModel(id: 2001 , idPai: 20 , descricao: "Remédio",icone:"saude-remedio-02"),
      CategoriaCadModel(id: 2002 , idPai: 20 , descricao: "Consulta",icone:"saude-pessoa-01"),
      CategoriaCadModel(id: 2003 , idPai: 20 , descricao: "Exame",icone:"saude-03"),
      CategoriaCadModel(id: 2004 , idPai: 20 , descricao: "Cabelereiro",icone:"cabelereiro-01"),
      CategoriaCadModel(id: 2005 , idPai: 20 , descricao: "Dentista",icone:"dentista-01"),
      CategoriaCadModel(id: 2006 , idPai: 20 , descricao: "Podologa",icone:"podologa-01"),

      //LAZER
      CategoriaCadModel(id: 3001 , idPai: 30 , descricao: "Esportes",icone:"esporte-futebol-01"),
      CategoriaCadModel(id: 3002 , idPai: 30 , descricao: "Academia",icone:"esporte-academia-pessoa-01"),
      CategoriaCadModel(id: 3003 , idPai: 30 , descricao: "Viagem",icone:"mala-01"),
      CategoriaCadModel(id: 3004 , idPai: 30 , descricao: "Piscina",icone:"piscina-01"),
      CategoriaCadModel(id: 3005 , idPai: 50 , descricao: "Eletronicos - Lazer",icone:"eletro-generico-01"),
      CategoriaCadModel(id: 3006 , idPai: 50 , descricao: "Tatoo",icone:"eletro-generico-01"),
      CategoriaCadModel(id: 3007 , idPai: 50 , descricao: "Parque de diversões",icone:"parque-diversoes-01"),
      CategoriaCadModel(id: 3008 , idPai: 50 , descricao: "Cinema",icone:"cinema-01"),
      CategoriaCadModel(id: 3009 , idPai: 50 , descricao: "Teatro",icone:"teatro-01"),

      // COMPRAS
      CategoriaCadModel(id: 4001 , idPai: 40 , descricao: "Roupas",icone:"roupa-01"),
      CategoriaCadModel(id: 4002 , idPai: 40 , descricao: "Pets",icone:"pets-01"),
      CategoriaCadModel(id: 4003 , idPai: 40 , descricao: "Presente",icone:"presente-aniver-01"),
      CategoriaCadModel(id: 4003 , idPai: 40 , descricao: "Presente Aniversário",icone:"presente-01"),

      //CASA
      CategoriaCadModel(id: 5001 , idPai: 50 , descricao: "Decoração",icone:"home-03"),
      CategoriaCadModel(id: 5002 , idPai: 50 , descricao: "Móveis",icone:"casa-moveis-01"),
      CategoriaCadModel(id: 5003 , idPai: 50 , descricao: "Artigos p/banho",icone:"casa-banheiro-01"),
      CategoriaCadModel(id: 5004 , idPai: 50 , descricao: "Eletrodoméstico",icone:"eletro-01"),
      CategoriaCadModel(id: 5005 , idPai: 50 , descricao: "Peças encanamento",icone:"eletro-01"),
      CategoriaCadModel(id: 5006 , idPai: 50 , descricao: "Peças hidraulica",icone:"eletro-01"),
      CategoriaCadModel(id: 5007 , idPai: 50 , descricao: "Torneira",icone:"torneira-01"),
      CategoriaCadModel(id: 5008 , idPai: 50 , descricao: "Material construção",icone:"material-construcao-01"),
      CategoriaCadModel(id: 5009 , idPai: 50 , descricao: "Ventilador",icone:"ventilador-01"),
      CategoriaCadModel(id: 5010 , idPai: 50 , descricao: "Eletronicos - Casa",icone:"eletro-generico-01"),

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
      CategoriaCadModel(id: 7007 , idPai: 70 , descricao: "Pedagio",icone:"pedagio-01"),
      CategoriaCadModel(id: 7008 , idPai: 70 , descricao: "Aluguel de carro",icone:"pedagio-01"),
      CategoriaCadModel(id: 7009 , idPai: 70 , descricao: "Venda de carro",icone:"pedagio-01"),	  
      CategoriaCadModel(id: 7010 , idPai: 70 , descricao: "troca de oleo",icone:"pedagio-01"),
      CategoriaCadModel(id: 7011 , idPai: 70 , descricao: "oficina mecanica",icone:"pedagio-01"),
      CategoriaCadModel(id: 7012 , idPai: 70 , descricao: "chapista",icone:"seguradora-01"),

      // TRABALHO
      CategoriaCadModel(id: 8001 , idPai: 80 , descricao: "Material de escritório",icone:"escritorio-01"),
      CategoriaCadModel(id: 8002 , idPai: 80 , descricao: "Material de informatica",icone:"notebook-01"),
      CategoriaCadModel(id: 8003 , idPai: 80 , descricao: "Servicoes gerais",icone:"servicos-01"),

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
      CategoriaCadModel(id: 11005 , idPai: 110 , descricao: "Fatura Cartao de Crédito",icone:"televisao-01"),
      CategoriaCadModel(id: 11006 , idPai: 110 , descricao: "Mensalidade Cartao de Crédito",icone:"televisao-01"),
      CategoriaCadModel(id: 11007 , idPai: 110 , descricao: "Aluguel",icone:"home-01"),
      CategoriaCadModel(id: 11008 , idPai: 110 , descricao: "Despesa em cartório",icone:"home-01"),

      // CONTAS FIXAS
      CategoriaCadModel(id: 12001 , idPai: 120 , descricao: "Condominio",icone:"predio-01"),
      CategoriaCadModel(id: 12002 , idPai: 120 , descricao: "Conta de luz",icone:"luz-01"),
      CategoriaCadModel(id: 12003 , idPai: 120 , descricao: "Conta de água",icone:"agua-01"),
      CategoriaCadModel(id: 12004 , idPai: 120 , descricao: "Conta de internet",icone:"arroba-01"),
      CategoriaCadModel(id: 12005 , idPai: 120 , descricao: "Plano telefônico",icone:"celular-01"),
      CategoriaCadModel(id: 12006 , idPai: 120 , descricao: "TV a cabo",icone:"televisao-01"),
      CategoriaCadModel(id: 12007 , idPai: 120 , descricao: "Seguro de vida",icone:"seguradora-01"),
      CategoriaCadModel(id: 12008 , idPai: 120 , descricao: "Seguro residencial",icone:"seguradora-01"),
      CategoriaCadModel(id: 12009 , idPai: 120 , descricao: "Seguro automotivo",icone:"seguradora-01"),
    ];
  }
}