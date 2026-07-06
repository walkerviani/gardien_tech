import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/enum/tipo_cargo.dart';
import 'package:gardien_tech/presentation/viewmodels/gerenciar_usuario_viewmodel.dart';
import 'package:provider/provider.dart';

class GerenciarUsuarioScreen extends StatefulWidget {
  final int? usuarioId;
  final String? usuarioNome;
  final int? usuarioidTipoCargo;

  const GerenciarUsuarioScreen({
    super.key,
    this.usuarioidTipoCargo,
    this.usuarioId,
    this.usuarioNome,
  });

  @override
  State<StatefulWidget> createState() => _GerenciarUsuarioScreenState();
}

class _GerenciarUsuarioScreenState extends State<GerenciarUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final bool isEditing;
  TipoCargo? _cargoSelecionado;

  @override
  void initState() {
    super.initState();
    isEditing = widget.usuarioId != null;
    _nomeController = TextEditingController(text: widget.usuarioNome ?? '');

    if (isEditing && widget.usuarioidTipoCargo != null) {
      _cargoSelecionado = TipoCargo.values
          .where((cargo) => cargo.id == widget.usuarioidTipoCargo)
          .firstOrNull;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return; // Finaliza se tiver algum campo inválido no Form
    }
    final viewModel = context.read<GerenciarUsuarioViewmodel>();
    final nome = _nomeController.text.trim().toUpperCase();
    final sucesso = await viewModel.salvar(
      id: widget.usuarioId,
      nome: nome,
      idTipoCargo: _cargoSelecionado!.id,
    );
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
    final viewModel = context.watch<GerenciarUsuarioViewmodel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar usuário' : 'Criar usuário'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),

                /*
                Campo do nome
                */

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
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,

                  /* 
                  DropdownMenu do cargo
                  */

                  child: DropdownMenuFormField<TipoCargo>(
                    label: const Text('Cargo'),
                    menuHeight: 200,
                    validator: (cargo) {
                      if (cargo == null) {
                        return 'Selecione um cargo';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    initialSelection: _cargoSelecionado,
                    dropdownMenuEntries: TipoCargo.values.map((cargo) {
                      return DropdownMenuEntry(
                        value: cargo,
                        label: cargo.nomeCargo,
                      );
                    }).toList(),
                    onSelected: (cargo) {
                      setState(() => _cargoSelecionado = cargo);
                    },
                    onSaved: (cargo) {
                      _cargoSelecionado = cargo;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,

                /* 
                Botão de Salvar
                */

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
                          color: Color(0xFF4CAF50),
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
