import 'package:gardien_tech/domain/entities/emprestimo.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';

abstract class DashboardService {
  Future<int> totalEmprestimos();
  Future<int> totalEmprestimosAtivos();
  Future<int> totalEmprestimosEmObservacao();
  Future<int> totalEmprestimosSemCorrespondencia();
  Future<int> totalEmprestimosConcluidos();

  Future<Map<String, int>> totalEmprestimosUsuarios();

  Future<int> totalDispositivos();
  Future<int> totalDispositivosDisponiveis();
  Future<int> totalDispositivosIndisponiveis();
  Future<int> totalDispositivosEmUso();
  Future<Map<TipoDispositivo, int>> totalDispositivosPorTipo();

  Future<List<Emprestimo>> historicoDispositivoEmprestado(int idDispositivo);
}
