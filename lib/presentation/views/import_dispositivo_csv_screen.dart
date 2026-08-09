import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardien_tech/presentation/viewmodels/import_dispositivo_csv_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:public_file_saver/public_file_saver.dart';

class ImportDispositivoCsvScreen extends StatefulWidget {
  const ImportDispositivoCsvScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ImportDispositivoCsvScreenState();
}

class _ImportDispositivoCsvScreenState
    extends State<ImportDispositivoCsvScreen> {
  Future<void> _salvarModeloCsv() async {
    try {
      final data = await rootBundle.load(
        'assets/file/modelo_importacao_dispositivos.xlsx',
      );
      final bytes = data.buffer.asUint8List();

      final fileSaver = PublicFileSaver();

      final resultado = await fileSaver.saveBytesWithDialog(
        bytes: bytes,
        fileName: 'modelo_importacao_dispositivos.xlsx',
        mimeType:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );

      if (!mounted) return;
      if (resultado != null && resultado.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Arquivo modelo salvo com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar o arquivo'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _adicionarCsv() async {
    const tipoCsv = XTypeGroup(label: 'CSV', extensions: ['csv']);

    final arquivo = await openFile(acceptedTypeGroups: [tipoCsv]);

    if (arquivo == null) {
      return;
    }

    if (!mounted) return;

    final viewmodel = context.read<ImportDispositivoCsvViewmodel>();

    bool sucesso = await viewmodel.importarDispositivosCsv(arquivo);

    if (!mounted) return;

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Importação de dispositivos realizado com sucesso'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewmodel.errorMessage ?? 'Erro desconhecido'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.read<ImportDispositivoCsvViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import dispositivos por csv'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Container(
        child: viewmodel.isLoading
            ? const CircularProgressIndicator(color: Color(0xFF006dc4))
            : Text('1', style: TextStyle(fontSize: 18)),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await _salvarModeloCsv();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006dc4),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.description, size: 30),
                    SizedBox(width: 20),
                    Text(
                      'Salvar arquivo xlsx modelo',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: viewmodel.isLoading ? null : _adicionarCsv,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.grid_on, size: 30),
                    SizedBox(width: 20),
                    Text(
                      'Adicionar arquivo csv',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
