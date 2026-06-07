enum Tipo {
  notebook(1, 'NOTEBOOK'),
  tablet(2, 'TABLET');

  final int id;
  final String nomeTipo;

  const Tipo(this.id, this.nomeTipo);
}