class Dispositivo {
  // Atributos
  final int _id;
  final int _idTipoDispositivo; // Não irá mudar o tipo do dispositivo
  int numSerie;
  int numPatrimonio;  
  int idStatus;
  int qtdTotal; 
  int qtdDisponivel;

  // Construtor
  Dispositivo(
    this._id,
    this._idTipoDispositivo,
    this.numSerie,
    this.numPatrimonio,
    this.qtdTotal,
    this.qtdDisponivel,
    {this.idStatus = 1
  });

  // Getters
  int get id => _id;
  int get idTipoDispositivo => _idTipoDispositivo;
}