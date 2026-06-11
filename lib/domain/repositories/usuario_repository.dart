import 'package:gardien_tech/domain/entities/usuario.dart';

abstract class UsuarioRepository {
  Future<List<Usuario>> getAll();
  Future<Usuario?> findByName(String nome);
  Future<Usuario> create(Usuario usuario);
  Future<Usuario> update(Usuario usuario);
  Future<void> delete(int id);
}