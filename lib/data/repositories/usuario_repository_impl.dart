import 'package:drift/drift.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/usuario_datasource.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final AppDatabase _database;

  UsuarioRepositoryImpl(this._database);

  @override
  Future<List<Usuario>> buscarTodos() async {
    final usuarios = await _database.select(_database.usuarios).get();

    return usuarios.map((usuario) => usuario.toEntity()).toList();
  }

  @override
  Future<Usuario?> buscarPorNome(String nome) async {
    final usuario = await (_database.select(_database.usuarios)
      ..where((u) => u.nome.equals(nome))).getSingleOrNull();

    return usuario?.toEntity();
  }

  @override
  Future<List<Usuario>> buscarNome(String filtro) async {
    final f = filtro.trim();

    if (f.isEmpty) return [];

    final query = _database.select(_database.usuarios)
      ..where((u) =>
          // Usa índice para otimização
          u.nome.like('$f%') |         
          u.nome.like('%$f%'))
      ..limit(15);

    final rows = await query.get();
    return rows.map((u) => u.toEntity()).toList();
  }

  @override
  Future<Usuario?> buscarPorId(int id) async {
    final usuario = await (_database.select(_database.usuarios)
      ..where((u) => u.id.equals(id))).getSingleOrNull();

    return usuario?.toEntity();
  }

  @override
  Future<void> criar(Usuario usuario) async {
    await _database.into(_database.usuarios).insert(usuario.toCompanion());
  }

  @override
  Future<void> atualizar(Usuario usuario) async {
    if (usuario.id == null) {
      throw ArgumentError('Não é possível atualizar um usuario sem id');
    }
    
    await (_database.update(_database.usuarios)..where((u) => u.id.equals(usuario.id!)))
      .write(usuario.toCompanion());
  }

  @override
  Future<void> deletar(int id) async {
    await (_database.delete(_database.usuarios)..where((u) => u.id.equals(id))).go();
  }
}