import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';

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
  final ScrollController _scrollController = ScrollController();
  final List<_ItemQuantidade> _itensQuantidade = [
    _ItemQuantidade(
      tipoCargo: TipoDispositivo.notebook.nomeTipo,
      quantidade: TextEditingController(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
          SizedBox(height: 8),
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
            selected: <OpcaoEmprestimo>{opcaoView},
            onSelectionChanged: (Set<OpcaoEmprestimo> novaSelecao) {
              setState(() {
                opcaoView = novaSelecao.first;
              });
            },
          ),
          SizedBox(height: 12),
          if (opcaoView == OpcaoEmprestimo.quantidade)
            _buildPorQuantidade()
          else
            _buildPorUnidade(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
          child: ElevatedButton(
            onPressed: () {
              // TODO: criar empréstimo
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
  }

  Widget _buildPorQuantidade() {
  return Column(
    children: [
      ...List.generate(_itensQuantidade.length, (index) {
        return Padding(
          key: _itensQuantidade[index].key, // Identificador único de cada widget

          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Tipo de dispositivo:', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 20),
                    Expanded(
                      child: DropdownMenuFormField<TipoDispositivo>(
                        label: const Text('Tipo'),
                        menuHeight: 200,
                        dropdownMenuEntries: TipoDispositivo.values.map((t) {
                          return DropdownMenuEntry(value: t, label: t.nomeTipo);
                        }).toList(),
                        onSelected: (valor) {
                          setState(() {
                            _itensQuantidade[index].tipoCargo = valor?.nomeTipo ?? _itensQuantidade[index].tipoCargo;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('Informe a quantidade:', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        controller: _itensQuantidade[index].quantidade,
                        decoration: InputDecoration(border: OutlineInputBorder()), 
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          setState(() {
                            _itensQuantidade[index].mostrarAviso = (int.tryParse(value) ?? 0) >= 100;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                if (_itensQuantidade[index].mostrarAviso) 
                  Row(
                    children: [
                      Expanded(
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
                                    fontSize: 18,
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
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _itensQuantidade.removeAt(index);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB00303),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    label: Text('Remover'),
                    icon: Icon(Icons.remove)
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      SizedBox(height: 8),
      Align(
        alignment: Alignment.center,
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _itensQuantidade.add(
                _ItemQuantidade(
                  tipoCargo: '',
                  quantidade: TextEditingController(),
                ),
              );
            });

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
          icon: Icon(Icons.add)
        ),
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
        ...List.generate(_controlador.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                Expanded(
                  child: TextField(
                    controller: _controlador[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Identificador',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _controlador.add(TextEditingController());
                      _isChecked.add(false);
                    });

                    Future.delayed(Duration(milliseconds: 100), () {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
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
                Transform.scale(
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
              ],
            ),
          );
        }),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (var c in _controlador) {
      c.dispose();
    }
    super.dispose();
  }
}

class _ItemQuantidade {
    String? tipoCargo;
    bool mostrarAviso= false;
    TextEditingController quantidade;
    final Key key= UniqueKey();

    _ItemQuantidade({required this.tipoCargo, required this.quantidade});
}