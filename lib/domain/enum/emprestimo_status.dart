enum EmprestimoStatus {
  ativo(1, 'ATIVO'),
  emObservacao(
    2,
    'EM OBSERVAÇÃO',
  ), // Caso os dispositivos tenham sido devolvidos sem ter marcado como concluído
  concluido(3, 'CONCLUÍDO'),
  semCorrespondencia(
    4,
    'SEM CORRESPONDÊNCIA',
  ); // Quando não há mais a possibilidade de conseguir o vinculo dos dispositivos

  final int id;
  final String nomeStatus;

  const EmprestimoStatus(this.id, this.nomeStatus);
}
