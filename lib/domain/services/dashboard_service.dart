import 'package:gardien_tech/domain/entities/emprestimo.dart';

abstract class DashboardService {
  Future<int>totalEmprestimos();
  Future<int>totalEmprestimosAtivos();
  Future<int>totalEmprestimosEmObservacao();
  Future<int>totalEmprestimosSemCorrespondencia();
  Future<int>totalEmprestimosConcluidos();

  Future<int>totalEmprestimosPorUsuario(int idUsuario);

  Future<int>totalDispositivos();
  Future<int>totalDispositivosDisponiveis();
  Future<int>totalDispositivosIndisponiveis();
  Future<int>totalDispositivosEmUso();

  Future<List<Emprestimo>> historicoDispositivoEmprestado(int idDispositivo);
}