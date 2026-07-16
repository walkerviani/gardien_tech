import 'package:flutter/material.dart';
import 'package:gardien_tech/data/dto/emprestimo_item_com_dispositivo_dto.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_item.dart';
import 'package:gardien_tech/domain/enum/dispositivo_status.dart';
import 'package:gardien_tech/domain/enum/emprestimo_status.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:gardien_tech/presentation/viewmodels/emprestimo_detalhe_viewmodel.dart';
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
  late final List<TextEditingController> _numPatrimonioController = [];
  final Map<String, TextEditingController> _controllerMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmprestimoDetalheViewmodel>().carregarItensDoEmprestimo(
        widget.idEmprestimo,
      );
    });
  }

  Future<void> _excluirItemEmprestimo(
    BuildContext context,
    int idEmprestimoItem,
    int idEmprestimo,
    int idDispositivo,
  ) async {
    final resultado = await context
        .read<EmprestimoDetalheViewmodel>()
        .deletarItem(idEmprestimoItem, idEmprestimo, idDispositivo);
    if (context.mounted && resultado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item removido com sucesso'),
          backgroundColor: Colors.green,
        ),
      );
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do empréstimo'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
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
                              text: 'Responsável: ${widget.nomeResponsavel}\n',
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
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewmodel.itensComDispositivos.isEmpty) {
                    return const Text('Nenhum dispositivo encontrado');
                  }
                  return ListView.builder(
                    itemCount: viewmodel.itensComDispositivos.length + 1,
                    itemBuilder: (context, index) {
                      // Último item da lista = botão
                      if (index == viewmodel.itensComDispositivos.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF2196F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                fixedSize: const Size(130, 30),
                              ),
                              child: const Text('Adicionar', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        );
                      }
                      final itemDoDTO = viewmodel.itensComDispositivos[index];
                      final emprestimoItem = itemDoDTO.item;
                      final tipoDispositivo = TipoDispositivo.values
                          .where((tipo) => tipo.id == emprestimoItem.idTipoDispositivo)
                          .firstOrNull
                          ?.nomeTipo ?? 'Tipo não encontrado';
                      if (emprestimoItem.ehQuantitativo) {
                        return Column(
                          children: List.generate(emprestimoItem.qtdSolicitada, (indexUnidade) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: _cardPorQuantidade(
                                  itemDoDTO,
                                  emprestimoItem,
                                  tipoDispositivo,
                                  indexUnidade,
                                  viewmodel,
                                ),
                              ),
                            );
                          }),
                        );
                      }
                      return Column(
                        children: List.generate(
                          itemDoDTO.dispositivosObj.length,
                          (indexUnidade) {
                            final dispositivo = itemDoDTO.dispositivosObj[indexUnidade];
                            final emprDisp = itemDoDTO.dispositivos[indexUnidade];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: _cardPorUnidade(
                                  itemDoDTO,
                                  emprestimoItem,
                                  tipoDispositivo,
                                  dispositivo,
                                  emprDisp,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFe7af06),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                fixedSize: const Size(300, 50),
              ),
              child: Text('Salvar', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                fixedSize: const Size(300, 50),
              ),
              child: Text('Finalizar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),)
    );
  }

  Widget _cardPorUnidade(
    EmprestimoItemComDispositivoDTO itemDoDTO,
    EmprestimoItem emprestimoItem,
    String tipoDispositivo,
    Dispositivo dispositivo,
    EmprestimoDispositivo empDispositivo,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded( // Campo do número de patrimônio
                flex: 1,
                child: TextField(
                  enabled: false,
                  readOnly: true,
                  canRequestFocus: false,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  controller: TextEditingController(text: dispositivo.numPatrimonio),
                  style: const TextStyle(fontSize: 14, color: Color(0xFF686767)),
                ),
              ),
              SizedBox(width: 10),
              Expanded( // Campo do tipo de dispositivo
                flex: 2,
                child: TextField(
                  enabled: false,
                  readOnly: true,
                  canRequestFocus: false,
                  controller: TextEditingController(text: tipoDispositivo),
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  style: const TextStyle(fontSize: 14, color: Color(0xFF686767)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Row( // Checkbox de devolvido
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Devolvido: '),
            Checkbox(
              checkColor: Colors.white,
              activeColor: const Color(0xFF006dc4),
              value: dispositivo.idStatus == DispositivoStatus.disponivel.id,
              onChanged: dispositivo.id != null
                  ? (bool? value) {
                      context.read<EmprestimoDetalheViewmodel>().alternarDevolucao(
                        dispositivo.id!,
                        value!,
                        widget.idEmprestimo,
                      );
                    }
                  : null,
            ),
            SizedBox(width: 50),
            TextButton(
              onPressed: () async {
                if (dispositivo.id != null) {
                  await _excluirItemEmprestimo(
                    context,
                    emprestimoItem.id!,
                    widget.idEmprestimo,
                    dispositivo.id!,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB00303),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                fixedSize: const Size(130, 30),
              ),
              child: const Text(
                'Remover',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _cardPorQuantidade(
    EmprestimoItemComDispositivoDTO itemDoDTO,
    EmprestimoItem emprestimoItem,
    String tipoDispositivo,
    int indexUnidade,
    EmprestimoDetalheViewmodel viewmodel,
  ) {
    final dispositivoVinculado = indexUnidade < itemDoDTO.dispositivosObj.length
        ? itemDoDTO.dispositivosObj[indexUnidade]
        : null;
    final controllerKey = '${emprestimoItem.id}_$indexUnidade';
    if (!_controllerMap.containsKey(controllerKey)) {
      _controllerMap[controllerKey] = TextEditingController(
        text: dispositivoVinculado?.numPatrimonio ?? '',
      );
    }
    final controller = _controllerMap[controllerKey]!;
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: dispositivoVinculado == null
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Clicou no patrimônio vazio')),
                          );
                        }
                      : null,
                  child: TextField(
                    enabled: false,
                    readOnly: true,
                    canRequestFocus: false,
                    controller: controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF686767),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
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
                    color: Color(0xFF686767),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Devolvido: '),
            Checkbox(
              checkColor: Colors.white,
              activeColor: const Color(0xFF006dc4),
              value: dispositivoVinculado != null && dispositivoVinculado.idStatus == DispositivoStatus.disponivel.id,
              onChanged: (bool? value) {
                setState(() {
                  if (dispositivoVinculado?.id != null) {
                    context.read<EmprestimoDetalheViewmodel>().alternarDevolucao(
                      dispositivoVinculado!.id!,
                      value!,
                      widget.idEmprestimo,
                    );
                  }
                });
              },
            ),
            SizedBox(width: 50),
            TextButton(
              onPressed: () async {
                final ed = itemDoDTO.dispositivos.length > indexUnidade
                    ? itemDoDTO.dispositivos[indexUnidade]
                    : null;
                if (ed?.id != null) {
                  await context
                      .read<EmprestimoDetalheViewmodel>()
                      .desvincularDispositivoDoEmprestimo(
                        ed!.id!,
                        widget.idEmprestimo,
                      );
                  _controllerMap.remove(controllerKey);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFB00303),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                fixedSize: const Size(130, 30),
              ),
              child: Text('Remover', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (var controller in _numPatrimonioController) {
      controller.dispose();
    }
    for (var controller in _controllerMap.values) {
      controller.dispose();
    }
    super.dispose();
  }
}