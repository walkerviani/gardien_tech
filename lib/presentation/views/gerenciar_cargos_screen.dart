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
  final _formKey = GlobalKey<FormState>();
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
    if (!_formKey.currentState!.validate()) {
      return; // Finaliza se tiver algum campo inválido no TextFormField
    }
    final viewModel = context.read<CargoViewModel>();
    final nome = _nomeController.text.trim().toUpperCase();
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
        foregroundColor: const Color(0xFFFFFFFF),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsGeometry.only(top: 10),
                child: TextFormField(
                  controller: _nomeController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'O nome é obrigatório';
                    }
                    return null;
                  },
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
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: const Color(0xFFFFFFFF),
                    minimumSize: const Size(double.infinity, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator(
                          color: Color(0xFF2196F3),
                        )
                      : Text(
                          isEditing ? 'Atualizar' : 'Salvar',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
