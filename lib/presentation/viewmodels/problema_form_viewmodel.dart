import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/problema.dart';
import 'package:gardien_tech/domain/repositories/problema_repository.dart';

class ProblemaFormViewmodel extends ChangeNotifier {
  final ProblemaRepository _repository;

  ProblemaFormViewmodel(this._repository);

  bool isLoading = false;
  String? errorMessage;

  Future<bool> salvar({
    int? id,
    required int idDispositivo,
    required String descricao,
  }) async {
    errorMessage = null;

    if (descricao.trim().isEmpty) {
      errorMessage = 'A descrição é obrigatória';
      isLoading = false;
      notifyListeners();
      return false;
    }

    if (descricao.trim().length < 3) {
      errorMessage = 'Precisa ser maior que 3 caracteres';
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      Problema problema = Problema(id, idDispositivo, descricao);
      if (id != null) {
        await _repository.atualizar(problema);
      } else {
        await _repository.criar(problema);
      }
      return true;
    } catch (e) {
      errorMessage = 'Erro ao salvar o problema';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
