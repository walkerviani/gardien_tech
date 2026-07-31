import 'package:gardien_tech/domain/entities/usuario.dart';

abstract class UsuarioRepository {
  Future<List<Usuario>> buscarTodos();
  Future<Usuario?> buscarPorNome(String nome);
  Future<List<Usuario>> buscarNome(String filtro);
  Future<Usuario?> buscarPorId(int id);
  Future<List<Usuario>> buscarDescricao(String filtro);
  Future<void> criar(Usuario usuario);
  Future<void> atualizar(Usuario usuario);
  Future<void> deletar(int id);
}