import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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

  static const _coresItensEmp = [
    CoresGardien.statusAtivo,
    CoresGardien.statusConcluido,
    CoresGardien.statusSemCorrespondencia,
    CoresGardien.statusEmObservacao,
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewmodel>().buscarDadosGrafico();
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
          child: Consumer<DashboardViewmodel>(
            builder: (context, viewmodel, _) {
              if (viewmodel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (viewmodel.errorMessage != null) {
                return Center(child: Text(viewmodel.errorMessage!));
              }
              if (viewmodel.dadosEmp.isEmpty) {
                return const Center(child: Text('Sem dados'));
              }

              return _carregarGraficoEmprestimo(viewmodel);
            },
          ),
        ),
      ),
    );
  }

  Widget _carregarGraficoEmprestimo(DashboardViewmodel viewmodel) {
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
        AspectRatio(
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
                final porcentagem = somaFatias == 0
                    ? 0
                    : valor / somaFatias * 100;

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
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.touch_app_outlined,
              size: 16,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'Toque em uma fatia para ver a quantidade',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),
        Wrap(
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
        ),
      ],
    );
  }
}
