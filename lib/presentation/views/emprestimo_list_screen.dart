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

  String get dataSelecionada =>
      DateFormat('dd/MM/yyyy').format(_dataController);

  Color _colorStatus(int statusId) {
    switch (statusId) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.deepOrangeAccent;
      case 3:
        return Colors.blueGrey;
      case 4:
        return const Color(0xFFAB1308);
      default:
        return Colors.black;
    }
  }

  String _dataFormatada(DateTime data) {
    return DateFormat('dd/MM/yyyy').format(data);
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
                      backgroundColor: Colors.white,
                      content: Container(
                        height: 250,
                        width: 300,
                        color: Colors.white,
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
                          backgroundColor: Colors.white,
                          minimumYear: DateTime.now().year - 3,
                          maximumYear: DateTime.now().year + 3,
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
                            style: TextStyle(color: Color(0xFF2196F3)),
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
                            style: TextStyle(color: Color(0xFF000000)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  dataSelecionada,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          /*
            Container de informação sobre os status do empréstimo
          */
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Entenda a cor de cada cartão: '),
                IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Status do Empréstimo'),
                      content: RichText(
                        text: TextSpan(
                          text:
                              'O status é apresentado através da cor do cartão:\n\n',
                          style: TextStyle(color: Colors.black, fontSize: 17),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Ativo ',
                              style: TextStyle(
                                color: _colorStatus(1),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '- O empréstimo está em aberto.\n',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            TextSpan(
                              text: 'Em Observação ',
                              style: TextStyle(
                                color: _colorStatus(2),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '- O empréstimo já passou de um dia.\n',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            TextSpan(
                              text: 'Concluído ',
                              style: TextStyle(
                                color: _colorStatus(3),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '- O empréstimo foi finalizado.\n',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            TextSpan(
                              text: 'Sem Correspondência ',
                              style: TextStyle(
                                color: _colorStatus(4),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '- Há dispositivos que não foram vinculados e atualmente não há como identificar os dispositivos que estavam no empréstimo.\n',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            TextSpan(
                              text: 'Erro ',
                              style: TextStyle(
                                color: _colorStatus(0),
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '- Algo deu errado.\n',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
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
                  ),
                  icon: Icon(Icons.help_outline),
                ),
              ],
            ),
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
                    String nomeCortado = emprestimo.nomeUsuario.length > 15
                        ? '${emprestimo.nomeUsuario.substring(0, 12)}...'
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
                                      '${_dataFormatada(emprestimo.dataHoraEfetuado)} - $nomeCortado',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '$usuarioCargo\n${emprestimo.qtdSolicitada} $dispositivoStr',
                                      style: TextStyle(
                                        color: Colors.white,
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
                                    color: Colors.white,
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
