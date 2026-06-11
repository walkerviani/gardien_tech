class Emprestimo {
  // Atributos
  final int _id;
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
    this.idStatus = 1,
  }) : dataHoraEfetuado = dataHoraEfetuado ?? DateTime.now(); // initializer list — executa atribuições antes do corpo do construtor
    
  // Getters
  int get id => _id;
  int get idResponsavel => _idResponsavel;
}