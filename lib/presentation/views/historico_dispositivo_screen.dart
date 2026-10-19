import 'package:flutter/material.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';

class HistoricoDispositivoScreen extends StatefulWidget {
  final int idDispositivo;

  const HistoricoDispositivoScreen(this.idDispositivo, {super.key});

  @override
  State<StatefulWidget> createState() => _HistoricoDispositivoScreenState();
}

class _HistoricoDispositivoScreenState
    extends State<HistoricoDispositivoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico do dispositivo'),
        backgroundColor: CoresGardien.azulClaro,
        foregroundColor: CoresGardien.branco,
      ),
      body: Container(),
    );
  }
}
