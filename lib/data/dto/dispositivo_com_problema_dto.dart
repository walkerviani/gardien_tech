class DispositivoComProblemaDto {
  int idProblema;
  int idDispositivo;
  String descricao;
  int idTipoDispositivo;
  String numSerie;
  String numPatrimonio;

  DispositivoComProblemaDto({
    required this.idProblema,
    required this.idDispositivo,
    required this.descricao,
    required this.idTipoDispositivo,
    required this.numPatrimonio,
    required this.numSerie
  });
}