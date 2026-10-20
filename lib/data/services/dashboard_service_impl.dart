import 'package:gardien_tech/domain/repositories/emprestimo_repository.dart';
import 'package:gardien_tech/domain/services/dashboard_service.dart';

class DashboardServiceImpl implements DashboardService {
  final EmprestimoRepository _emprestimoRepository;

  DashboardServiceImpl(this._emprestimoRepository);

  @override
  Future<int> totalEmprestimos() async {
    final emprestimos = await _emprestimoRepository.buscarTodos();
    return emprestimos.length;
  }

  @override
  Future<int> totalEmprestimosAtivos() async {
    final emprestimos = await _emprestimoRepository.buscarTodosAtivos();
    return emprestimos.length;
  }
  
  @override
  Future<int> totalEmprestimosEmObservacao() async {
    final emprestimos = await _emprestimoRepository.buscarTodosEmObservacao();
    return emprestimos.length;
  }

  @override
  Future<int> totalEmprestimosSemCorrespondencia() async {
    final emprestimos = await _emprestimoRepository.buscarTodosSemCorrespondencia();
    return emprestimos.length;
  }

  @override
  Future<int> totalEmprestimosConcluidos() async {
    final emprestimos = await _emprestimoRepository.buscarTodosConcluidos();
    return emprestimos.length;
  }
}