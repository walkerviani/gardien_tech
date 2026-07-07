import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  }

  String get dataSelecionada =>
      DateFormat('dd/MM/yyyy').format(_dataController);

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
                          onPressed: () => Navigator.pop(context),
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
          const SizedBox(height: 12),

          Card(
            color: Color(0xFF006dc4),
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
                            '08:23 - Marcela (Professor)',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '10 Dispositivos',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Ativo',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Clique para mais detalhes',
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
          ),
        ],
      ),
    );
  }
}
