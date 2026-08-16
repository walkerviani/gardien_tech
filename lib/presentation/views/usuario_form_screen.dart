import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/enum/tipo_cargo.dart';
import 'package:gardien_tech/presentation/viewmodels/usuario_form_viewmodel.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';
import 'package:provider/provider.dart';

class UsuarioFormScreen extends StatefulWidget {
  final int? usuarioId;
  final String? usuarioNome;
  final int? usuarioidTipoCargo;

  const UsuarioFormScreen({
    super.key,
    this.usuarioidTipoCargo,
    this.usuarioId,
    this.usuarioNome,
  });

  @override
  State<StatefulWidget> createState() => _UsuarioFormScreenState();
}

class _UsuarioFormScreenState extends State<UsuarioFormScreen> {
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

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return; // Finaliza se tiver algum campo inválido no Form
    }
    final viewModel = context.read<UsuarioFormViewmodel>();
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
        SnackBar(
          content: Text(viewModel.errorMessage ?? 'Erro desconhecido'),
          backgroundColor: CoresGardien.vermelhoClaro,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UsuarioFormViewmodel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar usuário' : 'Criar usuário'),
        backgroundColor: CoresGardien.azulClaro,
        foregroundColor: CoresGardien.branco,
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
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'O nome é obrigatório';
                    }

                    final nome = value.trim();

                    if (nome.length > 50) {
                      return 'O nome só pode ter até 50 caracteres';
                    }

                    if (nome.length < 3) {
                      return 'O nome precisa ser maior que 3 caracteres';
                    }

                    // Permite apenas letras (com ou sem acento), espaços, hífen e apóstrofo.
                    final regex = RegExp(r"^[a-zA-ZÀ-ÿ\s'-]+$");
                    if (!regex.hasMatch(nome)) {
                      return 'Apenas letras e espaços';
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
                    backgroundColor: CoresGardien.verdeClaro,
                    foregroundColor: CoresGardien.branco,
                    minimumSize: const Size(double.infinity, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator(
                          color: CoresGardien.verdeClaro,
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

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }
}
