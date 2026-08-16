import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardien_tech/presentation/viewmodels/import_dispositivo_csv_viewmodel.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';
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
            backgroundColor: CoresGardien.verdeClaro,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar o arquivo'),
          backgroundColor: CoresGardien.vermelhoClaro,
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
          backgroundColor: CoresGardien.verdeClaro,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewmodel.errorMessage ?? 'Erro desconhecido'),
          backgroundColor: CoresGardien.vermelhoClaro,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.read<ImportDispositivoCsvViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar por CSV'),
        backgroundColor: CoresGardien.azulClaro,
        foregroundColor: CoresGardien.branco,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: viewmodel.isLoading
            ? const CircularProgressIndicator(color: CoresGardien.azulClaro)
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instruções',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '1. Adicione os dados abaixo na tabela da aba Dispositivos.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Text(
                        'Número de Patrimônio',
                        style: TextStyle(
                          fontSize: 17,
                          color: CoresGardien.laranja,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text(
                                'Número de Patrimônio',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                'Código de registro único colocado em um bem físico.\n\n(Empresas e órgãos públicos implementam esse número para controlar e localizar seus bens).',
                                style: TextStyle(fontSize: 17),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Entendi',
                                    style: TextStyle(color: CoresGardien.preto),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.help_outline),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Número de Série',
                        style: TextStyle(
                          fontSize: 17,
                          color: CoresGardien.azulClaro,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text(
                                'Número de Série',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                'Código único formado por letras e números.\n\n(Ele é definido pelo fabricante durante a produção)',
                                style: TextStyle(fontSize: 17),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Entendi',
                                    style: TextStyle(color: CoresGardien.preto),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.help_outline),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Tipo de Dispositivo',
                        style: TextStyle(
                          fontSize: 17,
                          color: CoresGardien.verdeClaro,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text(
                                'Tipo de Dispositivo',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                'Usado para diferenciar qual é o tipo do dispositivo.\n\n(No modelo: ao clicar na célula vazia do tipo de dispositivo, abra o menu ao lado direito da célula e selecione o tipo de dispositivo ideal)',
                                style: TextStyle(fontSize: 17),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Entendi',
                                    style: TextStyle(color: CoresGardien.preto),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.help_outline),
                      ),
                    ],
                  ),
                  Text(
                    '2. Converta o arquivo para csv ou no processo de salvar o arquivo selecione o tipo do arquivo para csv.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '3. Envie o arquivo csv no aplicativo.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        '4. Atenção',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: () => {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text(
                                'Mais Informações',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                'O modelo serve para ajudar na importação, porém não é necessário o uso.\n\nNo entanto, para caso deseja realizar um arquivo csv à parte, os dados precisam estar na seguinte ordem:\n1-Número de Patrimônio,\n2-Número de Série\n3-Tipo do Dispositivo',
                                style: TextStyle(fontSize: 17),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Entendi',
                                    style: TextStyle(color: CoresGardien.preto),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        },
                        icon: Icon(Icons.help_outline),
                      ),
                    ],
                  ),
                ],
              ),
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
                  backgroundColor: CoresGardien.azulEscuro,
                  foregroundColor: CoresGardien.branco,
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
                  backgroundColor: CoresGardien.verdeClaro,
                  foregroundColor: CoresGardien.branco,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.table_chart, size: 30),
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
