class Usuario {
  // Atributos
  final int? _id;
  final int _idTipoCargo;
  String nome;

  // Construtor
  Usuario(this._id, this._idTipoCargo, this.nome);

  // Getters
  int? get id => _id;
  int get idTipoCargo => _idTipoCargo;

  // Json
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'idTipoCargo': _idTipoCargo,
      'nome': nome,
    };
  }
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      json['id'] as int?,
      json['idTipoCargo'] as int,
      json['nome'] as String,
    );
  }
}