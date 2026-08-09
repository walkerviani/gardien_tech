import 'dart:io';
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
      final File arquivoConvertido = _xfileParaFile(arquivo);
      dispositivos = await _csvService.importDispositivos(arquivoConvertido);

      if (dispositivos.isEmpty) {
        errorMessage = 'Lista de dispositivos vazia';
        return false;
      }

      int qntDispCriados = 0;
      int qntDispDescartados = 0; // Dispositivos já existentes

      for (final dispositivo in dispositivos) {
        try {
          final existe = await _dispositivoRepository
              .existePorPatrimonioOuSerie(
                dispositivo.numPatrimonio,
                dispositivo.numSerie,
              );

          if (existe) {
            qntDispDescartados++;
            continue;
          }

          await _dispositivoRepository.criar(dispositivo);
          qntDispCriados++;
        } catch (e) {
          errorMessage = 'Erro ao criar dispositivo';
          return false;
        }
      }

      if (qntDispCriados == 0) {
        errorMessage = qntDispDescartados > 0
            ? 'Todos os dispositivos do arquivo já existem no sistema.'
            : 'Nenhum dispositivo importado.';
        return false;
      }

      if (qntDispCriados > 0) {
        if (qntDispDescartados > 0) {
          errorMessage =
              'Dispositivos: $qntDispCriados criados e $qntDispDescartados já existiam';
          return false;
        }
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

  File _xfileParaFile(XFile xfile) {
    return File(xfile.path);
  }
}
