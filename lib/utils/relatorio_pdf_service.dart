import 'package:flutter/services.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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

  Future<Uint8List> gerarPdfDispositivos(List<Dispositivo> dispositivos) async {
    final bytesLogo = await rootBundle.load('assets/icon/pdf_icon_512x.png');
    final logo = pw.MemoryImage(bytesLogo.buffer.asUint8List());

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        header: (context) => _cabecalho(logo, 'DISPOSITIVOS'),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            headers: ['Patrimônio', 'Núm Série', 'Tipo'],
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

  Future<void> imprimirDispositivos(List<Dispositivo> dispositivos) async {
    final bytes = await gerarPdfDispositivos(dispositivos);

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'relatorio_dispositivos.pdf',
    );
  }
}
