import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_item_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_repository.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';
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
          emprestimoItemRepository: context.read<EmprestimoItemRepository>(),
          emprestimoDispositivoRepository: context.read<EmprestimoDispositivoRepository>(),
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
                  // Campo de texto para informar o responsável pelo empréstimo
                  TextField(
                    controller: viewModel.responsavelController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Responsável',
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      viewModel.buscarResponsavel(value);
                    },
                  ),
                  // Lista de sugestões de responsável
                  if (viewModel.opcoesResponsavel.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(8),
                        clipBehavior: Clip.antiAlias,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: viewModel.opcoesResponsavel.length,
                            itemBuilder: (context, index) {
                              final usuario = viewModel.opcoesResponsavel[index];
                              return ListTile(
                                title: Text(usuario.nome),
                                onTap: () {
                                  viewModel.selecionarResponsavel(usuario);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Selecionar equipamentos por:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Botão segmentado para alternar entre os modos de seleção
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
                  SizedBox(height: 12),
                  // Renderiza o formulário correspondente ao modo selecionado
                  if (viewModel.opcaoView == OpcaoEmprestimo.quantidade)
                    _buildPorQuantidade(context, viewModel)
                  else
                    _buildPorUnidade(context, viewModel),
                ],
              ),
              // Botão fixo na parte inferior para confirmar o empréstimo
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
                    child: const Text('Confirmar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Constrói o formulário no modo por quantidade
  Widget _buildPorQuantidade(BuildContext context, EmprestimoFormViewModel viewModel) {
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
                    Text('Tipo de dispositivo:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(width: 12),
                    Expanded(
                      child: DropdownMenuFormField<TipoDispositivo>(
                        label: const Text('Tipo'),
                        menuHeight: 200,
                        dropdownMenuEntries: TipoDispositivo.values
                            .where((t) =>
                                t.nomeTipo == viewModel.itensQuantidade[index].tipoDisp ||
                                !viewModel.itensQuantidade.any((item) => item.tipoDisp == t.nomeTipo))
                            .map((t) {
                          return DropdownMenuEntry(value: t, label: t.nomeTipo);
                        }).toList(),
                        onSelected: (valor) {
                          viewModel.atualizarTipoDispositivo(index, valor?.nomeTipo);
                        },
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Informe a quantidade:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: viewModel.itensQuantidade[index].quantidade,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Quantidade",
                            ),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            onChanged: (value) {
                              viewModel.atualizarAvisoQuantidade(index, int.tryParse(value) ?? 0);
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
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    viewModel.removerItemQuantidade(index);
                  },
                ),
              ),
            ),
          );
        }),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton.icon(
            onPressed: () {
              viewModel.adicionarItemQuantidade();
              Future.delayed(Duration(milliseconds: 100), () {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            label: Text('Adicionar'),
            icon: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  // Constrói o formulário no modo por unidade
  Widget _buildPorUnidade(BuildContext context, EmprestimoFormViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Adicionar equipamento:', style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        TextField(
          controller: viewModel.pesquisaController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Digite patrimônio ou série',
            errorText: viewModel.erroBusca,
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            viewModel.buscarDispositivo(value);
          },
        ),
        if (viewModel.opcoesUnidade.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Material(
              elevation: 3,
              clipBehavior: Clip.antiAlias,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: viewModel.opcoesUnidade.length,
                  itemBuilder: (context, index) {
                    final dispositivo = viewModel.opcoesUnidade[index];
                    return ListTile(
                      title: Text(dispositivo.descricao),
                      onTap: () => viewModel.selecionarDispositivo(dispositivo),
                    );
                  },
                ),
              ),
            ),
          ),
        SizedBox(height: 12),
        ...List.generate(viewModel.itensUnidade.length, (index) {
          return Padding(
            key: viewModel.itensUnidade[index].key,
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                title: Text(
                  viewModel.itensUnidade[index].tipoDisp ?? '',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Número Patrimônio: ${viewModel.itensUnidade[index].numPatrimonio ?? '-'}',
                    ),
                    Text(
                      'Número Série: ${viewModel.itensUnidade[index].numSerie ?? '-'}',
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
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
            ...erros.map((erro) => Text('• $erro')),
          ],
        ),
        backgroundColor: const Color(0xFFB00303),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}