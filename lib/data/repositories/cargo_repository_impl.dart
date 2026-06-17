import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/domain/entities/cargo.dart';
import 'package:gardien_tech/domain/repositories/cargo_repository.dart';
import 'package:gardien_tech/data/datasources/cargo_datasource.dart';

class CargoRepositoryImpl implements CargoRepository {
  final AppDatabase _database;

  CargoRepositoryImpl(this._database);

  @override
  Future<Cargo?> buscarPorId(int id) async {
    final cargos = await (_database.select(
      _database.cargos,
    )..where((c) => c.id.equals(id))).getSingleOrNull();

    return cargos?.toEntity();
  }

  @override
  Future<List<Cargo>> buscarTodos() async {
    final cargos = await _database.select(_database.cargos).get();
    return cargos.map((c) => c.toEntity()).toList();
  }

  @override
  Future<void> criar(Cargo cargo) async {
    await _database.into(_database.cargos).insert(cargo.toCompanion());
  }

  @override
  Future<void> atualizar(Cargo cargo) async {
    await (_database.update(
      _database.cargos,
    )..where((c) => c.id.equals(cargo.id))).write(cargo.toCompanion());
  }

  @override
  Future<void> deletar(int id) async {
    await (_database.delete(
      _database.cargos,
    )..where((c) => c.id.equals(id))).go();
  }
}
