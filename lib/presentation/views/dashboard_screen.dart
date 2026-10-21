import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/enum/tipo_analise.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:gardien_tech/presentation/viewmodels/dashboard_viewmodel.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _indexTocado = -1;
  TipoAnalise _analiseAtual = TipoAnalise.emprestimos;

  static const _coresItensEmp = [
    CoresGardien.statusAtivo,
    CoresGardien.statusConcluido,
    CoresGardien.statusSemCorrespondencia,
    CoresGardien.statusEmObservacao,
  ];

  static const _coresDisp = [
    Colors.blue,
    Colors.teal,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.pink,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.indigoAccent,
    Colors.deepOrange,
  ];

  static const _coresUsu = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.red,
    Colors.purple,
  ];

  // Adiciona a cor para cada tipo
  Color _corDisp(TipoDispositivo tipo) =>
      _coresDisp[tipo.index % _coresDisp.length];

  // Adiciona uma cor para cada um do top 5 e cinza se for 'Outros'
  Color _corUsu(String nome, int i) => nome == DashboardViewmodel.rotuloOutros
      ? Colors.grey
      : _coresUsu[i % _coresUsu.length];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewmodel = context.read<DashboardViewmodel>();
      viewmodel.buscarDadosGraficoEmp();
      viewmodel.buscarDadosGraficoDisp();
      viewmodel.buscarDadosGraficoUsu();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Métricas'),
        backgroundColor: CoresGardien.azulClaro,
        foregroundColor: CoresGardien.branco,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              SegmentedButton<TipoAnalise>(
                style: SegmentedButton.styleFrom(
                  foregroundColor: CoresGardien.azulClaro,
                  selectedForegroundColor: CoresGardien.branco,
                  selectedBackgroundColor: CoresGardien.azulClaro,
                ),
                showSelectedIcon: false,
                segments: TipoAnalise.values
                    .map(
                      (tipo) =>
                          ButtonSegment(value: tipo, label: Text(tipo.rotulo)),
                    )
                    .toList(),
                selected: {_analiseAtual},
                onSelectionChanged: (selecao) {
                  setState(() {
                    _analiseAtual = selecao.first;
                    _indexTocado = -1;
                  });
                },
              ),
              const SizedBox(height: 15),
              Consumer<DashboardViewmodel>(
                builder: (context, viewmodel, _) {
                  return _counteudoSelecionado(viewmodel);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _counteudoSelecionado(DashboardViewmodel viewmodel) {
    switch (_analiseAtual) {
      case TipoAnalise.dispositivos:
        return _carregarGraficoDispositivo(viewmodel);
      case TipoAnalise.emprestimos:
        return _carregarGraficoEmprestimo(viewmodel);
      case TipoAnalise.usuarios:
        return _carregarGraficoUsuario(viewmodel);
    }
  }

  Widget _carregarGraficoDispositivo(DashboardViewmodel viewmodel) {
    if (viewmodel.isLoadingDisp) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewmodel.errorMessageDisp != null) {
      return Center(child: Text(viewmodel.errorMessageDisp!));
    }
    if (viewmodel.dadosDisp.values.every((v) => v == 0)) {
      return const Center(child: Text('Nenhum dispositivo cadastrado'));
    }

    final entradas = viewmodel.dadosDisp.entries
        .where((e) => e.value > 0)
        .toList();
    final total = entradas.fold(0, (soma, e) => soma + e.value);
    return Column(
      children: [
        Text(
          'Análise dos Dispositivos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'Total: $total dispositivos',
          style: const TextStyle(fontSize: 18),
        ),
        _graficoDisp(entradas, total),
        const SizedBox(height: 10),
        _dicaGrafico(),
        const SizedBox(height: 15),
        _legendaGraficoDisp(entradas),
      ],
    );
  }

  Widget _graficoDisp(
    List<MapEntry<TipoDispositivo, int>> entradas,
    int total,
  ) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              final secao = response?.touchedSection;
              if (event is FlTapUpEvent && secao != null) {
                setState(() {
                  _indexTocado = secao.touchedSectionIndex;
                });
              }
            },
          ),
          sections: List.generate(entradas.length, (i) {
            final valor = entradas[i].value;
            final estaTocado = i == _indexTocado;
            final porcentagem = total == 0 ? 0 : valor / total * 100;

            return PieChartSectionData(
              value: valor.toDouble(),
              color: _corDisp(entradas[i].key),
              radius: estaTocado ? 70 : 60,
              title: estaTocado
                  ? valor.toString()
                  : '${porcentagem.toStringAsFixed(1)}%',
              titleStyle: TextStyle(
                fontSize: estaTocado ? 18 : 14,
                fontWeight: FontWeight.bold,
                color: CoresGardien.branco,
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _legendaGraficoDisp(List<MapEntry<TipoDispositivo, int>> entradas) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: entradas.map((e) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 12, color: _corDisp(e.key)),
            const SizedBox(width: 6),
            Text(e.key.nomeTipo),
          ],
        );
      }).toList(),
    );
  }

  Widget _carregarGraficoUsuario(DashboardViewmodel viewmodel) {
    if (viewmodel.isLoadingUsu) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewmodel.errorMessageUsu != null) {
      return Center(child: Text(viewmodel.errorMessageUsu!));
    }
    if (viewmodel.dadosUsu.values.every((v) => v == 0)) {
      return const Center(child: Text('Nenhum empréstimo registrado'));
    }

    final entradas = viewmodel.dadosUsuTop.entries.toList();
    final total = entradas.fold(0, (soma, e) => soma + e.value);
    return Column(
      children: [
        Text(
          'Análise dos Usuários',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'Top 5 usuários com mais empréstimos',
          style: const TextStyle(fontSize: 18),
        ),
        _graficoUsuario(entradas, total),
        const SizedBox(height: 10),
        _dicaGrafico(),
        const SizedBox(height: 15),
        _legendaGraficoUsuario(entradas),
      ],
    );
  }

  Widget _graficoUsuario(List<MapEntry<String, int>> entradas, int total) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              final secao = response?.touchedSection;
              if (event is FlTapUpEvent && secao != null) {
                setState(() {
                  _indexTocado = secao.touchedSectionIndex;
                });
              }
            },
          ),
          sections: List.generate(entradas.length, (i) {
            final valor = entradas[i].value;
            final estaTocado = i == _indexTocado;
            final porcentagem = total == 0 ? 0 : valor / total * 100;

            return PieChartSectionData(
              value: valor.toDouble(),
              color: _corUsu(entradas[i].key, i),
              radius: estaTocado ? 70 : 60,
              title: estaTocado
                  ? valor.toString()
                  : '${porcentagem.toStringAsFixed(1)}%',
              titleStyle: TextStyle(
                fontSize: estaTocado ? 18 : 14,
                fontWeight: FontWeight.bold,
                color: CoresGardien.branco,
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _legendaGraficoUsuario(List<MapEntry<String, int>> entradas) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: List.generate(entradas.length, (i) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              color: _corUsu(entradas[i].key, i),
            ),
            const SizedBox(width: 6),
            const SizedBox(width: 6),
            Flexible(
              child: Text(entradas[i].key, overflow: TextOverflow.ellipsis),
            ),
          ],
        );
      }),
    );
  }

  Widget _carregarGraficoEmprestimo(DashboardViewmodel viewmodel) {
    if (viewmodel.isLoadingEmp) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewmodel.errorMessageEmp != null) {
      return Center(child: Text(viewmodel.errorMessageEmp!));
    }
    if (viewmodel.dadosEmp.isEmpty) {
      return const Center(child: Text('Sem dados'));
    }
    if (viewmodel.dadosEmp.values.every((v) => v == 0)) {
      return const Center(child: Text('Nenhum empréstimo registrado'));
    }
    final totalGeral = viewmodel.qntTotalEmprestimo ?? 0;
    final somaFatias = viewmodel.dadosEmp.values.fold(0, (a, b) => a + b);
    final entradas = viewmodel.dadosEmp.entries.toList();
    return Column(
      children: [
        Text(
          'Análise dos Empréstimos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'Total: $totalGeral empréstimos',
          style: const TextStyle(fontSize: 18),
        ),
        _graficoEmp(entradas, somaFatias),
        const SizedBox(height: 10),
        _dicaGrafico(),
        const SizedBox(height: 15),
        _legendaGraficoEmp(entradas),
      ],
    );
  }

  Widget _graficoEmp(List<MapEntry<String, int>> entradas, int somaFatias) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              final secao = response?.touchedSection;
              if (event is FlTapUpEvent && secao != null) {
                setState(() {
                  _indexTocado = secao.touchedSectionIndex;
                });
              }
            },
          ),
          sections: List.generate(entradas.length, (i) {
            final valor = entradas[i].value;
            final estaTocado = i == _indexTocado;
            final porcentagem = somaFatias == 0 ? 0 : valor / somaFatias * 100;

            return PieChartSectionData(
              value: valor.toDouble(),
              color:
                  _coresItensEmp[i %
                      _coresItensEmp
                          .length], // Previne que uma possivel nova secao busque uma cor invalida
              radius: estaTocado ? 70 : 60,
              title: estaTocado
                  ? valor.toString()
                  : '${porcentagem.toStringAsFixed(1)}%',
              titleStyle: TextStyle(
                fontSize: estaTocado ? 18 : 14,
                fontWeight: FontWeight.bold,
                color: CoresGardien.branco,
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _legendaGraficoEmp(List<MapEntry<String, int>> entradas) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: List.generate(entradas.length, (i) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              color: _coresItensEmp[i % _coresItensEmp.length],
            ),
            const SizedBox(width: 6),
            Text(entradas[i].key),
          ],
        );
      }),
    );
  }

  Widget _dicaGrafico() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.touch_app_outlined, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            'Toque em uma fatia para ver a quantidade',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }
}
