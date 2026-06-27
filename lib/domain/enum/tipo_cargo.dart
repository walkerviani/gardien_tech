enum TipoCargo {
  professor(1, 'PROFESSOR'),
  aluno(2, 'ALUNO'),
  coordenacao(3, 'COORDENAÇÃO'),
  direcao(4, 'DIREÇÃO'),
  administracao(5, 'ADMINISTRAÇÃO'),
  apoioPedagogico(6, 'APOIO PEDAGÓGICO')
  outro(7, 'OUTRO');

  final int id;
  final String nomeCargo;

  const TipoCargo(this.id, this.nomeCargo);
}