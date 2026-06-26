import 'package:gardien_tech/domain/entities/emprestimo.dart';

abstract class EmprestimoRepository {
  Future<List<Emprestimo>> buscarTodos();
  Future<List<Emprestimo>> buscarTodosAtivos();
  Future<Emprestimo?> buscarPorId(int id);
  Future<void> criar(Emprestimo emprestimo);
  Future<void> atualizar(Emprestimo emprestimo);
  Future<void> deletar(int id);
  Future<void> concluir(int id);
}