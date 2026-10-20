import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/services/dashboard_service.dart';

class DashboardViewmodel extends ChangeNotifier {
  final DashboardService _dashboardService;

  DashboardViewmodel(this._dashboardService);

  bool isLoading = false;
  String? errorMessage;
  int? qntTotalEmprestimo;
  int? qntEmpAtivo;
  int? qntEmpEB; // Em observacao
  int? qntEmpSC; // Sem correspondencia
  int? qntEmpConcluido;
  Map<String, int> dadosEmp = {};

  Future<bool> buscarTotalEmprestimos() async {
    errorMessage = null;
    qntTotalEmprestimo = null;
    try {
      qntTotalEmprestimo = await _dashboardService.totalEmprestimos();
      if (qntTotalEmprestimo == null) {
        errorMessage = 'O total de empréstimos é nulo';
        return false;
      }
      return true;
    } catch (e) {
      errorMessage = 'Houve um problema ao buscar o total de empréstimos';
      return false;
    }
  }

  Future<bool> buscarTotalEmpAtivo() async {
    errorMessage = null;
    qntEmpAtivo = null;
    try {
      qntEmpAtivo = await _dashboardService.totalEmprestimosAtivos();
      if (qntEmpAtivo == null) {
        errorMessage = 'O total de empréstimos ativos é nulo';
        return false;
      }
      return true;
    } catch (e) {
      errorMessage =
          'Houve um problema ao buscar o total de empréstimos ativos';
      return false;
    }
  }

  Future<bool> buscarTotalEmpEmObservacao() async {
    errorMessage = null;
    qntEmpEB = null;
    try {
      qntEmpEB = await _dashboardService.totalEmprestimosEmObservacao();
      if (qntEmpEB == null) {
        errorMessage = 'O total de empréstimos em observação é nulo';
        return false;
      }
      return true;
    } catch (e) {
      errorMessage =
          'Houve um problema ao buscar o total de empréstimos em observação';
      return false;
    }
  }

  Future<bool> buscarTotalEmpSemCorrespondencia() async {
    errorMessage = null;
    qntEmpSC = null;
    try {
      qntEmpSC = await _dashboardService.totalEmprestimosSemCorrespondencia();
      if (qntEmpSC == null) {
        errorMessage = 'O total de empréstimos sem correspondência é nulo';
        return false;
      }
      return true;
    } catch (e) {
      errorMessage =
          'Houve um problema ao buscar o total de empréstimos sem correspondência';
      return false;
    }
  }

  Future<bool> buscarTotalEmpConcluido() async {
    errorMessage = null;
    qntEmpConcluido = null;
    try {
      qntEmpConcluido = await _dashboardService.totalEmprestimosConcluidos();
      if (qntEmpConcluido == null) {
        errorMessage = 'O total de empréstimos concluídos é nulo';
        return false;
      }
      return true;
    } catch (e) {
      errorMessage =
          'Houve um problema ao buscar o total de empréstimos concluídos';
      return false;
    }
  }

  Future<bool> buscarDadosGrafico() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final resultados = await Future.wait([
        buscarTotalEmpAtivo(),
        buscarTotalEmpConcluido(),
        buscarTotalEmpSemCorrespondencia(),
        buscarTotalEmpEmObservacao(),
      ]);

      if (resultados.contains(false)) return false;

      dadosEmp = {
        'Ativos': qntEmpAtivo!,
        'Concluidos': qntEmpConcluido!,
        'Sem Correspondência': qntEmpSC!,
        'Em Observação': qntEmpEB!,
      };
      return true;
    } catch (e) {
      errorMessage = 'Houve um problema ao buscar os dados do gráfico';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
