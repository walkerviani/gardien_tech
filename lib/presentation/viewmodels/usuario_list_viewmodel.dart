import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';

class UsuarioListViewmodel extends ChangeNotifier {
  final UsuarioRepository _repository;

  UsuarioListViewmodel(this._repository);

  bool isLoading = false;
  String? errorMessage;
  List<Usuario> usuarios = [];

  Future<void> carregarUsuarios() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      usuarios = await _repository.buscarTodos();
    } catch (e) {
      errorMessage = 'Erro ao carregar os usuários';
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
      errorMessage = 'Erro ao excluir o usuário';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
