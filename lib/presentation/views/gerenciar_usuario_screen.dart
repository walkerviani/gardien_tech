import 'package:flutter/material.dart';

class GerenciarUsuarioScreen extends StatefulWidget {
  const GerenciarUsuarioScreen({super.key});

  @override
  State<StatefulWidget> createState() => _GerenciarUsuarioScreenState();
}

class _GerenciarUsuarioScreenState extends State<GerenciarUsuarioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Usuário'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome',
              ),
            ),
            Align(
              alignment: AlignmentGeometry.topLeft,
              child: TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  
                ),
                child: const Text('Selecione o cargo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
