import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:gardien_tech/presentation/viewmodels/dispositivo_viewmodel.dart';
import 'package:provider/provider.dart';

class GerenciarDispositivosScreen extends StatefulWidget {
  final int? dispositivoId;
  final int? idTipoDispositivo;
  final String? numSerie;
  final String? numPatrimonio;

  const GerenciarDispositivosScreen({
    super.key,
    this.dispositivoId,
    this.idTipoDispositivo,
    this.numSerie,
    this.numPatrimonio,
  });

  @override
  State<StatefulWidget> createState() => _GerenciarDispositivosScreenState();
}

class _GerenciarDispositivosScreenState
    extends State<GerenciarDispositivosScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _numSerieController;
  late final TextEditingController _numPatrimonioController;
  late final bool isEditing;
  TipoDispositivo? _tipoSelecionado;

  @override
  void initState() {
    super.initState();
    isEditing = widget.dispositivoId != null;
    _numSerieController = TextEditingController(text: widget.numSerie ?? '');
    _numPatrimonioController = TextEditingController(
      text: widget.numPatrimonio ?? '',
    );

    if (isEditing && widget.idTipoDispositivo != null) {
      _tipoSelecionado = TipoDispositivo.values
          .where((tipoDisp) => tipoDisp.id == widget.idTipoDispositivo)
          .firstOrNull;
    }
  }

  @override
  void dispose() {
    _numSerieController.dispose();
    _numPatrimonioController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return; // Finaliza se tiver algum campo inválido no Form
    }
    final viewModel = context.read<DispositivoViewmodel>();
    final numSerie = _numSerieController.text.trim();
    final numPatrimonio = _numPatrimonioController.text.trim();
    final sucesso = await viewModel.salvar(
      id: widget.dispositivoId,
      numSerie: numSerie,
      numPatrimonio: numPatrimonio,
      idTipoDispositivo: _tipoSelecionado!.id,
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
    final viewModel = context.watch<DispositivoViewmodel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Dispositivo' : 'Criar Dispositivo'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /*
              Campo do número de série
              */
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _numSerieController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'O número de série é obrigatório';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Número de Série',
                        ),
                      ),
                    ),
                    /*
                    Dica do que é o número de patrimônio
                    */
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Número de Série'),
                            content: const Text(
                              'Código único gravado pelo fabricante que identifica o equipamento.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Entendi',
                                  style: TextStyle(color: Color(0xFF000000)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.help_outline),
                    ),
                  ],
                ),
              ),
              /*
              Campo do número de patrimônio
              */
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _numPatrimonioController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'O número de patrimônio é obrigatório';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Número de Patrimônio',
                        ),
                      ),
                    ),
                    /*
                    Dica do que é o número de patrimônio
                    */
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Número de Patrimônio'),
                            content: const Text(
                              'Número de identificação único do bem patrimonial da organização. Geralmente encontrado em uma etiqueta colada no equipamento.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Entendi',
                                  style: TextStyle(color: Color(0xFF000000)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.help_outline),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                  width: double.infinity,
                  child: DropdownMenuFormField<TipoDispositivo>(
                    label: const Text('Tipo do Dispositivo'),
                    menuHeight: 200,
                    validator: (tipoDisp) {
                      if (tipoDisp == null) {
                        return 'Selecione um tipo de dispositivo';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    initialSelection: _tipoSelecionado,
                    dropdownMenuEntries: TipoDispositivo.values.map((tipoDisp) {
                      return DropdownMenuEntry(
                        value: tipoDisp,
                        label: tipoDisp.nomeTipo,
                      );
                    }).toList(),
                    onSelected: (tipoDisp) {
                      setState(() => _tipoSelecionado = tipoDisp);
                    },
                    onSaved: (tipoDisp) {
                      _tipoSelecionado = tipoDisp;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
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
