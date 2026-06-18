import 'package:flutter/material.dart';
import 'package:gardien_tech/presentation/viewmodels/cargo_viewmodel.dart';
import 'package:provider/provider.dart';

class GerenciarCargosScreen extends StatefulWidget {
  final int? cargoId;
  final String? cargoNome;

  const GerenciarCargosScreen({super.key, this.cargoId, this.cargoNome});

  @override
  State<StatefulWidget> createState() => _GerenciarCargosScreenState();
}

class _GerenciarCargosScreenState extends State<GerenciarCargosScreen> {
  late final TextEditingController _nomeController;
  late final bool isEditing;

  @override
  void initState() {
    super.initState();
    isEditing = widget.cargoId != null;
    _nomeController = TextEditingController(text: widget.cargoNome ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _salvar() async {
    final viewModel = context.read<CargoViewModel>();
    final nome = _nomeController.text;

    final sucesso = await viewModel.salvar(id: widget.cargoId, nome: nome);

    if (!mounted) return;

    if (sucesso) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage ?? 'Erro desconhecido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CargoViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Cargo' : 'Novo Cargo'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsGeometry.only(top: 10),
              child: TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsGeometry.only(top: 30),
              child: ElevatedButton(
                onPressed: viewModel.isLoading ? null : _salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: viewModel.isLoading
                    ? const CircularProgressIndicator(color:Color(0xFF2196F3))
                    : Text(
                        isEditing ? 'Atualizar' : 'Salvar',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
