import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/problema.dart';
import 'package:gardien_tech/domain/repositories/problema_repository.dart';

class DispositivoProblemaListViewmodel extends ChangeNotifier {
  final ProblemaRepository _repository;

  DispositivoProblemaListViewmodel(this._repository);

  bool isLoading = false;
  String? errorMessage;
  List<Problema> problemas = [];

  Future<void> carregarProblemasPorDisp(int idDispositivo) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      problemas = await _repository.buscarTodosPorDispositivo(idDispositivo);
    } catch (e) {
      errorMessage = 'Erro ao carregar os problemas do dispositivo';
      problemas = [];
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
      errorMessage = 'Erro ao excluir o problema';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
