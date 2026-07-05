import 'package:flutter/material.dart';
import 'package:gardien_tech/presentation/views/dispositivos_screen.dart';
import 'package:gardien_tech/presentation/views/problemas_ativos_screen.dart';
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
              backgroundColor: const Color(0xFF006dc4),
              foregroundColor: const Color(0xFFFFFFFF),
              minimumSize: const Size(double.infinity, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.person, size: 30),
                SizedBox(width: 20),
                Text('Gerenciar usuários', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          /*
          Botão de gerenciamento dos dispositivos
           */
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => DispositivosScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006dc4),
              foregroundColor: const Color(0xFFFFFFFF),
              minimumSize: const Size(double.infinity, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.devices, size: 30),
                SizedBox(width: 20),
                Text('Gerenciar dispositivos', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          /*
          Botão de visualizar problemas relatados
           */
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProblemasAtivosScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006dc4),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.report_problem, size: 30),
                SizedBox(width: 20),
                Text('Dispositivos com problemas', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          /*
          Botão de exportar relatórios
          */
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006dc4),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf, size: 30),
                SizedBox(width: 20),
                Text('Exportar relatórios', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
