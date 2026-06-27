import 'package:flutter/material.dart';
import 'package:gardien_tech/presentation/views/usuarios_screen.dart';

class FuncoesScreen extends StatelessWidget {
  const FuncoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),

      child: Column(
        children: [
          /*
          Botão de gerenciamento dos usuários
           */
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UsuariosScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.person, size: 30),
                SizedBox(width: 20),
                Text('Gerenciar Usuários', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          /*
          Botão 2
           */
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text('Botão 3'),
          ),
          const SizedBox(height: 10),
          /*
          Botão 3
           */
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text('Botão 3'),
          ),
        ],
      ),
    );
  }
}
