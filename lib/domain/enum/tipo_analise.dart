import 'package:flutter/material.dart';

enum TipoAnalise {
  emprestimos('Empréstimos', Icons.swap_horiz),
  dispositivos('Dispositivos', Icons.devices),
  usuarios('Usuários', Icons.person);

  const TipoAnalise(this.rotulo, this.icone);
  final String rotulo;
  final IconData icone;
}
