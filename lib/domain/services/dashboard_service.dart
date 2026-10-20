abstract class DashboardService {
  Future<int>totalEmprestimos();
  Future<int>totalEmprestimosAtivos();
  Future<int>totalEmprestimosEmObservacao();
  Future<int>totalEmprestimosSemCorrespondencia();
  Future<int>totalEmprestimosConcluidos();
}