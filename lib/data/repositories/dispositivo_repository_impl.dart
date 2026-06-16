import 'package:drift/drift.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/dispositivo_datasource.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';

class DispositivoRepositoryImpl implements DispositivoRepository {
  final AppDatabase _database;

  DispositivoRepositoryImpl(this._database);

  @override
  Future<Dispositivo?> buscarPorId(int id) async {
    final dispositivos = await (_database.select(_database.dispositivos)
      ..where((d) => d.id.equals(id))).getSingleOrNull();
      
    return dispositivos?.toEntity();
  }

  @override
  Future<List<Dispositivo>> buscarTodos() async {
    final dispositivos = await _database.select(_database.dispositivos).get();
    return dispositivos.map((d) => d.toEntity()).toList();
  }

  @override
  Future<List<Dispositivo>> buscarPorTipo(int idTipoDispositivo) async {
    final dispositivos = await (_database.select(_database.dispositivos)
      ..where((d) => d.idTipoDispositivo.equals(idTipoDispositivo)))
        .get();
    return dispositivos.map((d) => d.toEntity()).toList();
  }

  @override
  Future<void> criar(Dispositivo dispositivo) async {
    await _database.into(_database.dispositivos).insert(dispositivo.toCompanion());
  }

  @override
  Future<void> atualizar(Dispositivo dispositivo) async {
    await (_database.update(_database.dispositivos)..where((d) => d.id.equals(dispositivo.id)))
      .write(dispositivo.toCompanion());
  }

  @override
  Future<void> deletar(int id) async {
    await (_database.delete(_database.dispositivos)..where((d) => d.id.equals(id))).go();
  }
  
  @override
  Future<int> contarDisponiveisPorTipo(int idTipoDispositivo) async {
    final dispositivos = await (_database.select(_database.dispositivos)
        ..where((d) => d.idTipoDispositivo.equals(idTipoDispositivo) & d.idStatus.equals(1)))
          .get();

    return dispositivos.length;
  }
}