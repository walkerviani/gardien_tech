import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/enum/tipo_cargo.dart';
import 'package:gardien_tech/presentation/viewmodels/emprestimo_list_viewmodel.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmprestimoListViewmodel>().carregarEmprestimosDoDia(
        _dataController,
      );
    });
  }

  String get dataSelecionada =>
      DateFormat('dd/MM/yyyy').format(_dataController);

  Color _colorStatus(int statusId) {
    switch (statusId) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.brown;
      case 3:
        return Colors.cyan;
      default:
        return Colors.red;
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
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        TextButton(
                          onPressed: () {
                            context
                                .read<EmprestimoListViewmodel>()
                                .carregarEmprestimosDoDia(_dataController);
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Salvar',
                            style: TextStyle(color: Color(0xFF000000)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF006dc4),
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
                      text: 'O status é apresentado através da cor do cartão:\n\n',
                      style: TextStyle(color: Colors.black, fontSize: 17), 
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Ativo ',
                          style: TextStyle(color: _colorStatus(1), fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '- O empréstimo está em aberto\n',
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                        TextSpan(
                          text: 'Em Observação ',
                          style: TextStyle(color: _colorStatus(2), fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '- O empréstimo já passou de um dia\n',
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                        TextSpan(
                          text: 'Concluído ',
                          style: TextStyle(color: _colorStatus(3), fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '- O empréstimo foi finalizado\n',
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                        TextSpan(
                          text: 'Erro ',
                          style: TextStyle(color: _colorStatus(0), fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: '- Algo deu errado\n',
                          style: TextStyle(color: Colors.black, fontSize: 17),
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
                                onPressed: () {},
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
