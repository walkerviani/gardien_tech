enum Status {
  pendente(1, 'PENDENTE'),
  emObservacao(2, 'EM_OBSERVACAO'),
  concluido(3, 'CONCLUIDO');

  final int id;
  final String nomeStatus;

  const Status(this.id, this.nomeStatus);
}