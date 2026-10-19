import 'package:flutter/material.dart';
import 'package:gardien_tech/presentation/views/ajuda_list_screen.dart';
import 'package:gardien_tech/presentation/views/dashboard_screen.dart';
import 'package:gardien_tech/presentation/views/historico_dispositivo_screen.dart';
import 'package:gardien_tech/presentation/views/import_dispositivo_csv_screen.dart';
import 'package:gardien_tech/presentation/views/selecionar_dispositivo_screen.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';
import 'package:provider/provider.dart';
import 'package:gardien_tech/presentation/views/dispositivo_list_screen.dart';
import 'package:gardien_tech/presentation/views/problema_list_screen.dart';
import 'package:gardien_tech/presentation/views/relatorios_screen.dart';
import 'package:gardien_tech/presentation/views/usuario_list_screen.dart';
import 'package:gardien_tech/presentation/viewmodels/backup_viewmodel.dart';

class FuncoesScreen extends StatelessWidget {
  const FuncoesScreen({super.key});

  Future<void> _realizarBackup(BuildContext context) async {
    final backupViewModel = context.read<BackupViewmodel>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    await backupViewModel.exportarBackup();
    if (navigator.canPop()) {
      navigator.pop();
    }

    if (backupViewModel.successMessage != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            backupViewModel.successMessage!,
            style: TextStyle(color: CoresGardien.branco),
          ),
          backgroundColor: CoresGardien.verdeClaro,
        ),
      );
      backupViewModel.clearMessages();
    } else if (backupViewModel.errorMessage != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            backupViewModel.errorMessage!,
            style: TextStyle(color: CoresGardien.branco),
          ),
          backgroundColor: CoresGardien.vermelhoClaro,
        ),
      );
      backupViewModel.clearMessages();
    }
  }

  Future<void> _restaurarBackup(BuildContext context) async {
    final backupViewModel = context.read<BackupViewmodel>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    await backupViewModel.restaurarBackup();

    messenger.clearSnackBars();

    if (navigator.canPop()) {
      navigator.pop();
    }

    if (backupViewModel.successMessage != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            backupViewModel.successMessage!,
            style: TextStyle(color: CoresGardien.branco),
          ),
          backgroundColor: CoresGardien.verdeClaro,
        ),
      );
      backupViewModel.clearMessages();
    } else if (backupViewModel.errorMessage != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            backupViewModel.errorMessage!,
            style: TextStyle(color: CoresGardien.branco),
          ),
          backgroundColor: CoresGardien.vermelhoClaro,
        ),
      );
      backupViewModel.clearMessages();
    }
  }

  void _mostrarDialogoBackup(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Deseja restaurar um backup?'),
        backgroundColor: CoresGardien.branco,
        content: const Text(
          'Tem certeza que deseja apagar os dados atuais e restaurar os dados salvos em um backup?',
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
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
              Navigator.pop(dialogContext);

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Carregando...')));

              _restaurarBackup(context);
            },
            child: const Text(
              'Restaurar',
              style: TextStyle(
                color: CoresGardien.vermelhoClaro,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> _buscarDispositivo(BuildContext context) async {
    return Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => SelecionarDispositivoScreen(null)),
    );
  }

  Future<void> _carregarHistoricoDispositivo(BuildContext context) async {
    final resultado = await _buscarDispositivo(context);

    if (!context.mounted) return;

    if (resultado == null) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Nenhum dispositivo selecionado'),
          backgroundColor: CoresGardien.vermelhoClaro,
        ),
      );
      return;
    }
    final int idDispositivo = resultado['idDispositivo'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistoricoDispositivoScreen(idDispositivo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),

      child: Column(
        children: [
          _botaoFuncao(
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UsuarioListScreen()),
            ),
            Icons.person,
            'Gerenciar usuários',
          ),
          const SizedBox(height: 10),
          _botaoFuncao(
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DispositivoListScreen()),
            ),
            Icons.devices,
            'Gerenciar dispositivos',
          ),
          const SizedBox(height: 10),
          _botaoFuncao(
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProblemaListScreen()),
            ),
            Icons.report_problem,
            'Gerenciar falhas em dispositivos',
          ),

          const SizedBox(height: 10),
          _botaoFuncao(
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RelatoriosScreen()),
            ),
            Icons.picture_as_pdf,
            'Exportar relatórios',
          ),
          const SizedBox(height: 10),
          _botaoFuncao(
            () => _realizarBackup(context),
            Icons.download,
            'Criar backup',
          ),
          const SizedBox(height: 10),
          _botaoFuncao(
            () => _mostrarDialogoBackup(context),
            Icons.backup_sharp,
            'Restaurar backup',
          ),
          const SizedBox(height: 10),
          _botaoFuncao(
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ImportDispositivoCsvScreen()),
            ),
            Icons.browser_updated,

            'Importar dispositivos por CSV',
          ),
          const SizedBox(height: 10),
          _botaoFuncao(
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DashboardScreen()),
            ),
            Icons.data_saver_off,
            'Indicadores',
          ),
          const SizedBox(height: 10),
          _botaoFuncao(
            () => _carregarHistoricoDispositivo(context),
            Icons.track_changes_rounded,
            'Histórico do dispositivo',
          ),
          const SizedBox(height: 10),
          _botaoFuncao(
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AjudaListScreen()),
            ),
            Icons.help,

            'Ajuda e informações',
          ),
        ],
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
