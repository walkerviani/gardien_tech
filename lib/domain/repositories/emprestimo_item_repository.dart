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
  Future<void> adicionarQtdItem(int idEmprestimoItem, int qtd);
  Future<void> registrarDevolucao(int idEmprestimoItem, int qtd);
  Future<void> adicionarDispositivoAoEmprestimo(
    int idEmprestimo,
    int idDispositivo,
  );
  Future<void> criarEmprestimoItemSemVinculo(
    int idEmprestimo,
    int qntDispositivo,
    int idTipoDispositivo,
  );
  Future<void> vincularDispositivo(
    int idEmprestimoDispositivo,
    int idDispositivo,
  );
  Future<void> desvincularDispositivo(int idEmprestimoDispositivo);
}
