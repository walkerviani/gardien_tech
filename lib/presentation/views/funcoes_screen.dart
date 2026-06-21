import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/repositories/cargo_repository.dart';
import 'package:gardien_tech/presentation/viewmodels/cargo_viewmodel.dart';
import 'package:gardien_tech/presentation/views/cargos_screen.dart';
import 'package:gardien_tech/presentation/views/usuarios_screen.dart';
import 'package:provider/provider.dart';

class FuncoesScreen extends StatelessWidget {
  const FuncoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),

      child: Column(
        children: [
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
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (context) =>
                        CargoViewModel(context.read<CargoRepository>())
                          ..carregarCargos(),
                    child: const CargosScreen(),
                  ),
                ),
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
                Icon(Icons.work, size: 30),
                SizedBox(width: 20),
                Text('Gerenciar Cargos', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),

          const SizedBox(height: 10),

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
            child: Text('Botão 4'),
          ),
        ],
      ),
    );
  }
}
