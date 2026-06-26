import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/problema_datasource.dart';
import 'package:gardien_tech/domain/entities/problema.dart';
import 'package:gardien_tech/domain/repositories/problema_repository.dart';

class ProblemaRepositoryImpl implements ProblemaRepository {
  final AppDatabase _database;

  ProblemaRepositoryImpl(this._database);

  @override
  Future<List<Problema>> buscarTodos() async {
    final problemas = await _database.select(_database.problemas).get();

    return problemas.map((problema) => problema.toEntity()).toList();
  }

  @override
  Future<List<Problema>> buscarTodosPorDispositivo(int idDispositivo) async {
    final problemas = await (_database.select(_database.problemas)
      ..where((p) => p.idDispositivo.equals(idDispositivo)))
        .get();
    return problemas.map((p) => p.toEntity()).toList();
  }

  @override
  Future<Problema?> buscarPorId(int id) async {
    final problemas = await (_database.select(_database.problemas)
      ..where((p) => p.id.equals(id))).getSingleOrNull();

    return problemas?.toEntity();
  }

  @override
  Future<void> criar(Problema problema) async {
    await _database.into(_database.problemas).insert(problema.toCompanion());
  }

  @override
  Future<void> atualizar(Problema problema) async {
    if (problema.id == null) {
      throw ArgumentError('Não é possível atualizar um problema sem id');
    }

    await (_database.update(_database.problemas)..where((p) => p.id.equals(problema.id!)))
      .write(problema.toCompanion());
  }

  @override
  Future<void> deletar(int id) async {
    await (_database.delete(_database.problemas)..where((p) => p.id.equals(id))).go();
  }
}