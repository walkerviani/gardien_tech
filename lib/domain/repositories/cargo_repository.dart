import 'package:gardien_tech/domain/entities/cargo.dart';

abstract class CargoRepository {
  Future<Cargo?> buscarPorId(int id);
  Future<Cargo?> buscarPorNome(String nome);
  Future<List<Cargo>> buscarTodos();
  Future<void> criar(Cargo cargo);
  Future<void> atualizar(Cargo cargo);
  Future<void> deletar(int id);
}