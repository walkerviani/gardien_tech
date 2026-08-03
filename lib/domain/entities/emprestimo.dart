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
      'dataHoraEfetuado': dataHoraEfetuado,
      'dataHoraConcluido': dataHoraConcluido,
      'idResponsavel': _idResponsavel,
      'idStatus': idStatus,
    };
  }
  factory Emprestimo.fromJson(Map<String, dynamic> json) {
    return Emprestimo(
      json['id'] as int?,
      dataHoraEfetuado: json['dataHoraEfetuado'] as DateTime,
      dataHoraConcluido: json['dataHoraConcluido'] as DateTime?,
      json['idResponsavel'] as int,
      idStatus: json['idStatus'] as int,
    );
  }
}