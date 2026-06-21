import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/entities/cargo.dart';
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
  void _abrirFormulario({Cargo? cargo}) async {
    final viewModel = context.read<CargoViewModel>();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (context) => CargoViewModel(context.read<CargoRepository>()),
          child: GerenciarCargosScreen(
            cargoId: cargo?.id,
            cargoNome: cargo?.nomeCargo,
          ),
        ),
      ),
    );
    if (!mounted) return;
    viewModel.carregarCargos();
  }

  void _confirmarExcluir(Cargo cargo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Cargo'),
        content: Text('Deseja excluir o cargo "${cargo.nomeCargo}"?'),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF2196F3)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final viewModel = context.read<CargoViewModel>();
              final sucesso = await viewModel.deletar(cargo.id!);
              if (!mounted) return;
              if (sucesso) {
                viewModel.carregarCargos();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(viewModel.errorMessage ?? 'Erro ao excluir'),
                  ),
                );
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargos'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _abrirFormulario(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: const Color(0xFFFFFFFF),
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add, size: 30),
                  const SizedBox(width: 20),
                  const Text('Adicionar Novo Cargo', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<CargoViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.cargos.isEmpty) {
                    return const Center(child: Text('Nenhum cargo encontrado'));
                  }
                  return ListView.builder(
                    itemCount: viewModel.cargos.length,
                    itemBuilder: (context, index) {
                      final cargo = viewModel.cargos[index];
                      return Card(
                        key: ValueKey(cargo.id),
                        child: ListTile(
                          title: Text(cargo.nomeCargo),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _abrirFormulario(cargo: cargo),
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () => _confirmarExcluir(cargo),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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