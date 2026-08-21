import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/enum/tipo_cargo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_item_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_repository.dart';
import 'package:gardien_tech/domain/services/emprestimo_service.dart';
import 'package:gardien_tech/presentation/viewmodels/emprestimo_detalhe_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/emprestimo_list_viewmodel.dart';
import 'package:gardien_tech/presentation/views/emprestimo_detalhe_screen.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EmprestimoListScreen extends StatefulWidget {
  const EmprestimoListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EmprestimoListScreenState();
}

class _EmprestimoListScreenState extends State<EmprestimoListScreen> {
  late DateTime _dataController;

  @override
  void initState() {
    super.initState();
    _dataController = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewmodel = context.read<EmprestimoListViewmodel>();
      await viewmodel.definirEmObservacao();
      await viewmodel.carregarEmprestimosDoDia(_dataController);
    });
  }

  Color _colorStatus(int statusId) {
    switch (statusId) {
      case 1:
        return CoresGardien.statusAtivo;
      case 2:
        return CoresGardien.statusEmObservacao;
      case 3:
        return CoresGardien.statusConcluido;
      case 4:
        return CoresGardien.statusSemCorrespondencia;
      default:
        return CoresGardien.statusErro;
    }
  }

  String _dataFormatada(DateTime data) {
    return DateFormat('dd/MM/yyyy').format(data);
  }

  String _dataHoraFormatada(DateTime data) {
    return DateFormat('dd/MM/yyyy - HH:mm').format(data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Data de visualização atual: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              /*
              Botão da data selecionada
              */
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Selecione a data'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: CoresGardien.branco,
                      content: Container(
                        height: 250,
                        width: 300,
                        color: CoresGardien.branco,
                        child: CupertinoDatePicker(
                          // Calendário
                          initialDateTime: _dataController,
                          mode: CupertinoDatePickerMode.date,
                          dateOrder: DatePickerDateOrder.dmy,
                          onDateTimeChanged: (DateTime data) {
                            setState(() {
                              _dataController = data;
                            });
                          },
                          backgroundColor: CoresGardien.branco,
                          minimumYear: DateTime.now().year - 3,
                          maximumYear: DateTime.now().year,
                        ),
                      ),
                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _dataController = DateTime.now();
                            });
                            context
                                .read<EmprestimoListViewmodel>()
                                .carregarEmprestimosDoDia(_dataController);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Selecionar Dia Atual',
                            style: TextStyle(color: CoresGardien.azulClaro),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<EmprestimoListViewmodel>()
                                .carregarEmprestimosDoDia(_dataController);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Selecionar',
                            style: TextStyle(color: CoresGardien.preto),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: CoresGardien.azulClaro,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _dataFormatada(_dataController),
                  style: TextStyle(
                    color: CoresGardien.branco,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<EmprestimoListViewmodel>(
              builder: (context, viewmodel, child) {
                if (viewmodel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (viewmodel.emprestimos.isEmpty) {
                  return const Text('Nenhum empréstimo encontrado');
                }
                return ListView.builder(
                  itemCount: viewmodel.emprestimos.length,
                  itemBuilder: (context, index) {
                    final emprestimo = viewmodel.emprestimos[index];
                    final usuarioCargo =
                        TipoCargo.values
                            .where(
                              (cargo) => cargo.id == emprestimo.idTipoCargo,
                            )
                            .firstOrNull
                            ?.nomeCargo ??
                        'Cargo não encontrado';
                    final dispositivoStr = emprestimo.qtdSolicitada > 1
                        ? 'Dispositivos'
                        : 'Dispositivo';
                    String nomeCortado = emprestimo.nomeUsuario.length > 20
                        ? '${emprestimo.nomeUsuario.substring(0, 20)}...'
                        : emprestimo.nomeUsuario;
                    return Card(
                      color: _colorStatus(emprestimo.idStatusEmprestimo),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _dataHoraFormatada(
                                        emprestimo.dataHoraEfetuado,
                                      ),
                                      style: TextStyle(
                                        color: CoresGardien.branco,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      nomeCortado,
                                      style: TextStyle(
                                        color: CoresGardien.branco,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '$usuarioCargo\n${emprestimo.qtdSolicitada} $dispositivoStr',
                                      style: TextStyle(
                                        color: CoresGardien.branco,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChangeNotifierProvider(
                                        create: (context) =>
                                            EmprestimoDetalheViewmodel(
                                              context
                                                  .read<
                                                    EmprestimoItemRepository
                                                  >(),
                                              context
                                                  .read<EmprestimoRepository>(),
                                              context.read<EmprestimoService>(),
                                              context
                                                  .read<
                                                    DispositivoRepository
                                                  >(),
                                              context
                                                  .read<
                                                    EmprestimoDispositivoRepository
                                                  >(),
                                            ),
                                        child: EmprestimoDetalheScreen(
                                          idEmprestimo: emprestimo.idEmprestimo,
                                          dataHoraEfetuado:
                                              emprestimo.dataHoraEfetuado,

                                          nomeResponsavel:
                                              emprestimo.nomeUsuario,
                                          idStatus:
                                              emprestimo.idStatusEmprestimo,
                                          dataHoraConcluido:
                                              emprestimo.dataHoraConcluido,
                                        ),
                                      ),
                                    ),
                                  ).then((_) {
                                    // Executado quando o usuário volta da tela de detalhes (Navigator.pop)
                                    if (context.mounted) {
                                      context
                                          .read<EmprestimoListViewmodel>()
                                          .carregarEmprestimosDoDia(
                                            _dataController,
                                          );
                                    }
                                  });
                                },
                                child: Text(
                                  'Clique aqui para mais detalhes',
                                  style: TextStyle(
                                    color: CoresGardien.branco,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
