enum StatusEmprestimo {
  ativo(1, 'ATIVO'),
  emObservacao(2, 'EM_OBSERVACAO'), // Caso os dispositivos tenham sido devolvidos sem ter marcado como concluído
  concluido(3, 'CONCLUIDO');

  final int id;
  final String nomeStatus;

  const StatusEmprestimo(this.id, this.nomeStatus);
}