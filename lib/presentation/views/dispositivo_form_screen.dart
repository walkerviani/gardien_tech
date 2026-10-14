import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:gardien_tech/presentation/viewmodels/dispositivo_form_viewmodel.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';
import 'package:provider/provider.dart';

class DispositivoFormScreen extends StatefulWidget {
  final int? dispositivoId;
  final int? idTipoDispositivo;
  final String? numSerie;
  final String? numPatrimonio;

  const DispositivoFormScreen({
    super.key,
    this.dispositivoId,
    this.idTipoDispositivo,
    this.numSerie,
    this.numPatrimonio,
  });

  @override
  State<StatefulWidget> createState() => _DispositivoFormScreenState();
}

class _DispositivoFormScreenState extends State<DispositivoFormScreen> {
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

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return; // Finaliza se tiver algum campo inválido no Form
    }
    final viewModel = context.read<DispositivoFormViewmodel>();

    final numSerie = _numSerieController.text.trim().toUpperCase();
    final numPatrimonio = _numPatrimonioController.text.trim().toUpperCase();
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
        SnackBar(
          content: Text(viewModel.errorMessage ?? 'Erro desconhecido'),
          backgroundColor: CoresGardien.vermelhoClaro,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DispositivoFormViewmodel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar dispositivo' : 'Criar dispositivo'),
        backgroundColor: CoresGardien.azulClaro,
        foregroundColor: CoresGardien.branco,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _numSerieController,
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'O número de série é obrigatório';
                    }

                    final numSerie = value.trim();

                    if (numSerie.length > 50) {
                      return 'Precisa ser menor que 50 caracteres';
                    }

                    if (numSerie.length < 3) {
                      return 'Precisa ser maior que 3 caracteres';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Número de série',
                    hintText: 'Ex: S/N ou Serial do fabricante',
                    counterText: '',
                    hintStyle: TextStyle(color: CoresGardien.cinza),
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _numPatrimonioController,
                  maxLength: 30,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'O número de patrimônio é obrigatório';
                    }

                    final numPatrimonio = value.trim();

                    if (numPatrimonio.length > 30) {
                      return 'Precisa ser menor que 30 caracteres';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Número de patrimônio',
                    hintText: 'Ex: NOTE-01234',
                    counterText: '',
                    hintStyle: TextStyle(color: CoresGardien.cinza),
                  ),
                ),

                const SizedBox(height: 20),

                DropdownMenuFormField<TipoDispositivo>(
                  expandedInsets: EdgeInsets.zero,
                  label: const Text('Tipo do dispositivo'),
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

                const SizedBox(height: 20),

                ElevatedButton(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _numSerieController.dispose();
    _numPatrimonioController.dispose();
    super.dispose();
  }
}
