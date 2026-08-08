enum TipoDispositivo {
  notebook(1, 'NOTEBOOK'),
  tablet(2, 'TABLET'),
  smartphone(3, 'SMARTPHONE'),
  mouse(4, 'MOUSE'),
  teclado(5, 'TECLADO'),
  headset(6, 'HEADSET/FONE'),
  caboHdmi(7, 'CABO HDMI'),
  adaptadorUsb(8, 'ADAPTADOR USB'),
  caixaDeSom(9, 'CAIXA DE SOM'),
  outro(10, 'OUTRO');

  final int id;
  final String nomeTipo;

  const TipoDispositivo(this.id, this.nomeTipo);
}
