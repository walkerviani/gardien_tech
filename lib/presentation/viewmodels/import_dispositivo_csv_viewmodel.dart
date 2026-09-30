import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/utils/dispositivos_csv_service.dart';

class ImportDispositivoCsvViewmodel extends ChangeNotifier {
  final DispositivosCsvService _csvService;
  final DispositivoRepository _dispositivoRepository;

  ImportDispositivoCsvViewmodel(this._csvService, this._dispositivoRepository);

  bool isLoading = false;
  String? errorMessage;
  int sucessos = 0;
  List<String> erros = [];

  Future<bool> importarDispositivosCsv(XFile arquivo) async {
    errorMessage = null;
    sucessos = 0;
    erros = [];
    isLoading = true;
    notifyListeners();

    try {
      final (dispositivos, errosCsv) = await _csvService.importDispositivos(
        File(arquivo.path),
      );
      erros.addAll(errosCsv);

      for (final dispositivo in dispositivos) {
        try {
          final existe = await _dispositivoRepository
              .existePorPatrimonioOuSerie(
                dispositivo.numPatrimonio,
                dispositivo.numSerie,
              );

          if (existe) {
            erros.add(
              'Patrimônio: ${dispositivo.numPatrimonio} / Série: ${dispositivo.numSerie} já existe',
            );
            continue;
          }
          if (dispositivo.numSerie.trim().length >= 50) {
            erros.add(
              'Patrimônio: ${dispositivo.numPatrimonio} / Série: ${dispositivo.numSerie} possui um número de série maior que 50 caracteres',
            );
            continue;
          }
          if (dispositivo.numPatrimonio.trim().length >= 30) {
            erros.add(
              'Patrimônio: ${dispositivo.numPatrimonio} / Série: ${dispositivo.numSerie} possui um número de patrimônio maior que 30 caracteres',
            );
            continue;
          }

          await _dispositivoRepository.criar(dispositivo);
          sucessos++;
        } catch (e) {
          erros.add(
            'Patrimônio: ${dispositivo.numPatrimonio} / Série: ${dispositivo.numSerie}: falha ao salvar',
          );
        }
      }

      return sucessos > 0;
    } catch (e) {
      final mensagem = e.toString().replaceFirst('Exception: ', '');
      errorMessage = 'Erro ao importar: $mensagem';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
