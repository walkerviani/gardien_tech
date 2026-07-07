import 'package:gardien_tech/domain/entities/emprestimo_item.dart';

abstract class EmprestimoItemRepository {
  Future<List<EmprestimoItem>> buscarPorEmprestimo(int idEmprestimo);
  Future<EmprestimoItem?> buscarPorId(int id);
  Future<int> criar(EmprestimoItem item);
  Future<void> atualizar(EmprestimoItem item);
  Future<void> deletar(int id);
  Future<void> adicionarQuantidade(int idEmprestimoItem, int qtd);
  Future<void> registrarDevolucao(int idEmprestimoItem, int qtd);
  Future<void> vincularDispositivo(int idEmprestimoItem, int idDispositivo);
  Future<void> desvincularDispositivo(int idEmprestimoDispositivo);
}