import 'package:flutter/services.dart';
import 'package:gardien_tech/data/dto/dispositivo_com_problema_dto.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:pdf/widgets.dart' as pw;

class RelatorioPdfService {
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

  Future<Uint8List> gerarPdfProblemas(
    List<DispositivoComProblemaDTO> problemas,
  ) async {
    final bytesLogo = await rootBundle.load('assets/icon/pdf_icon_512x.png');
    final logo = pw.MemoryImage(bytesLogo.buffer.asUint8List());

    final pdf = pw.Document();

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

    final pdf = pw.Document();

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
