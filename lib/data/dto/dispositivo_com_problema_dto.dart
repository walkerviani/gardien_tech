class DispositivoComProblemaDTO {
  int idProblema;
  int idDispositivo;
  String descricao;
  int idTipoDispositivo;
  String numSerie;
  String numPatrimonio;

  DispositivoComProblemaDTO({
    required this.idProblema,
    required this.idDispositivo,
    required this.descricao,
    required this.idTipoDispositivo,
    required this.numPatrimonio,
    required this.numSerie
  });
}