import 'package:flutter/material.dart';
import 'package:gardien_tech/presentation/views/import_dispositivo_csv_screen.dart';
import 'package:provider/provider.dart';
import 'package:gardien_tech/presentation/views/dispositivo_list_screen.dart';
import 'package:gardien_tech/presentation/views/problema_list_screen.dart';
import 'package:gardien_tech/presentation/views/relatorios_screen.dart';
import 'package:gardien_tech/presentation/views/usuario_list_screen.dart';
import 'package:gardien_tech/presentation/viewmodels/backup_viewmodel.dart';

class FuncoesScreen extends StatelessWidget {
  const FuncoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),

      child: Column(
        children: [
          /*
          Botão de gerenciamento dos usuários
           */
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UsuarioListScreen()),
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
                Icon(Icons.person, size: 30),
                SizedBox(width: 20),
                Text('Gerenciar usuários', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          /*
          Botão de gerenciamento dos dispositivos
           */
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DispositivoListScreen()),
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
                Icon(Icons.devices, size: 30),
                SizedBox(width: 20),
                Text('Gerenciar dispositivos', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          /*
          Botão de visualizar problemas relatados
           */
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProblemaListScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006dc4),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.report_problem, size: 30),
                SizedBox(width: 20),
                Text(
                  'Dispositivos com problemas',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          /*
          Botão de exportar relatórios
          */
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RelatoriosScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006dc4),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf, size: 30),
                SizedBox(width: 20),
                Text('Exportar relatórios', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          /*
          Botão de criar backup
          */
          ElevatedButton(
            onPressed: () async {
              final backupViewModel = context.read<BackupViewmodel>();
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Exportando backup...'),
                      ],
                    ),
                  );
                },
              );

              await backupViewModel.exportarBackup();
              if (navigator.canPop()) {
                navigator.pop();
              }

              if (backupViewModel.successMessage != null) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      backupViewModel.successMessage!,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                backupViewModel.clearMessages();
              } else if (backupViewModel.errorMessage != null) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      backupViewModel.errorMessage!,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                backupViewModel.clearMessages();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006dc4),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.download, size: 30),
                SizedBox(width: 20),
                Text('Criar backup', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          /*
          Botão de restaurar backup
          */
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Deseja restaurar um backup?'),
                  backgroundColor: Colors.white,
                  content: const Text(
                    'Tem certeza que deseja apagar os dados atuais e restaurar os dados salvos em um backup?',
                  ),
                  actionsAlignment: MainAxisAlignment.spaceEvenly,
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(dialogContext);

                        final backupViewModel = context.read<BackupViewmodel>();
                        final messenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Importando backup...'),
                                ],
                              ),
                            );
                          },
                        );

                        await backupViewModel.restaurarBackup();
                        if (navigator.canPop()) {
                          navigator.pop();
                        }

                        if (backupViewModel.successMessage != null) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                backupViewModel.successMessage!,
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          backupViewModel.clearMessages();
                        } else if (backupViewModel.errorMessage != null) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                backupViewModel.errorMessage!,
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          backupViewModel.clearMessages();
                        }
                      },
                      child: const Text(
                        'Restaurar',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006dc4),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.backup_sharp, size: 30),
                SizedBox(width: 20),
                Text('Restaurar backup', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          /* 
          Botão de Importar dispositivos por csv
          */
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ImportDispositivoCsvScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006dc4),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 70),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.browser_updated, size: 30),
                SizedBox(width: 20),
                Text(
                  'Importar dispositivos por CSV',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
