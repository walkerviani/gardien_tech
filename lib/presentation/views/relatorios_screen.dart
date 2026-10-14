import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';
import 'package:gardien_tech/presentation/viewmodels/relatorios_viewmodel.dart';
import 'package:gardien_tech/presentation/views/selecionar_usuario_screen.dart';
import 'package:gardien_tech/presentation/views/visualizar_pdf_screen.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RelatoriosScreen extends StatelessWidget {
  const RelatoriosScreen({super.key});

  Future<void> _carregarRelatorioDispositivos(
    RelatoriosViewmodel viewmodel,
    BuildContext context,
  ) async {
    final bytes = await viewmodel.gerarRelatorioDispositivos();

    if (!context.mounted) return;

    if (bytes == null) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            viewmodel.errorMessage ?? 'Não foi possível gerar o PDF',
          ),
          backgroundColor: CoresGardien.vermelhoClaro,
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
  }

  Future<void> _carregarRelatorioProblemas(
    RelatoriosViewmodel viewmodel,
    BuildContext context,
  ) async {
    final bytes = await viewmodel.gerarRelatorioProblemas();

    if (!context.mounted) return;

    if (bytes == null) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            viewmodel.errorMessage ?? 'Não foi possível gerar o PDF',
          ),
          backgroundColor: CoresGardien.vermelhoClaro,
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
  }

  Future<Usuario?> _buscarUsuario(BuildContext context) async {
    final usuario = await Navigator.push<Usuario>(
      context,
      MaterialPageRoute(builder: (_) => SelecionarUsuarioScreen()),
    );
    return usuario;
  }

  Future<void> _carregarRelatorioUsuario(
    RelatoriosViewmodel viewmodel,
    BuildContext context,
  ) async {
    final usuario = await _buscarUsuario(context);

    if (usuario == null) return;

    final bytes = await viewmodel.gerarRelatorioEmpUsuario(usuario);
    if (!context.mounted) return;
    if (bytes == null) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            viewmodel.errorMessage ?? 'Não foi possível gerar o PDF',
          ),
          backgroundColor: CoresGardien.vermelhoClaro,
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
  }

  Future<void> _carregarRelatorioData(
    RelatoriosViewmodel viewmodel,
    BuildContext context,
  ) async {
    DateTime? dataSelecionada = await _exibirSeletorData(context);

    if (dataSelecionada == null) return;

    String dataFormatada = DateFormat('dd/MM/yyyy').format(dataSelecionada);

    final bytes = await viewmodel.gerarRelatorioEmpDia(dataSelecionada);

    if (!context.mounted) return;

    if (bytes == null) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            viewmodel.errorMessage ?? 'Não foi possível gerar o PDF',
          ),
          backgroundColor: CoresGardien.vermelhoClaro,
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
  }

  Future<DateTime?> _exibirSeletorData(BuildContext context) async {
    DateTime dataSelecionada = DateTime.now();

    return await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Selecione a data'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: CoresGardien.branco,
        content: Container(
          height: 250,
          width: 300,
          color: CoresGardien.branco,
          child: CupertinoDatePicker(
            // Calendário
            initialDateTime: dataSelecionada,
            mode: CupertinoDatePickerMode.date,
            dateOrder: DatePickerDateOrder.dmy,
            onDateTimeChanged: (novaData) {
              dataSelecionada = novaData;
            },
            backgroundColor: CoresGardien.branco,
            minimumYear: DateTime.now().year - 3,
            maximumYear: DateTime.now().year,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: CoresGardien.preto,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext, dataSelecionada);
            },
            child: Text(
              'Selecionar',
              style: TextStyle(
                color: CoresGardien.azulClaro,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<RelatoriosViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        backgroundColor: CoresGardien.azulClaro,
        foregroundColor: CoresGardien.branco,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            _botaoFuncao(
              () => _carregarRelatorioData(viewmodel, context),
              Icons.calendar_month_outlined,
              'Empréstimos por data',
            ),

            const SizedBox(height: 10),

            _botaoFuncao(
              () => _carregarRelatorioUsuario(viewmodel, context),
              Icons.content_paste_search_outlined,
              'Empréstimos por usuário',
            ),

            const SizedBox(height: 10),

            _botaoFuncao(
              () => _carregarRelatorioProblemas(viewmodel, context),
              Icons.report_problem_outlined,
              'Problemas relatados',
            ),

            const SizedBox(height: 10),

            _botaoFuncao(
              () => _carregarRelatorioDispositivos(viewmodel, context),
              Icons.devices_rounded,
              'Dispositivos cadastrados',
            ),
          ],
        ),
      ),
    );
  }

  Widget _botaoFuncao(VoidCallback funcao, IconData icone, String descricao) {
    return ElevatedButton(
      onPressed: funcao,
      style: ElevatedButton.styleFrom(
        backgroundColor: CoresGardien.azulEscuro,
        foregroundColor: CoresGardien.branco,
        minimumSize: const Size(double.infinity, 70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(5),
        child: Row(
          children: [
            Icon(icone, size: 30),
            SizedBox(width: 20),
            Expanded(child: Text(descricao, style: TextStyle(fontSize: 18))),
          ],
        ),
      ),
    );
  }
}
