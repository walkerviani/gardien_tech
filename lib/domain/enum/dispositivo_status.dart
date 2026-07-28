enum DispositivoStatus {
  disponivel(1, 'DISPONÍVEL'),
  indisponivel(2, 'INDISPONÍVEL'), // Caso dispositivo esteja quebrado ou algo do tipo
  emUso(3, 'EM USO');

  final int id;
  final String nomeStatus;

  const DispositivoStatus(this.id, this.nomeStatus);
}