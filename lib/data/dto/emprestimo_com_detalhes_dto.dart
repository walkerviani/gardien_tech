class EmprestimoComDetalhesDTO {
  int idEmprestimo;
  int idUsuario;
  int idEmprestimoItem;
  int idTipoCargo;
  int idStatusEmprestimo;
  int qtdSolicitada;
  DateTime dataHoraEfetuado;
  String nomeUsuario;

  EmprestimoComDetalhesDTO({
    required this.idEmprestimo,
    required this.idUsuario,
    required this.idEmprestimoItem,
    required this.idTipoCargo,
    required this.idStatusEmprestimo,
    required this.qtdSolicitada,
    required this.dataHoraEfetuado,
    required this.nomeUsuario,
  });
}
