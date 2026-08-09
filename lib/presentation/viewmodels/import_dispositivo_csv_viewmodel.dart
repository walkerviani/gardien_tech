import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/utils/dispositivos_csv_service.dart';

class ImportDispositivoCsvViewmodel extends ChangeNotifier {
  final DispositivosCsvService _csvService;
  final DispositivoRepository _dispositivoRepository;

  ImportDispositivoCsvViewmodel(this._csvService, this._dispositivoRepository);

  bool isLoading = false;
  String? errorMessage;
  List<Dispositivo> dispositivos = [];

  Future<bool> importarDispositivosCsv(XFile arquivo) async {
    errorMessage = null;

    isLoading = true;
    notifyListeners();

    try {
      final csvString = await arquivo.readAsString();

      dispositivos = _csvService.importDispositivos(csvString);

      if (dispositivos.isEmpty) {
        errorMessage = 'Lista de dispositivos vazia';
        return false;
      }
      for (final dispositivo in dispositivos) {
        await _dispositivoRepository.criar(dispositivo);
      }

      return true;
    } catch (e) {
      errorMessage = 'Erro ao importar os dispositivos';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
