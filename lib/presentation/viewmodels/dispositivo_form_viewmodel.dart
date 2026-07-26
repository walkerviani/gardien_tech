import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';

class DispositivoFormViewmodel extends ChangeNotifier {
  final DispositivoRepository _repository;

  DispositivoFormViewmodel(this._repository);

  bool isLoading = false;
  String? errorMessage;

  Future<bool> salvar({
    int? id,
    required String numSerie,
    required String numPatrimonio,
    required int idTipoDispositivo,
  }) async {
    errorMessage = null;

    if (numSerie.length > 50) {
      errorMessage = 'Precisa ser menor que 50 caracteres';
      return false;
    }

    if (numSerie.length < 3) {
      errorMessage = 'Precisa ser maior que 3 caracteres';
      return false;
    }

    if (numPatrimonio.length > 30) {
      errorMessage = 'Precisa ser menor que 30 caracteres';
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      Dispositivo dispositivo = Dispositivo(
        id,
        idTipoDispositivo,
        numSerie,
        numPatrimonio,
      );
      if (id != null) {
        await _repository.atualizar(dispositivo);
      } else {
        await _repository.criar(dispositivo);
      }
      return true;
    } on Exception catch (e) {
      final mensagem = e.toString();
      if (mensagem.contains('UNIQUE') &&
          mensagem.contains('dispositivos.num_patrimonio')) {
        errorMessage = 'Número de patrimônio já cadastrado';
        return false;
      }
      if (mensagem.contains('UNIQUE') &&
          mensagem.contains('dispositivos.num_serie')) {
        errorMessage = 'Número de série já cadastrado';
        return false;
      }
      errorMessage = 'Erro ao salvar o dispositivo';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
