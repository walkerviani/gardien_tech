import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';

class UsuarioFormViewmodel extends ChangeNotifier{
  final UsuarioRepository _repository;

  UsuarioFormViewmodel(this._repository);

  bool isLoading = false;
  String? errorMessage;

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
}