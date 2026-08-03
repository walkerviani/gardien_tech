class EmprestimoDispositivo {
  // Atributos
  final int? _id;
  final int _idEmprestimoItem;
  int? idDispositivo; // O dispositivo pode ser vinculado posteriormente, então o id deve ser nullable e mutável

  // Construtor
  EmprestimoDispositivo(
    this._id,
    this._idEmprestimoItem,
    {this.idDispositivo
  });

  // Getters
  int? get id => _id;
  int get idEmprestimoItem => _idEmprestimoItem;
  int? get idDisp => idDispositivo;

  // Json
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'idEmprestimoItem': _idEmprestimoItem,
      'idDispositivo': idDispositivo,
    };
  }
  factory EmprestimoDispositivo.fromJson(Map<String, dynamic> json) {
    return EmprestimoDispositivo(
      json['id'] as int?,
      json['idEmprestimoItem'] as int,
      idDispositivo: json['idDispositivo'] as int?,
    );
  }
}