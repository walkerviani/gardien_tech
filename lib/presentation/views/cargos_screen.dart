import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/repositories/cargo_repository.dart';
import 'package:gardien_tech/presentation/viewmodels/cargo_viewmodel.dart';
import 'package:gardien_tech/presentation/views/gerenciar_cargos_screen.dart';
import 'package:provider/provider.dart';

class CargosScreen extends StatefulWidget {
  const CargosScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CargosScreenState();
}

class _CargosScreenState extends State<CargosScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CargoViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargos'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final viewModel = context.read<CargoViewModel>();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                      create: (context) =>
                          CargoViewModel(context.read<CargoRepository>()),
                      child: const GerenciarCargosScreen(),
                    ),
                  ),
                );
                if (!mounted) return;
                viewModel.carregarCargos();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.add, size: 30),
                  SizedBox(width: 20),
                  Text('Adicionar Novo Cargo', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.cargos.isEmpty
                  ? const Center(child: Text('Nenhum cargo encontrado'))
                  : ListView.builder(
                      itemCount: viewModel.cargos.length,
                      itemBuilder: (context, index) {
                        final cargo = viewModel.cargos[index];
                        return Card(
                          child: ListTile(title: Text(cargo.nomeCargo)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
