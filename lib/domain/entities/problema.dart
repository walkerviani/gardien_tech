class Problema {
  // Atributos
  final int? _id;
  final int _idDispositivo;
  String descricao;

  // Construtor
  Problema(this._id, this._idDispositivo, this.descricao);

  // Getters
  int? get id => _id;
  int get idDispositivo => _idDispositivo;

  // Json
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'idDispositivo': _idDispositivo,
      'descricao': descricao,
    };
  }
  factory Problema.fromJson(Map<String, dynamic> json) {
    return Problema(
      json['id'] as int?,
      json['idDispositivo'] as int,
      json['descricao'] as String,
    );
  }
}