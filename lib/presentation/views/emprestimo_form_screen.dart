import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:searchfield/searchfield.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_repository.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';
import 'package:gardien_tech/domain/services/emprestimo_service.dart';
import 'package:gardien_tech/presentation/viewmodels/emprestimo_form_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';

class EmprestimoFormScreen extends StatefulWidget {
  const EmprestimoFormScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EmprestimoFormScreenState();
}

class _EmprestimoFormScreenState extends State<EmprestimoFormScreen> {
  final ScrollController _scrollController = ScrollController();

  IconData _selecionarIcone(int tipoDispositivo) {
    switch (tipoDispositivo) {
      case 1:
        return Icons.laptop;
      case 2:
        return Icons.tablet_android;
      case 3:
        return Icons.smartphone;
      case 4:
        return Icons.mouse;
      case 5:
        return Icons.keyboard;
      case 6:
        return Icons.monitor;
      case 7:
        return Icons.videocam;
      case 8:
        return Icons.camera;
      case 9:
        return Icons.headset;
      case 10:
        return Icons.cable;
      case 11:
        return Icons.usb;
      case 12:
        return Icons.router;
      case 13:
        return Icons.router;
      case 14:
        return Icons.print_rounded;
      case 15:
        return Icons.surround_sound;
      case 16:
        return Icons.settings_remote_outlined;
      default:
        return Icons.question_mark;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ScaffoldMessenger.of(context).clearSnackBars();
        }
      },
      child: ChangeNotifierProvider(
        create: (context) => EmprestimoFormViewModel(
          dispositivoRepository: context.read<DispositivoRepository>(),
          usuarioRepository: context.read<UsuarioRepository>(),
          emprestimoRepository: context.read<EmprestimoRepository>(),
          emprestimoService: context.read<EmprestimoService>(),
        ),
        child: Consumer<EmprestimoFormViewModel>(
          builder: (context, viewModel, _) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Empréstimo'),
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
              ),
              body: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(15),
                children: [
                  SearchField<Usuario>(
                    controller: viewModel.responsavelController,
                    suggestions: const [],
                    animationDuration: Duration.zero,
                    itemHeight: 50,
                    searchInputDecoration: SearchInputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Responsável',
                    ),
                    suggestionsDecoration: SuggestionDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      selectionColor: Theme.of(context).scaffoldBackgroundColor,
                      hoverColor: Theme.of(context).scaffoldBackgroundColor,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                    onSearchTextChanged: (query) async {
                      final resultados = await viewModel.buscarResponsavel(
                        query,
                      );
                      return resultados
                          .map(
                            (e) => SearchFieldListItem<Usuario>(
                              e.nome,
                              item: e,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 2,
                                ),
                                child: Text(
                                  e.nome,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          )
                          .toList();
                    },
                    onSuggestionTap: (item) {
                      if (item.item != null) {
                        viewModel.selecionarResponsavel(item.item!);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Selecionar equipamentos por:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<OpcaoEmprestimo>(
                    style: SegmentedButton.styleFrom(
                      foregroundColor: const Color(0xFF2196F3),
                      selectedForegroundColor: Colors.white,
                      selectedBackgroundColor: const Color(0xFF2196F3),
                    ),
                    segments: const <ButtonSegment<OpcaoEmprestimo>>[
                      ButtonSegment<OpcaoEmprestimo>(
                        value: OpcaoEmprestimo.quantidade,
                        label: Text('Por Quantidade'),
                        icon: Icon(Icons.inventory_2_outlined),
                      ),
                      ButtonSegment<OpcaoEmprestimo>(
                        value: OpcaoEmprestimo.unidade,
                        label: Text('Por Unidade'),
                        icon: Icon(Icons.computer),
                      ),
                    ],
                    selected: <OpcaoEmprestimo>{viewModel.opcaoView},
                    onSelectionChanged: (Set<OpcaoEmprestimo> novaSelecao) {
                      viewModel.alternarOpcao(novaSelecao.first);
                    },
                  ),
                  const SizedBox(height: 12),
                  if (viewModel.opcaoView == OpcaoEmprestimo.quantidade)
                    _buildPorQuantidade(context, viewModel)
                  else
                    _buildPorUnidade(context, viewModel),
                ],
              ),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                  child: ElevatedButton(
                    onPressed: () async {
                      final erros = viewModel.validarEConfirmar();
                      if (erros.isNotEmpty) {
                        exibirErros(erros);
                        return;
                      }
                      await viewModel.confirmar();
                      if (context.mounted) Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAf50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPorQuantidade(
    BuildContext context,
    EmprestimoFormViewModel viewModel,
  ) {
    return Column(
      children: [
        ...List.generate(viewModel.itensQuantidade.length, (index) {
          return Padding(
            key: viewModel.itensQuantidade[index].key,
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                title: Row(
                  children: [
                    const Text(
                      'Tipo de dispositivo:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownMenuFormField<TipoDispositivo>(
                        label: const Text('Tipo'),
                        menuHeight: 200,
                        dropdownMenuEntries: TipoDispositivo.values
                            .where(
                              (t) =>
                                  t.nomeTipo ==
                                      viewModel
                                          .itensQuantidade[index]
                                          .tipoDisp ||
                                  !viewModel.itensQuantidade.any(
                                    (item) => item.tipoDisp == t.nomeTipo,
                                  ),
                            )
                            .map((t) {
                              return DropdownMenuEntry(
                                value: t,
                                label: t.nomeTipo,
                              );
                            })
                            .toList(),
                        onSelected: (valor) {
                          viewModel.atualizarTipoDispositivo(
                            index,
                            valor?.nomeTipo,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Informe a quantidade:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller:
                                viewModel.itensQuantidade[index].quantidade,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Quantidade",
                            ),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              viewModel.atualizarAvisoQuantidade(
                                index,
                                int.tryParse(value) ?? 0,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    if (viewModel.itensQuantidade[index].mostrarAviso)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange,
                                size: 28,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Quantidade alta de dispositivos pode impactar na performance.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    viewModel.removerItemQuantidade(index);
                  },
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton.icon(
            onPressed: () {
              viewModel.adicionarItemQuantidade();
              Future.delayed(const Duration(milliseconds: 100), () {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(double.infinity, 50),
            ),
            label: const Text('Adicionar'),
          ),
        ),
      ],
    );
  }

  Widget _buildPorUnidade(
    BuildContext context,
    EmprestimoFormViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Adicionar equipamento:', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        SearchField<Dispositivo>(
          controller: viewModel.pesquisaController,
          suggestions: const [],
          animationDuration: Duration.zero,
          itemHeight: 70,
          searchInputDecoration: SearchInputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Digite patrimônio ou série',
            errorText: viewModel.erroBusca,
          ),
          suggestionsDecoration: SuggestionDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            selectionColor: Theme.of(context).scaffoldBackgroundColor,
            hoverColor: Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          onSearchTextChanged: (query) async {
            final resultados = await viewModel.buscarDispositivo(query);
            return resultados
                .map(
                  (dispositivo) => SearchFieldListItem<Dispositivo>(
                    dispositivo.numSerie,
                    item: dispositivo,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          Icon(_selecionarIcone(dispositivo.idTipoDispositivo)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Número Patrimônio: ${dispositivo.numPatrimonio}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Número Série: ${dispositivo.numSerie}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList();
          },
          onSuggestionTap: (item) {
            if (item.item != null) {
              viewModel.selecionarDispositivo(item.item!);
            }
          },
        ),
        const SizedBox(height: 12),
        ...List.generate(viewModel.itensUnidade.length, (index) {
          final item = viewModel.itensUnidade[index];
          return Padding(
            key: item.key,
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                leading: Icon(_selecionarIcone(item.idTipoDispositivo ?? 0)),
                title: Text(
                  item.tipoDisp ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Número Patrimônio: ${item.numPatrimonio ?? '-'}'),
                    Text('Número Série: ${item.numSerie ?? '-'}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    viewModel.removerItemUnidade(index);
                  },
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void exibirErros(List<String> erros) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Verifique os campos:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...erros.map((erro) => Text('- $erro')),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
