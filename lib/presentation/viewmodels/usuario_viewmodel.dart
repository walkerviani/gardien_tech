import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';

class UsuarioViewmodel extends ChangeNotifier {
  final UsuarioRepository _repository;

  UsuarioViewmodel(this._repository);

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

  Future<bool> salvar({
    int? id,
    required String nome,
    required int idTipoCargo,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    if (nome.trim().isEmpty) {
      errorMessage = 'Nome é obrigatório';
      isLoading = false;
      notifyListeners();
      return false;
    }

    /*
    Se já existir um usuário com o mesmo nome e não está editando, 
    então não permita criar um usuário com o mesmo nome
    */
    final jaExiste = await _repository.buscarPorNome(nome);
    if (jaExiste != null && jaExiste.id != id) {
      errorMessage = 'Já existe um usuário com esse nome';
      isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      Usuario usuario = Usuario(id, idTipoCargo, nome);
      if (id != null) {
        await _repository.atualizar(usuario);
      } else {
        await _repository.criar(usuario);
      }
      return true;
    } catch (e) {
      errorMessage = 'Erro ao salvar o usuário';
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
      errorMessage = 'Erro ao excluir o usuário';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
