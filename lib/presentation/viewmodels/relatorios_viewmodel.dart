import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/utils/relatorio_pdf_service.dart';

class RelatoriosViewmodel extends ChangeNotifier {
  final RelatorioPdfService _relatorioPdfService;
  final DispositivoRepository _dispositivoRepository;

  RelatoriosViewmodel(this._relatorioPdfService, this._dispositivoRepository);
  String? errorMessage;

  Future<Uint8List?> gerarRelatorioDispositivos() async {
    try {
      final dispositivos = await _dispositivoRepository.buscarTodos();
      return _relatorioPdfService.gerarPdfDispositivos(dispositivos);
    } catch (e) {
      errorMessage = 'Erro ao gerar relatório';
      return null;
    }
  }
}
