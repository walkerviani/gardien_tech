import 'package:gardien_tech/domain/entities/emprestimo.dart';

abstract class EmprestimoRepository {
  Future<List<Emprestimo>> obterTodos();
  Future<List<Emprestimo>> obterTodosAtivos();
  Future<Emprestimo?> buscarPorId(int id);
  Future<void> criar(Emprestimo emprestimo);
  Future<void> atualizar(Emprestimo emprestimo);
  Future<void> deletar(int id);
  Future<void> concluir(int id);
}