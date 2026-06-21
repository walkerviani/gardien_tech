class EmprestimoItem {
  // Atributos
  final int? _id;
  final int _idEmprestimo;
  final int _idTipoDispositivo;
  int qtdSolicitada;
  int qtdDevolvida;
  bool estaResolvido;
  bool ehQuantitativo; // true -> quantitativo; false -> qualitativo

  // Construtor
  EmprestimoItem(
    this._id,
    this._idEmprestimo,
    this._idTipoDispositivo,
    this.qtdSolicitada,
    this.ehQuantitativo,
    {this.qtdDevolvida = 0,
    this.estaResolvido = false
  });

  // Getters
  int? get id => _id;
  int get idEmprestimo => _idEmprestimo;
  int get idTipoDispositivo => _idTipoDispositivo;
}