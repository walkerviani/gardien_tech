import 'package:flutter/material.dart';
import 'package:gardien_tech/presentation/viewmodels/problema_viewmodel.dart';
import 'package:provider/provider.dart';

class GerenciarProblemasScreen extends StatefulWidget {
  final int? problemaId;
  final int dispositivoId;
  final String? descricao;

  const GerenciarProblemasScreen({
    super.key,
    this.problemaId,
    required this.dispositivoId,
    this.descricao,
  });

  @override
  State<StatefulWidget> createState() => _GerenciarProblemasScreenState();
}

class _GerenciarProblemasScreenState extends State<GerenciarProblemasScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descricaoController;
  late final bool isEditing;

  @override
  void initState() {
    super.initState();
    isEditing = widget.problemaId != null;
    _descricaoController = TextEditingController(text: widget.descricao ?? '');
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if(!_formKey.currentState!.validate()){
      return; // Finaliza se tiver algum campo inválido no Form
    }
    final viewModel = context.read<ProblemaViewmodel>();
    final descricao = _descricaoController.text;
    final sucesso = await viewModel.salvar(id: widget.problemaId, idDispositivo: widget.dispositivoId, descricao: descricao);

    if(!mounted) return;

    if(sucesso) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage ?? 'Erro desconhecido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProblemaViewmodel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Problema' : 'Criar Problema'),
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
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _descricaoController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'A descrição não pode ser vazia';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descrição',
                      ),
                      minLines: 3,
                      maxLines: 5,
                      maxLength: 255,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
