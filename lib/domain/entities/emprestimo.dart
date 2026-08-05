class Emprestimo {
  // Atributos
  final int? _id;
  DateTime dataHoraEfetuado;
  DateTime? dataHoraConcluido;
  final int _idResponsavel; 
  int idStatus;

  // Construtor
  Emprestimo(
    this._id,
    this._idResponsavel,
    {DateTime? dataHoraEfetuado,
    this.dataHoraConcluido, // nullable, pois a conclusão pode não ter ocorrido ainda
    this.idStatus = 1, // 1 - Ativo
  }) : dataHoraEfetuado = dataHoraEfetuado ?? DateTime.now(); // initializer list — executa atribuições antes do corpo do construtor
    
  // Getters
  int? get id => _id;
  int get idResponsavel => _idResponsavel;

  // Json
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'dataHoraEfetuado': dataHoraEfetuado.toIso8601String(),
      'dataHoraConcluido': dataHoraConcluido?.toIso8601String(),
      'idResponsavel': _idResponsavel,
      'idStatus': idStatus,
    };
  }
  factory Emprestimo.fromJson(Map<String, dynamic> json) {
    return Emprestimo(
      json['id'] as int?,
      json['idResponsavel'] as int,
      dataHoraEfetuado: DateTime.parse(json['dataHoraEfetuado'] as String),
      dataHoraConcluido: json['dataHoraConcluido'] == null
          ? null
          : DateTime.parse(json['dataHoraConcluido'] as String),
      idStatus: json['idStatus'] as int,
    );
  }
}