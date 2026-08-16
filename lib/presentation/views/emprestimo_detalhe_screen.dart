import 'package:flutter/material.dart';
import 'package:gardien_tech/data/dto/emprestimo_item_com_dispositivo_dto.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_item.dart';
import 'package:gardien_tech/domain/enum/emprestimo_status.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:gardien_tech/presentation/viewmodels/emprestimo_detalhe_viewmodel.dart';
import 'package:gardien_tech/presentation/views/selecionar_dispositivo_screen.dart';
import 'package:gardien_tech/presentation/widgets/emprestimo_item_skeleton.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EmprestimoDetalheScreen extends StatefulWidget {
  final int idEmprestimo;
  final DateTime dataHoraEfetuado;
  final String nomeResponsavel;
  final int idStatus;

  const EmprestimoDetalheScreen({
    super.key,
    required this.idEmprestimo,
    required this.dataHoraEfetuado,
    required this.nomeResponsavel,
    required this.idStatus,
  });

  @override
  State<StatefulWidget> createState() => __EmprestimoDetalheScreenState();
}

class __EmprestimoDetalheScreenState extends State<EmprestimoDetalheScreen> {
  @override
  void initState() {
    super.initState();

    // Força o Flutter a renderizar a tela com o Shimmer antes de executar a query
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;

      final viewmodel = context.read<EmprestimoDetalheViewmodel>();
      await viewmodel.carregarDispositivosDoEmprestimo(widget.idEmprestimo);
    });
  }

  Future<void> _excluirItemEmprestimo(int idEmprestimoDispositivo) async {
    final viewmodel = context.read<EmprestimoDetalheViewmodel>();

    viewmodel
        .resetState(); // Reseta o estado na memória e garante isLoading = true do viewmodel
    // Inicia a busca dos dados após o frame do Shimmer ser desenhado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        viewmodel.carregarDispositivosDoEmprestimo(widget.idEmprestimo);
      }
    });

    final resultado = await viewmodel.removerDispositivo(
      idEmprestimoDispositivo,
    );

    if (!mounted || !resultado) return;

    await viewmodel.carregarDispositivosDoEmprestimo(widget.idEmprestimo);

    if (!mounted) return;

    // Conta o total de dispositivos restantes no empréstimo
    final totalRestante = viewmodel.dispositivosDoEmprestimo.fold<int>(
      0,
      (total, dto) => total + dto.dispositivos.length,
    );

    if (totalRestante == 0 || viewmodel.dispositivosDoEmprestimo.isEmpty) {
      // Exclui o empréstimo e volta para a tela principal
      final excluido = await viewmodel.excluirEmprestimo(widget.idEmprestimo);

      if (!mounted) return;

      if (excluido) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Empréstimo sem itens removido.'),
            backgroundColor: CoresGardien.cinzaClaro,
          ),
        );

        Navigator.of(context).pop(true);
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item removido com sucesso'),
        backgroundColor: CoresGardien.cinzaClaro,
      ),
    );
  }

  List<int> _obterIdsDispositivosAtuais() {
    final viewmodel = context.read<EmprestimoDetalheViewmodel>();
    return viewmodel.dispositivosDoEmprestimo
        .expand((dto) => dto.dispositivosObj)
        .map((d) => d.id!)
        .toList();
  }

  Future<void> _excluirEmprestimo(
    BuildContext context,
    EmprestimoDetalheViewmodel viewmodel,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Excluir Empréstimo"),
        content: const Text("Tem certeza que deseja excluir o empréstimo?"),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: CoresGardien.preto),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: CoresGardien.vermelhoClaro),
            ),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final sucesso = await viewmodel.excluirEmprestimo(widget.idEmprestimo);

    if (!context.mounted) return;

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Empréstimo excluído com sucesso'),
          backgroundColor: CoresGardien.cinzaClaro,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewmodel.errorMessage ?? 'Erro ao excluir o empréstimo',
          ),
          backgroundColor: CoresGardien.vermelhoClaro,
        ),
      );
    }
  }

  Future<void> _finalizarEmprestimo(
    BuildContext context,
    EmprestimoDetalheViewmodel viewmodel,
  ) async {
    final sucesso = await viewmodel.finalizarEmprestimo(widget.idEmprestimo);
    if (!context.mounted) return;

    if (!sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewmodel.errorMessage ??
                'Verifique se todos os dispositivos foram devolvidos',
          ),
          backgroundColor: CoresGardien.vermelhoClaro,
        ),
      );
      return;
    }

    await viewmodel.carregarDispositivosDoEmprestimo(widget.idEmprestimo);
  }

  Future<void> _definirSemCorrespondencia(
    BuildContext context,
    EmprestimoDetalheViewmodel viewmodel,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Sem Correspondência',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Tem certeza que deseja definir como Sem Correspondência?\n\n'
          'Isso quer dizer que há dispositivos que não foram vinculados e '
          'atualmente não há como identificar os dispositivos que estavam no empréstimo',
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: CoresGardien.preto),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Definir',
              style: TextStyle(color: CoresGardien.vermelhoClaro),
            ),
          ),
        ],
      ),
    );
    if (confirmar != true) return;

    final sucesso = await viewmodel.definirSemCorrespondencia(
      widget.idEmprestimo,
    );
    if (!context.mounted) return;
    if (!sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewmodel.errorMessage ??
                'Não foi possível definir como Sem Correspondência',
          ),
        ),
      );
    }
    await viewmodel.carregarDispositivosDoEmprestimo(widget.idEmprestimo);
  }

  @override
  Widget build(BuildContext context) {
    final String horaFormatada = DateFormat(
      'HH:mm',
    ).format(widget.dataHoraEfetuado);
    final statusStr =
        EmprestimoStatus.values
            .where((status) => status.id == widget.idStatus)
            .firstOrNull
            ?.nomeStatus ??
        'Status não encontrado';
    String nomeCortado = widget.nomeResponsavel.length > 15
        ? '${widget.nomeResponsavel.substring(0, 17)}...'
        : widget.nomeResponsavel;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do empréstimo'),
        backgroundColor: CoresGardien.azulClaro,
        foregroundColor: CoresGardien.branco,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: CoresGardien.cinza),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(4),
              child:
                  /*
                  Informações adicionais do empréstimo selecionado
                  */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Empréstimo atual\n',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Responsável: $nomeCortado\n',
                              style: TextStyle(fontSize: 13),
                            ),
                            TextSpan(
                              text: 'Hora efetuada: $horaFormatada\n',
                              style: TextStyle(fontSize: 13),
                            ),
                            TextSpan(
                              text: 'Status atual: $statusStr',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<EmprestimoDetalheViewmodel>(
                builder: ((context, viewmodel, child) {
                  if (viewmodel.isLoading) {
                    return const EmprestimoDetalheSkeleton();
                  }
                  if (viewmodel.dispositivosDoEmprestimo.isEmpty) {
                    return const Text('Nenhum dispositivo encontrado');
                  }

                  final tiposMap = {
                    for (var t in TipoDispositivo.values) t.id: t.nomeTipo,
                  };

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            if (!viewmodel.empFinalizado) ...[
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    await viewmodel.marcarTodos(
                                      widget.idEmprestimo,
                                    );

                                    if (!context.mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Todos os dispositivos foram marcados como devolvidos.',
                                        ),
                                        backgroundColor:
                                            CoresGardien.verdeClaro,
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.done_all,
                                    color: CoresGardien.branco,
                                  ),
                                  label: const Text(
                                    'Devolver todos',
                                    style: TextStyle(
                                      color: CoresGardien.branco,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: CoresGardien.azulClaro,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    minimumSize: const Size(
                                      double.infinity,
                                      40,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final sucesso = await viewmodel
                                        .desmarcarTodos(widget.idEmprestimo);

                                    if (!context.mounted) return;

                                    if (sucesso) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Todos os dispositivos foram marcados como em uso.',
                                          ),
                                          backgroundColor:
                                              CoresGardien.verdeClaro,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            viewmodel.errorMessage ??
                                                'Erro ao desmarcar dispositivos.',
                                          ),
                                          backgroundColor:
                                              CoresGardien.vermelhoClaro,
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.remove_done,
                                    color: CoresGardien.branco,
                                  ),
                                  label: const Text(
                                    'Desfazer devoluções',
                                    style: TextStyle(
                                      color: CoresGardien.branco,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: CoresGardien.azulClaro,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    minimumSize: const Size(
                                      double.infinity,
                                      40,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount:
                              viewmodel.dispositivosDoEmprestimo.length + 1,
                          itemBuilder: (context, index) {
                            if (index ==
                                viewmodel.dispositivosDoEmprestimo.length) {
                              if (!viewmodel.empFinalizado) {
                                return Padding(
                                  // Botão adicionar
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: Center(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final viewmodel = context
                                            .read<EmprestimoDetalheViewmodel>();
                                        final idsParaIgnorar =
                                            _obterIdsDispositivosAtuais(); // Coleta IDs existentes para filtrar na hora de adicionar ao empréstimo

                                        final resultado =
                                            await Navigator.push<
                                              Map<String, dynamic>
                                            >(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    SelecionarDispositivoScreen(
                                                      null,
                                                      widget.idEmprestimo,
                                                      idsParaIgnorar:
                                                          idsParaIgnorar,
                                                    ),
                                              ),
                                            );

                                        if (!mounted) return;

                                        if (resultado != null) {
                                          final idDispositivo =
                                              resultado['idDispositivo'] as int;

                                          await viewmodel.adicionarDispositivo(
                                            widget.idEmprestimo,
                                            idDispositivo,
                                          );

                                          await viewmodel
                                              .carregarDispositivosDoEmprestimo(
                                                widget.idEmprestimo,
                                              );
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: CoresGardien.azulClaro,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        minimumSize: const Size(
                                          double.infinity,
                                          50,
                                        ),
                                      ),
                                      child: const Text(
                                        'Adicionar',
                                        style: TextStyle(
                                          color: CoresGardien.branco,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox(height: 100);
                            }

                            // Mapeia os dados para acelerar a busca de itens e usa Column para otimizar a renderização.
                            final itemDoDTO =
                                viewmodel.dispositivosDoEmprestimo[index];
                            final emprestimoItem = itemDoDTO.item;
                            final tipoDispositivo =
                                tiposMap[emprestimoItem.idTipoDispositivo] ??
                                'Tipo não encontrado';

                            final dispObjMap = {
                              for (var d in itemDoDTO.dispositivosObj) d.id: d,
                            };

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: viewmodel.empFinalizado ? 100 : 10,
                              ),
                              child: Column(
                                children: itemDoDTO.dispositivos.map((
                                  emprDisp,
                                ) {
                                  final dispositivo =
                                      dispObjMap[emprDisp.idDispositivo];

                                  return Card(
                                    key: ValueKey(emprDisp.id),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: viewmodel.empFinalizado
                                          ? _cardFinalizado(
                                              dispositivo,
                                              tipoDispositivo,
                                            )
                                          : _cardItens(
                                              itemDoDTO,
                                              emprestimoItem,
                                              tipoDispositivo,
                                              dispositivo,
                                              emprDisp,
                                            ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      /*
      Botões Excluir e Finalizar
      */
      bottomNavigationBar: Consumer<EmprestimoDetalheViewmodel>(
        builder: (context, viewmodel, _) {
          // Verifica se está finalizado
          final bool isFinalizado =
              widget.idStatus == EmprestimoStatus.concluido.id ||
              viewmodel.empFinalizado;
          final bool isEmObservacao =
              widget.idStatus == EmprestimoStatus.emObservacao.id;
          if (isFinalizado) {
            return SizedBox.shrink();
          }

          return SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: viewmodel.isLoading
                          ? null
                          : () => _excluirEmprestimo(context, viewmodel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CoresGardien.vermelhoEscuro,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Excluir empréstimo',
                        style: TextStyle(color: CoresGardien.branco),
                      ),
                    ),
                  ),
                  if (isEmObservacao) ...[
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: viewmodel.isLoading
                            ? null
                            : () => _definirSemCorrespondencia(
                                context,
                                viewmodel,
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CoresGardien.amarelo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Sem Correspondência',
                          style: TextStyle(color: CoresGardien.branco),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: viewmodel.isLoading
                          ? null
                          : () => _finalizarEmprestimo(context, viewmodel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CoresGardien.verdeClaro,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Finalizar',
                        style: TextStyle(color: CoresGardien.branco),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _cardItens(
    EmprestimoItemComDispositivoDTO itemDoDTO,
    EmprestimoItem emprestimoItem,
    String tipoDispositivo,
    Dispositivo? dispositivo,
    EmprestimoDispositivo empDispositivo,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                // Campo do número de patrimônio
                flex: 1,
                child: TextField(
                  readOnly: true,
                  canRequestFocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                    text: dispositivo?.numPatrimonio ?? '',
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: CoresGardien.cinza,
                  ),
                  onTap: dispositivo == null
                      ? () async {
                          final idsParaIgnorar =
                              _obterIdsDispositivosAtuais(); // Coleta IDs existentes para filtrar na hora de adicionar ao empréstimo
                          final resultado = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SelecionarDispositivoScreen(
                                emprestimoItem.idTipoDispositivo,
                                widget.idEmprestimo,
                                idsParaIgnorar: idsParaIgnorar,
                              ),
                            ),
                          );
                          if (!mounted) return;
                          if (resultado != null) {
                            final idDispositivo =
                                resultado['idDispositivo'] as int;
                            final sucesso = await context
                                .read<EmprestimoDetalheViewmodel>()
                                .vincularDispositivo(
                                  empDispositivo.id!,
                                  idDispositivo,
                                );
                            if (mounted && sucesso) {
                              await context
                                  .read<EmprestimoDetalheViewmodel>()
                                  .carregarDispositivosDoEmprestimo(
                                    widget.idEmprestimo,
                                  );
                            }
                          }
                        }
                      : () async {
                          final idsParaIgnorar =
                              _obterIdsDispositivosAtuais(); // Coleta IDs existentes para filtrar na hora de adicionar ao empréstimo
                          final resultado = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SelecionarDispositivoScreen(
                                emprestimoItem.idTipoDispositivo,
                                widget.idEmprestimo,
                                idsParaIgnorar: idsParaIgnorar,
                              ),
                            ),
                          );
                          if (!mounted) return;
                          if (resultado != null) {
                            final idDispositivo =
                                resultado['idDispositivo'] as int;
                            final sucesso = await context
                                .read<EmprestimoDetalheViewmodel>()
                                .trocarDispositivo(
                                  empDispositivo.id!,
                                  idDispositivo,
                                );
                            if (mounted && sucesso) {
                              await context
                                  .read<EmprestimoDetalheViewmodel>()
                                  .carregarDispositivosDoEmprestimo(
                                    widget.idEmprestimo,
                                  );
                            }
                          }
                        },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                // Campo do tipo de dispositivo
                flex: 2,
                child: TextField(
                  enabled: false,
                  readOnly: true,
                  canRequestFocus: false,
                  controller: TextEditingController(text: tipoDispositivo),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: CoresGardien.cinza,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Row(
          // Checkbox de devolvido
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Devolvido: '),
            Checkbox(
              checkColor: CoresGardien.branco,
              activeColor: CoresGardien.azulClaro,
              // Usa o cache do viewmodel para saber se foi marcado como devolvido
              value:
                  context.read<EmprestimoDetalheViewmodel>().obterEstadoCache(
                    empDispositivo.id!,
                  ) ??
                  false,
              onChanged: dispositivo != null
                  ? (bool? value) async {
                      if (value == null) return;

                      // Bloqueia tentar desmarcar se está em outro empréstimo
                      if (!value && dispositivo.idStatus == 3) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Este dispositivo está sendo usado em outro empréstimo.',
                            ),
                            backgroundColor: CoresGardien.vermelhoClaro,
                          ),
                        );
                        return;
                      }

                      final viewmodel = context
                          .read<EmprestimoDetalheViewmodel>();
                      final messenger = ScaffoldMessenger.of(context);
                      final sucesso = await viewmodel.alternarDevolucao(
                        dispositivo.id!,
                        value,
                        widget.idEmprestimo,
                        empDispositivo.id!,
                        emprestimoItem.id!,
                      );

                      if (!mounted) return;

                      if (sucesso) {
                        // Recarrega a lista para refletir alterações
                        await viewmodel.carregarDispositivosDoEmprestimo(
                          widget.idEmprestimo,
                        );
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              value
                                  ? 'Dispositivo marcado como disponível'
                                  : 'Dispositivo marcado como em uso',
                            ),
                            backgroundColor: CoresGardien.verdeClaro,
                          ),
                        );
                      } else {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              viewmodel.errorMessage ??
                                  'Erro ao alterar status do dispositivo',
                            ),
                            backgroundColor: CoresGardien.vermelhoClaro,
                          ),
                        );
                      }
                    }
                  : null,
            ),
            SizedBox(width: 50),
            TextButton(
              onPressed: () async {
                return showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Excluir Item"),
                    content: const Text(
                      "Tem certeza que deseja excluir o item?",
                    ),
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: CoresGardien.preto),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _excluirItemEmprestimo(empDispositivo.id!);
                        },
                        child: const Text(
                          'Excluir',
                          style: TextStyle(color: CoresGardien.vermelhoClaro),
                        ),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresGardien.vermelhoEscuro,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                fixedSize: const Size(130, 30),
              ),
              child: const Text(
                'Remover',
                style: TextStyle(color: CoresGardien.branco),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _cardFinalizado(Dispositivo? dispositivo, String tipoDispositivo) {
    final numPatrimonio = dispositivo?.numPatrimonio;

    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                // Campo do número de patrimônio
                flex: 1,
                child: TextField(
                  enabled: false,
                  readOnly: true,
                  canRequestFocus: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                    text: numPatrimonio == null || numPatrimonio.isEmpty
                        ? '?'
                        : numPatrimonio,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: CoresGardien.cinza,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                // Campo do tipo de dispositivo
                flex: 2,
                child: TextField(
                  enabled: false,
                  readOnly: true,
                  canRequestFocus: false,
                  controller: TextEditingController(text: tipoDispositivo),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: CoresGardien.cinza,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
