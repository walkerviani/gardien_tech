enum EmprestimoStatus {
  ativo(1, 'ATIVO'),
  emObservacao(
    2,
    'EM OBSERVAÇÃO',
  ), // Caso os dispositivos tenham sido devolvidos sem ter marcado como concluído
  concluido(3, 'CONCLUÍDO');

  final int id;
  final String nomeStatus;

  const EmprestimoStatus(this.id, this.nomeStatus);
}
