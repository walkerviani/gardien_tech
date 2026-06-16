import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/emprestimo_datasource.dart';
import 'package:gardien_tech/domain/entities/emprestimo.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_repository.dart';

class EmprestimoRepositoryImpl implements EmprestimoRepository {
  final AppDatabase _database;

  EmprestimoRepositoryImpl(this._database);

  @override
  Future<List<Emprestimo>> obterTodos() async {
    final emprestimos = await _database.select(_database.emprestimos).get();

    return emprestimos.map((emprestimo) => emprestimo.toEntity()).toList();
  }

  @override
  Future<List<Emprestimo>> obterTodosAtivos() async {
    final emprestimos = await (_database.select(_database.emprestimos)
        ..where((emprestimo) => emprestimo.idStatus.equals(1)))
      .get();

    return emprestimos.map((emprestimo) => emprestimo.toEntity()).toList();
  }

  @override
  Future<Emprestimo?> buscarPorId(int id) async {
    final emprestimo = await (_database.select(_database.emprestimos)
        ..where((emprestimo) => emprestimo.id.equals(id))).getSingleOrNull();

    return emprestimo?.toEntity();
  }

  @override
  Future<void> criar(Emprestimo emprestimo) async {
    await _database.into(_database.emprestimos).insert(emprestimo.toCompanion());
  }

    @override
  Future<void> atualizar(Emprestimo emprestimo) async {
    await (_database.update(_database.emprestimos)..where((e) => e.id.equals(emprestimo.id)))
      .write(emprestimo.toCompanion());
  }

  @override
  Future<void> deletar(int id) async {
    await (_database.delete(_database.emprestimos)..where((e) => e.id.equals(id))).go();
  }

  @override
  Future<void> debitar(int idDispositivo, int qtd) async {
    // TODO: implement debitar
    throw UnimplementedError();
  }

  @override
  Future<void> creditar(int idDispositivo, int qtd) async {
    // TODO: implement creditar
    throw UnimplementedError();
  }

  @override
  Future<void> concluir(int idEmprestimoItem, List<int> idDispositivos) {
    // TODO: implement concluir
    throw UnimplementedError();
  }
}