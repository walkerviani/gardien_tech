import 'package:flutter/services.dart';
import 'package:gardien_tech/data/dto/dispositivo_com_problema_dto.dart';
import 'package:gardien_tech/data/dto/emprestimo_item_com_dispositivo_dto.dart';
import 'package:gardien_tech/data/dto/emprestimo_relatorio_dto.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';
import 'package:gardien_tech/domain/enum/emprestimo_status.dart';
import 'package:gardien_tech/domain/enum/tipo_cargo.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

class RelatorioPdfService {
  Future<pw.ThemeData> _carregarTema() async {
    final font = pw.Font.ttf(
      await rootBundle.load('assets/font/Roboto-Regular.ttf'),
    );
    final bold = pw.Font.ttf(
      await rootBundle.load('assets/font/Roboto-Bold.ttf'),
    );

    return pw.ThemeData.withFont(base: font, bold: bold);
  }

  // Cria o cabeçalho com icone do app e título do relatório
  pw.Widget _cabecalho(pw.MemoryImage logo, String titulo) {
    return pw.Column(
      children: [
        pw.Row(
          children: [
            pw.Column(
              children: [
                pw.Image(logo, width: 50, height: 50),
                pw.Text(
                  'Gardien Tech',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.SizedBox(width: 12),
            pw.Text(
              titulo,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        pw.Divider(),
        pw.SizedBox(height: 5),
      ],
    );
  }

  // Cria o cabeçalho do empréstimo contendo os dados do empréstimo
  pw.Widget _cabecalhoEmprestimo(EmprestimoRelatorioDTO relatorio) {
    final cargoString =
        TipoCargo.values
            .where((cargo) => cargo.id == relatorio.emprestimo.idTipoCargo)
            .firstOrNull
            ?.nomeCargo ??
        'Cargo não encontrado';
    final statusString =
        EmprestimoStatus.values
            .where(
              (status) => status.id == relatorio.emprestimo.idStatusEmprestimo,
            )
            .firstOrNull
            ?.nomeStatus ??
        'Status não encontrado';

    final dataEfetuadoEmprestimo = relatorio.emprestimo.dataHoraEfetuado;
    final dataHoraFormatada = DateFormat(
      'dd/MM/y HH:mm',
      'pt_BR',
    ).format(dataEfetuadoEmprestimo);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'EMPRÉSTIMO #${relatorio.emprestimo.idEmprestimo}',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Text('Data Efetuado: $dataHoraFormatada'),
        pw.Text(
          'Responsável: ${relatorio.emprestimo.nomeUsuario} - $cargoString',
        ),
        pw.Text('Status: $statusString'),
        pw.Text('Quantidade total: ${relatorio.emprestimo.qtdSolicitada}'),
      ],
    );
  }

  // Cria o cabeçalho do empréstimo_item contendo os dados do empréstimo_item + dispositivos presente
  pw.Widget _cabecalhoItens(List<EmprestimoItemComDispositivoDTO> itens) {
    return pw.Column(
      children: itens.map((item) {
        String tipoItem =
            TipoDispositivo.values
                .where((tipo) => tipo.id == item.item.idTipoDispositivo)
                .firstOrNull
                ?.nomeTipo ??
            'Tipo não encontrado';
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              '$tipoItem - ${item.item.qtdSolicitada} unidade(s)',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),

            ...item.dispositivosObj.map(
              (dispositivo) => pw.Text(
                '${dispositivo.numPatrimonio} - ${dispositivo.numSerie}',
              ),
            ),
            pw.SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }

  Future<Uint8List> gerarPdfEmprestimoDia(
    List<EmprestimoRelatorioDTO> relatorios,
    DateTime data,
  ) async {
    final bytesLogo = await rootBundle.load('assets/icon/pdf_icon_512x.png');
    final logo = pw.MemoryImage(bytesLogo.buffer.asUint8List());

    final pdf = pw.Document(theme: await _carregarTema());
    final dataFormatada = DateFormat('dd/MM/yyyy').format(data);
    pdf.addPage(
      pw.MultiPage(
        header: (context) => _cabecalho(logo, 'EMPRÉSTIMOS $dataFormatada'),
        build: (context) => relatorios.expand((relatorio) {
          return [
            _cabecalhoEmprestimo(relatorio),
            pw.SizedBox(height: 8),
            _cabecalhoItens(relatorio.itens),
            pw.Divider(),
          ];
        }).toList(),
      ),
    );
    return pdf.save();
  }

  Future<Uint8List> gerarPdfEmprestimoUsuario(
    List<EmprestimoRelatorioDTO> relatorios,
    Usuario usuario,
  ) async {
    final bytesLogo = await rootBundle.load('assets/icon/pdf_icon_512x.png');
    final logo = pw.MemoryImage(bytesLogo.buffer.asUint8List());

    final pdf = pw.Document(theme: await _carregarTema());
    pdf.addPage(
      pw.MultiPage(
        header: (context) => _cabecalho(logo, 'EMPRÉSTIMOS'),
        build: (context) => [
          pw.Text(
            'Usuário: ${usuario.nome}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
          ),
          pw.SizedBox(height: 5),
          pw.Divider(),
          ...relatorios.expand((relatorio) {
            return [
              _cabecalhoEmprestimo(relatorio),
              pw.SizedBox(height: 8),
              _cabecalhoItens(relatorio.itens),
              pw.Divider(),
            ];
          }),
        ],
      ),
    );
    return pdf.save();
  }

  Future<Uint8List> gerarPdfProblemas(
    List<DispositivoComProblemaDTO> problemas,
  ) async {
    final bytesLogo = await rootBundle.load('assets/icon/pdf_icon_512x.png');
    final logo = pw.MemoryImage(bytesLogo.buffer.asUint8List());

    final pdf = pw.Document(theme: await _carregarTema());

    pdf.addPage(
      pw.MultiPage(
        header: (context) => _cabecalho(logo, 'PROBLEMAS RELATADOS'),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            headers: ['Patrimônio', 'Núm Série', 'Problema'],
            columnWidths: {
              0: const pw.FixedColumnWidth(100),
              1: const pw.FixedColumnWidth(100),
              2: const pw.FlexColumnWidth(),
            },
            data: problemas.map((problema) {
              return [
                problema.numPatrimonio,
                problema.numSerie,
                problema.descricao,
              ];
            }).toList(),
          ),
        ],
      ),
    );
    return pdf.save();
  }

  Future<Uint8List> gerarPdfDispositivos(List<Dispositivo> dispositivos) async {
    final bytesLogo = await rootBundle.load('assets/icon/pdf_icon_512x.png');
    final logo = pw.MemoryImage(bytesLogo.buffer.asUint8List());

    final pdf = pw.Document(theme: await _carregarTema());

    pdf.addPage(
      pw.MultiPage(
        header: (context) => _cabecalho(logo, 'DISPOSITIVOS CADASTRADOS'),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            headers: ['Patrimônio', 'Núm Série', 'Tipo'],
            columnWidths: {
              0: const pw.FixedColumnWidth(100),
              1: const pw.FixedColumnWidth(100),
              2: const pw.FixedColumnWidth(50),
            },
            data: dispositivos.map((dispositivo) {
              String tipoDisp =
                  TipoDispositivo.values
                      .where((tipo) => tipo.id == dispositivo.idTipoDispositivo)
                      .firstOrNull
                      ?.nomeTipo ??
                  'Tipo não encontrado';
              return [
                dispositivo.numPatrimonio,
                dispositivo.numSerie,
                tipoDisp,
              ];
            }).toList(),
          ),
        ],
      ),
    );

    return pdf.save();
  }
}
