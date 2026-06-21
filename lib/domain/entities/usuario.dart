class Usuario {
  // Atributos
  final int? _id;
  final int _idCargo;
  String nome;

  // Construtor
  Usuario(this._id, this._idCargo, this.nome);

  // Getters
  int? get id => _id;
  int get idCargo => _idCargo;
}