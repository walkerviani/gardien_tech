import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';

class DispositivoViewmodel extends ChangeNotifier {
  final DispositivoRepository _repository;

  DispositivoViewmodel(this._repository);

  bool isLoading = false;
  String? errorMessage;
  List<Dispositivo> dispositivos = [];

  Future<void> carregarDispositivos() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dispositivos = await _repository.buscarTodos();
    } catch (e) {
      errorMessage = 'Erro ao carregar os dispositivos';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> salvar({
    int? id,
    required String numSerie,
    required String numPatrimonio,
    required int idTipoDispositivo,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    if (numSerie.trim().isEmpty) {
      errorMessage = 'Número de série é obrigatório';
      isLoading = false;
      notifyListeners();
      return false;
    }

    if (numPatrimonio.trim().isEmpty) {
      errorMessage = 'Número de patrimônio é obrigatório';
      isLoading = false;
      notifyListeners();
      return false;
    }

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

  Future<bool> deletar(int id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _repository.deletar(id);
      return true;
    } catch (e) {
      errorMessage = 'Erro ao excluir o dispositivo';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
