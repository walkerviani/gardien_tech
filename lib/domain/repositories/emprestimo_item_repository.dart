import 'package:gardien_tech/data/dto/emprestimo_item_com_dispositivo_dto.dart';
import 'package:gardien_tech/domain/entities/emprestimo_item.dart';

abstract class EmprestimoItemRepository {
  Future<List<EmprestimoItem>> buscarPorEmprestimo(int idEmprestimo);
  Future<List<EmprestimoItemComDispositivoDTO>>
  buscarEmprestimoItemComDispositivo(int idEmprestimo);
  Future<EmprestimoItem?> buscarPorId(int id);
  Future<int> criar(EmprestimoItem item);
  Future<void> atualizar(EmprestimoItem item);
  Future<void> deletar(int id);
  Future<void> aumentarQntSolicitada(int idEmprestimoItem, int qtd);
  Future<void> diminuirQntSolicitada(int idEmprestimoItem, int qtd);
  Future<void> aumentarQntDevolvida(int idEmprestimoItem, int qtd);
  Future<void> diminuirQntDevolvida(int idEmprestimoItem, int qtd);
  Future<void> adicionarDispositivoAoEmprestimo(
    int idEmprestimo,
    int idDispositivo,
  );
  Future<void> criarEmprestimoItemSemVinculo(
    int idEmprestimo,
    int qntDispositivo,
    int idTipoDispositivo,
  );
  Future<bool> verificarDevolucao(int idEmprestimoItem);
}
