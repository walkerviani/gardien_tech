import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class VisualizarPdfScreen extends StatelessWidget {
  final String tituloPagina;
  final String nomeArquivo;
  final Future<Uint8List> Function(PdfPageFormat) criarPdf;

  const VisualizarPdfScreen(
    this.tituloPagina,
    this.criarPdf,
    this.nomeArquivo, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: CoresGardien.azulClaro,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: CoresGardien.azulClaro,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(tituloPagina),
          backgroundColor: CoresGardien.azulClaro,
          foregroundColor: CoresGardien.branco,
        ),
        body: PdfPreview(
          build: criarPdf,
          pdfFileName: nomeArquivo,
          allowPrinting: true,
          allowSharing: true,
          canChangeOrientation: false,
          canChangePageFormat: false,
        ),
      ),
    );
  }
}
