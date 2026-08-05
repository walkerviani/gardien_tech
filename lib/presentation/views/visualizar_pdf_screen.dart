import 'dart:typed_data';
import 'package:flutter/material.dart';
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
        primaryColor: const Color(0xFF2196F3),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFF2196F3),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(tituloPagina),
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
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
