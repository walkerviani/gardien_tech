import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum OpcaoEmprestimo { quantidade, unidade }

class EmprestimoFormScreen extends StatefulWidget {
  const EmprestimoFormScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EmprestimoFormScreenState();
}

class _EmprestimoFormScreenState extends State<EmprestimoFormScreen> {
  OpcaoEmprestimo opcaoView = OpcaoEmprestimo.quantidade;
  final List<TextEditingController> _controlador = [TextEditingController()];
  final List<bool> _isChecked = [false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empréstimo'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Responsável',
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Selecionar equipamentos por:',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SegmentedButton<OpcaoEmprestimo>(
                style: SegmentedButton.styleFrom(
                  backgroundColor: Colors.white,
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
                selected: <OpcaoEmprestimo>{opcaoView},
                onSelectionChanged: (Set<OpcaoEmprestimo> novaSelecao) {
                  setState(() {
                    opcaoView = novaSelecao.first;
                  });
                },
              ),
              if (opcaoView == OpcaoEmprestimo.quantidade)
                _buildPorQuantidade()
              else
                _buildPorUnidade(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPorQuantidade() {
    return Column(
      children: [
        SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Informe a quantidade', style: TextStyle(fontSize: 20)),
        ),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Quantidade',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }

  Widget _buildPorUnidade() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text('Devolvido', style: TextStyle(fontSize: 12)),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _controlador.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Botão de remover
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_controlador.length > 1) {
                          _controlador.removeAt(index);
                          _isChecked.removeAt(index);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(48, 48),
                      backgroundColor: const Color(0xFF2196F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Icon(Icons.remove, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  // Campo do número identificador
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Identificador',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  //Botão de adicionar
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _controlador.add(TextEditingController());
                        _isChecked.add(
                          false,
                        ); //Recebe o valor de falso ao iniciar um novo
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(48, 48),
                      backgroundColor: const Color(0xFF2196F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            value: _isChecked[index],
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked[index] = value!;
                              });
                            },
                            checkColor: Colors.white,
                            activeColor: const Color(0xFF2196F3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
