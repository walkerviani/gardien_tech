class Usuario {
  // Atributos
  final int? _id;
  final int _idTipoCargo;
  String nome;

  // Construtor
  Usuario(this._id, this._idTipoCargo, this.nome);

  // Getters
  int? get id => _id;
  int get idCargo => _idCargo;
}