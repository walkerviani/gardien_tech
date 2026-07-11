import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/enum/emprestimo_status.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:gardien_tech/presentation/extentions/dispositivo_search_formatter.dart';
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
  late final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmprestimoDetalheViewmodel>().carregarItensDoEmprestimo(
        widget.idEmprestimo,
      );
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
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
                    itemCount: viewmodel.itensParaExibir.length,
                    itemBuilder: ((context, index) {
                      final itemDoDTO = viewmodel.itensParaExibir[index];
                      final emprestimoItem = itemDoDTO.item;
                      final bool ehQuantitativo = emprestimoItem.ehQuantitativo;
                      final tipoDispositivo =
                          TipoDispositivo.values
                              .where(
                                (tipo) =>
                                    tipo.id == emprestimoItem.idTipoDispositivo,
                              )
                              .firstOrNull
                              ?.nomeTipo ??
                          'Tipo não encontrado';
                      if (_controllers.length <= index) {
                        _controllers.add(TextEditingController());
                      }
                      _controllers[index].text =
                          !ehQuantitativo &&
                              itemDoDTO.dispositivosObj.isNotEmpty
                          ? itemDoDTO.dispositivosObj.first.numPatrimonio
                          : '';

                      return Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child:
                                          /*
                                      Campo do número de patrimônio
                                      */
                                          TextFormField(
                                            enabled: ehQuantitativo,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                            controller: _controllers[index],
                                            canRequestFocus: ehQuantitativo,
                                            readOnly: !ehQuantitativo,
                                            onChanged: (value) {
                                              if (ehQuantitativo) {
                                                context
                                                    .read<
                                                      EmprestimoDetalheViewmodel
                                                    >()
                                                    .buscarDispositivo(
                                                      value,
                                                      emprestimoItem
                                                          .idTipoDispositivo,
                                                      index,
                                                    );
                                              }
                                            },
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: ehQuantitativo
                                                  ? Colors.black
                                                  : const Color(0xFF686767),
                                            ),
                                          ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      flex: 2,
                                      child:
                                          /*
                                      Campo do tipo de dispositivo
                                      */
                                          TextField(
                                            enabled: ehQuantitativo,
                                            readOnly: true,
                                            canRequestFocus: false,
                                            controller: TextEditingController(
                                              text: tipoDispositivo,
                                            ),
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: ehQuantitativo
                                                  ? Colors.black
                                                  : const Color(0xFF686767),
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              /*
                              Dropdown dos resultados da pesquisa
                              */
                              Consumer<EmprestimoDetalheViewmodel>(
                                builder: (context, viewmodel, _) {
                                  if (viewmodel.dispositivosPesquisa.isEmpty ||
                                      viewmodel.indexEmPesquisa != index) {
                                    return SizedBox.shrink();
                                  }
                                  return Material(
                                    elevation: 3,
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxHeight: 150,
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: viewmodel
                                            .dispositivosPesquisa
                                            .length,
                                        itemBuilder: (context, index) {
                                          final dispositivo = viewmodel
                                              .dispositivosPesquisa[index];
                                          return ListTile(
                                            title: Text(
                                              dispositivo.descricaoBusca,
                                            ),
                                            onTap: () {
                                              if (dispositivo.tipo.id !=
                                                  emprestimoItem
                                                      .idTipoDispositivo) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'O dispositivo precisa ser do mesmo tipo',
                                                    ),
                                                    backgroundColor: Color(
                                                      0xFFB00303,
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }

                                              viewmodel.selecionarDispositivo(
                                                dispositivo,
                                                itemDoDTO.item.id!,
                                                widget.idEmprestimo,
                                              );

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '${dispositivo.descricaoBusca} adicionado!',
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),

                              /*
                              Checkbox de devolvido
                              */
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Devolvido: '),
                                  Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: const Color(0xFF006dc4),
                                    value: emprestimoItem.estaResolvido,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        emprestimoItem.estaResolvido = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 50),
                                  /*
                                  Botão de remover
                                  */
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFFB00303),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      fixedSize: const Size(130, 30),
                                    ),
                                    child: Text(
                                      'Remover',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
