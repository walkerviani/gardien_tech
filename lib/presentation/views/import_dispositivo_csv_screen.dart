import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
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

    // Falha total (arquivo inválido, nenhum dispositivo salvo etc.)
    if (!sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewmodel.errorMessage ?? 'Nenhum dispositivo foi importado',
          ),
          backgroundColor: CoresGardien.vermelhoClaro,
        ),
      );
      // Se houver erros detalhados, mostra na tela
      if (viewmodel.erros.isNotEmpty) {
        await _mostrarResultado(viewmodel.sucessos, viewmodel.erros);
      }
      return;
    }
    // Sucesso sem nenhum erro
    if (viewmodel.erros.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${viewmodel.sucessos} dispositivos importados'),
          backgroundColor: CoresGardien.verdeClaro,
        ),
      );
      return;
    }
    // Sucesso parcial: mostra o resumo com os erros
    await _mostrarResultado(viewmodel.sucessos, viewmodel.erros);
  }

  Future<void> _mostrarResultado(int sucessos, List<String> erros) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Importação concluída',
          style: TextStyle(
            fontSize: 25,
            color: CoresGardien.preto,
            fontWeight: FontWeight.bold,
          ),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$sucessos importados, ${erros.length} ignorados',
                style: const TextStyle(fontSize: 18, color: CoresGardien.preto),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: erros.length,
                  itemBuilder: (_, i) => Text(
                    '• ${erros[i]}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: CoresGardien.preto,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              viewmodel.isLoading
                  ? const CircularProgressIndicator(
                      color: CoresGardien.azulClaro,
                    )
                  : _instrucoes(),
            ],
          ),
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

  Widget _instrucoes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Instruções',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _textoDescricao(
          '1° Adicione os dados do dispositivo na ordem apresentada abaixo:',
        ),
        _infoCampo(
          'Número de Patrimônio',
          'Código de registro único colocado em um bem físico.\n\n(Empresas e órgãos públicos implementam esse número para controlar e localizar seus bens).',
          CoresGardien.laranja,
        ),
        _infoCampo(
          'Número de Série',
          'Código único formado por letras e números.\n\n(Ele é definido pelo fabricante durante a produção)',
          CoresGardien.azulClaro,
        ),
        _infoCampo(
          'Tipo de Dispositivo',
          'Usado para diferenciar qual é o tipo do dispositivo.\n\n'
              'ATENÇÃO: No modelo, clique na célula vazia de tipo de dispositivo e use o menu que aparece ao lado direito para selecionar o tipo desejado.',
          CoresGardien.verdeClaro,
        ),
        _textoDescricao(
          'TIPO DE DISPOSITIVO: Você também pode adicionar os tipos pelo nome ou pelo número identificador, ambos precisam estar iguais apresentados no botão abaixo.',
        ),
        _infoTipoDisp(),
        const SizedBox(height: 12),
        _textoDescricao(
          '2° Se você preencheu os dados no modelo de tabela ou em uma planilha própria (Excel, por exemplo), salve o arquivo no formato CSV antes de importá-lo.',
        ),
        const SizedBox(height: 12),
        _textoDescricao(
          '3° Verifique se os dados estão corretos e insira o arquivo CSV pelo botão verde abaixo.',
        ),
        const SizedBox(height: 12),
        _textoDescricao(
          'ATENÇÃO: O modelo existe para facilitar a importação, mas seu uso é opcional. Você pode preencher os dados no Excel, ou outro programa de planilhas, e depois salvar o arquivo como CSV, ou criar um arquivo CSV diretamente. Em ambos os casos, mantenha a mesma ordem de colunas do modelo.',
        ),
      ],
    );
  }

  Widget _textoDescricao(String texto) {
    return Text(
      texto,
      style: TextStyle(fontSize: 18),
      textAlign: TextAlign.justify,
    );
  }

  Widget _infoCampo(String campo, String descricao, Color cor) {
    return Row(
      children: [
        Text(
          campo,
          style: TextStyle(
            fontSize: 18,
            color: cor,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(
                  campo,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text(descricao, style: TextStyle(fontSize: 17)),
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
    );
  }

  Widget _infoTipoDisp() {
    return TextButton(
      onPressed: () {
        _descricaoTipoDisp();
      },
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, 40),
        backgroundColor: CoresGardien.azulClaro,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(5),
        ),
      ),
      child: Text(
        'Tipos de dispositivo',
        style: TextStyle(color: CoresGardien.branco),
      ),
    );
  }

  void _descricaoTipoDisp() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Tipos de dispositivo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: TipoDispositivo.values
              .map(
                (tipo) => Text(
                  '${tipo.id} - ${tipo.nomeTipo}',
                  style: const TextStyle(fontSize: 17),
                ),
              )
              .toList(),
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
  }
}
