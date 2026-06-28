import 'package:flutter/material.dart';

class DispositivoProblemaScreen extends StatefulWidget{
  final int? idDispositivo;

  const DispositivoProblemaScreen({super.key, this.idDispositivo});

  @override
  State<StatefulWidget> createState() => _DispositivoProblemaScreenState();
}

class _DispositivoProblemaScreenState extends State<DispositivoProblemaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problemas'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
    );
  }
}