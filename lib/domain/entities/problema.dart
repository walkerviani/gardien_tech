class Problema {
  // Atributos
  final int _id;
  final int _idDispositivo;
  String descricao;

  // Construtor
  Problema(this._id, this._idDispositivo, this.descricao);

  // Getters
  int get id => _id;
  int get idDispositivo => _idDispositivo;
}