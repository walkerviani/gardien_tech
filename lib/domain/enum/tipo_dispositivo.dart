enum TipoDispositivo {
  notebook(1, 'NOTEBOOK'),
  tablet(2, 'TABLET'),
  smartphone(3, 'SMARTPHONE'),
  mouse(4, 'MOUSE'),
  teclado(5, 'TECLADO'),
  monitor(6, 'MONITOR'),
  projetor(7, 'PROJETOR'),
  webcam(8, 'WEBCAM'),
  headset(9, 'HEADSET'),
  caboHdmi(10, 'CABO HDMI'),
  adaptadorUsb(11, 'ADAPTADOR USB'),
  roteador(12, 'ROTEADOR'),
  switch_(13, 'SWITCH'),
  impressora(14, 'IMPRESSORA'),
  caixaDeSom(15, 'CAIXA DE SOM'),
  outro(16, 'OUTRO');

  final int id;
  final String nomeTipo;

  const TipoDispositivo(this.id, this.nomeTipo);
}