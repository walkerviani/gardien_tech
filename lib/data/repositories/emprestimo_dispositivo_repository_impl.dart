import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/emprestimo_dispositivos_datasource.dart';
import 'package:gardien_tech/domain/entities/emprestimo_dispositivo.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_dispositivo_repository.dart';

class EmprestimoDispositivoRepositoryImpl implements EmprestimoDispositivoRepository{
  final AppDatabase _database;

  EmprestimoDispositivoRepositoryImpl(this._database);

  @override
  Future<EmprestimoDispositivo?> buscarPorId(int id) async {
    final emprestimoDispositivo = await (_database.select(_database.emprestimoDispositivos)
        ..where((ed) => ed.id.equals(id))).getSingleOrNull();

    return emprestimoDispositivo?.toEntity();
  }

  @override
  Future<List<EmprestimoDispositivo>> buscarPorEmprestimoItem(int idEmprestimoItem) async {
    final emprestimoDispositivos = await (_database.select(_database.emprestimoDispositivos)
      ..where((ed) => ed.idEmprestimoItem.equals(idEmprestimoItem))).get();

    return emprestimoDispositivos.map((ed) => ed.toEntity()).toList();
  }

  @override
  Future<void> criar(EmprestimoDispositivo emprestimoDispositivo) async {
    await _database.into(_database.emprestimoDispositivos).insert(emprestimoDispositivo.toCompanion());
  }

  @override
  Future<void> atualizar(EmprestimoDispositivo emprestimoDispositivo) async {
    if (emprestimoDispositivo.id == null) {
      throw ArgumentError('Não é possível atualizar um empréstimo de dispositivo sem id');
    }

    await (_database.update(_database.emprestimoDispositivos)
      ..where((ed) => ed.id.equals(emprestimoDispositivo.id!)))
        .write(emprestimoDispositivo.toCompanion());
  }

  @override
  Future<void> deletar(int id) async {
    await (_database.delete(_database.emprestimoDispositivos)..where((ed) => ed.id.equals(id))).go();
  }
}