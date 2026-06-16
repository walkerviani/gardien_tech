import 'package:gardien_tech/domain/entities/usuario.dart';

abstract class UsuarioRepository {
  Future<List<Usuario>> obterTodos();
  Future<Usuario?> buscarPorNome(String nome);
  Future<Usuario?> buscarPorId(int id);
  Future<void> criar(Usuario usuario);
  Future<void> atualizar(Usuario usuario);
  Future<void> deletar(int id);
}