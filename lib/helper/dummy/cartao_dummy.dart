class CartaoDummy{
  List get lista {
    return [
      {'id_conta':1,'id_cartao_tipo':3,'descricao':'debito','vl_saldo':null,'vl_limite':4500.0,'dia_fechamento':null ,'dia_vencimento':null },
      {'id_conta':1,'id_cartao_tipo':2,'descricao':'credito','vl_saldo':null,'vl_limite':7000.0,'dia_fechamento':25,'dia_vencimento':5 },
      {'id_conta':2,'id_cartao_tipo':2,'descricao':'credito','vl_saldo':null,'vl_limite':2500.0,'dia_fechamento':25,'dia_vencimento':5},
      {'id_conta':3,'id_cartao_tipo':3,'descricao':'debito','vl_saldo':10000.0,'vl_limite':null,'dia_fechamento':0,'dia_vencimento':0},
      {'id_conta':4,'id_cartao_tipo':5,'descricao':'vale fome','vl_saldo':3000.0,'vl_limite':null,'dia_fechamento':0,'dia_vencimento':0},
      {'id_conta':1,'id_cartao_tipo':4,'descricao':'poupanca moto','vl_saldo':3000,'vl_limite':null,'dia_fechamento':null,'dia_vencimento':null},
      {'id_conta':1,'id_cartao_tipo':2,'descricao':'credito','vl_saldo':0,'vl_limite':3000,'dia_fechamento':20,'dia_vencimento':10},
    ];
  }
}