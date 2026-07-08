import 'package:gardien_tech/data/dto/emprestimo_com_detalhes_dto.dart';
import 'package:gardien_tech/domain/entities/emprestimo.dart';

abstract class EmprestimoRepository {
  Future<List<Emprestimo>> buscarTodos();
  Future<List<Emprestimo>> buscarTodosAtivos();
  Future<List<EmprestimoComDetalhesDTO>> buscarPorDiaComDetalhes(DateTime data);
  Future<Emprestimo?> buscarPorId(int id);
  Future<int> criar(Emprestimo emprestimo);
  Future<void> atualizar(Emprestimo emprestimo);
  Future<void> deletar(int id);
  Future<void> concluir(int id);
}
