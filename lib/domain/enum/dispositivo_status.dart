enum DispositivoStatus {
  disponivel(1, 'DISPONIVEL'),
  indisponivel(2, 'INDISPONIVEL'), // Caso dispositivo esteja quebrado ou algo do tipo
  emUso(3, 'EM_USO');

  final int id;
  final String nomeStatus;

  const DispositivoStatus(this.id, this.nomeStatus);
}