class Dispositivo {
  // Atributos
  final int? _id;
  final int _idTipoDispositivo; // Não irá mudar o tipo do dispositivo
  String numSerie;
  String numPatrimonio;  
  int idStatus;

  // Construtor
  Dispositivo(
    this._id,
    this._idTipoDispositivo,
    this.numSerie,
    this.numPatrimonio,
    {this.idStatus = 1} // 1 - Disponível
  );

  // Getters
  int? get id => _id;
  int get idTipoDispositivo => _idTipoDispositivo;
}