import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';
import 'package:gardien_tech/presentation/viewmodels/relatorios_viewmodel.dart';
import 'package:gardien_tech/presentation/views/selecionar_usuario_screen.dart';
import 'package:gardien_tech/presentation/views/visualizar_pdf_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RelatoriosScreen extends StatelessWidget {
  const RelatoriosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<RelatoriosViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                DateTime dataSelecionada = DateTime.now();
                String dataFormatada = DateFormat(
                  'dd/MM/yyyy',
                ).format(dataSelecionada);

                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
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
                        initialDateTime: dataSelecionada,
                        mode: CupertinoDatePickerMode.date,
                        dateOrder: DatePickerDateOrder.dmy,
                        onDateTimeChanged: (novaData) {
                          dataSelecionada = novaData;
                        },
                        backgroundColor: Colors.white,
                        minimumYear: DateTime.now().year - 3,
                        maximumYear: DateTime.now().year + 3,
                      ),
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(dialogContext);
                          final bytes = await viewmodel.gerarRelatorioEmpDia(
                            dataSelecionada,
                          );

                          if (!context.mounted) return;

                          if (bytes == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  viewmodel.errorMessage ??
                                      'Não foi possível gerar o PDF',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VisualizarPdfScreen(
                                'Empréstimos por data',
                                (format) async => bytes,
                                'relatorio_emprestimos_$dataFormatada',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Selecionar',
                          style: TextStyle(color: Color(0xFF000000)),
                        ),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006dc4),
                foregroundColor: const Color(0xFFFFFFFF),
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_month_outlined, size: 30),
                  SizedBox(width: 20),
                  Text('Empréstimos por data', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final usuario = await Navigator.push<Usuario>(
                  context,
                  MaterialPageRoute(builder: (_) => SelecionarUsuarioScreen()),
                );
                if (usuario == null) return;

                final bytes = await viewmodel.gerarRelatorioEmpUsuario(usuario);
                if (!context.mounted) return;
                if (bytes == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        viewmodel.errorMessage ??
                            'Não foi possível gerar o PDF',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VisualizarPdfScreen(
                      'Empréstimos ${usuario.nome}',
                      (format) async => bytes,
                      'relatorio_emprestimos_${usuario.nome}',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006dc4),
                foregroundColor: const Color(0xFFFFFFFF),
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.content_paste_search_outlined, size: 30),
                  SizedBox(width: 20),
                  Text(
                    'Empréstimos por usuário',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final bytes = await viewmodel.gerarRelatorioProblemas();

                if (!context.mounted) return;

                if (bytes == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        viewmodel.errorMessage ??
                            'Não foi possível gerar o PDF',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VisualizarPdfScreen(
                      'Problemas relatados',
                      (format) async => bytes,
                      'relatorio_problemas',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006dc4),
                foregroundColor: const Color(0xFFFFFFFF),
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.report_problem_outlined, size: 30),
                  SizedBox(width: 20),
                  Text('Problemas relatados', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final bytes = await viewmodel.gerarRelatorioDispositivos();

                if (!context.mounted) return;

                if (bytes == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        viewmodel.errorMessage ??
                            'Não foi possível gerar o PDF',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VisualizarPdfScreen(
                      'Dispositivos cadastrados',
                      (format) async => bytes,
                      'relatorio_dispositivos',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006dc4),
                foregroundColor: const Color(0xFFFFFFFF),
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.devices_rounded, size: 30),
                  SizedBox(width: 20),
                  Text(
                    'Dispositivos cadastrados',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
