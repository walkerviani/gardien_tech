class EmprestimoItem {
  // Atributos
  final int? _id;
  final int _idEmprestimo;
  final int _idTipoDispositivo;
  int qtdSolicitada;
  int qtdDevolvida;
  bool estaResolvido; // estaResolvido rastreia se o EmprestimoItem tem todos os dispositivos necessários já vinculados

  // Construtor
  EmprestimoItem(
    this._id,
    this._idEmprestimo,
    this._idTipoDispositivo,
    this.qtdSolicitada,
    {this.qtdDevolvida = 0, this.estaResolvido = false}
  );

  // Getters
  int? get id => _id;
  int get idEmprestimo => _idEmprestimo;
  int get idTipoDispositivo => _idTipoDispositivo;

  // Json
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'idEmprestimo': _idEmprestimo,
      'idTipoDispositivo': _idTipoDispositivo,
      'qtdSolicitada': qtdSolicitada,
      'qtdDevolvida': qtdDevolvida,
      'estaResolvido': estaResolvido,
    };
  }
  factory EmprestimoItem.fromJson(Map<String, dynamic> json) {
    return EmprestimoItem(
      json['id'] as int?,
      json['idEmprestimo'] as int,
      json['idTipoDispositivo'] as int,
      json['qtdSolicitada'] as int,
      qtdDevolvida: json['qtdDevolvida'] as int,
      estaResolvido: json['estaResolvido'] as bool,
    );
  }
}