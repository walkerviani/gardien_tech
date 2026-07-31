import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';

class SelecionarUsuarioViewmodel extends ChangeNotifier {
  final UsuarioRepository _usuarioRepository;

  SelecionarUsuarioViewmodel(this._usuarioRepository);
  bool isLoading = false;
  String? errorMessage;
  List<Usuario> usuarios = [];

  Future<void> carregarUsuarios() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      usuarios = await _usuarioRepository.buscarTodos();
    } catch (e) {
      errorMessage = 'Erro ao carregar os usuários';
      usuarios = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
