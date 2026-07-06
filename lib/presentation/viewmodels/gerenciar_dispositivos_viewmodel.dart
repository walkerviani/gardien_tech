import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';

class GerenciarDispositivosViewmodel extends ChangeNotifier {
  final DispositivoRepository _repository;

  GerenciarDispositivosViewmodel(this._repository);

  bool isLoading = false;
  String? errorMessage;

  Future<bool> salvar({
    int? id,
    required String numSerie,
    required String numPatrimonio,
    required int idTipoDispositivo,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      Dispositivo dispositivo = Dispositivo(id, idTipoDispositivo, numSerie, numPatrimonio);
      if (id != null) {
        await _repository.atualizar(dispositivo);
      } else {
        await _repository.criar(dispositivo);
      }
      return true;
    } catch (e) {
      errorMessage = 'Erro ao salvar o dispositivo';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
