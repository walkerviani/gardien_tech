import 'package:flutter/material.dart';
import 'package:gardien_tech/presentation/views/ajuda_card_screen.dart';
import 'package:gardien_tech/presentation/views/ajuda_tipo_emprestimo_screen.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';

class AjudaListScreen extends StatelessWidget {
  const AjudaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda e informações'),
        backgroundColor: CoresGardien.azulClaro,
        foregroundColor: CoresGardien.branco,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AjudaCardScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresGardien.azulEscuro,
                foregroundColor: CoresGardien.branco,
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.palette, size: 30),
                  SizedBox(width: 20),
                  Text('Cor do cartão', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AjudaTipoEmprestimoScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresGardien.azulEscuro,
                foregroundColor: CoresGardien.branco,
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.list_alt, size: 30),
                  SizedBox(width: 20),
                  Text('Tipo de empréstimo', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
