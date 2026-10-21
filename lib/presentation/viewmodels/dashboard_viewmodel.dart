import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:gardien_tech/domain/services/dashboard_service.dart';

class DashboardViewmodel extends ChangeNotifier {
  final DashboardService _dashboardService;

  DashboardViewmodel(this._dashboardService);

  bool isLoadingEmp = true;
  String? errorMessageEmp;
  int? qntTotalEmprestimo;
  int? qntEmpAtivo;
  int? qntEmpEB; // Em observacao
  int? qntEmpSC; // Sem correspondencia
  int? qntEmpConcluido;
  Map<String, int> dadosEmp = {};

  bool isLoadingDisp = true;
  String? errorMessageDisp;
  Map<TipoDispositivo, int> dadosDisp = {};

  bool isLoadingUsu = true;
  String? errorMessageUsu;
  Map<String, int> dadosUsu = {};
  static const rotuloOutros = 'OUTROS';

  Map<String, int> get dadosUsuTop {
    final ordernados = dadosUsu.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Ordena pelo valor

    final top = ordernados.take(5); // Pega os 5 primeiros

    final somaOutros = ordernados
        .skip(5)
        .fold(0, (soma, e) => soma + e.value); // Soma todos após os 5 primeiros

    return {
      for (final usuario in top) usuario.key: usuario.value,
      if (somaOutros > 0) rotuloOutros: somaOutros,
    };
  }

  Future<bool> buscarTotalEmprestimos() async {
    errorMessageEmp = null;
    qntTotalEmprestimo = null;
    try {
      qntTotalEmprestimo = await _dashboardService.totalEmprestimos();
      if (qntTotalEmprestimo == null) {
        errorMessageEmp = 'O total de empréstimos é nulo';
        return false;
      }
      return true;
    } catch (e) {
      errorMessageEmp = 'Houve um problema ao buscar o total de empréstimos';
      return false;
    }
  }

  Future<bool> buscarTotalEmpAtivo() async {
    errorMessageEmp = null;
    qntEmpAtivo = null;
    try {
      qntEmpAtivo = await _dashboardService.totalEmprestimosAtivos();
      if (qntEmpAtivo == null) {
        errorMessageEmp = 'O total de empréstimos ativos é nulo';
        return false;
      }
      return true;
    } catch (e) {
      errorMessageEmp =
          'Houve um problema ao buscar o total de empréstimos ativos';
      return false;
    }
  }

  Future<bool> buscarTotalEmpEmObservacao() async {
    errorMessageEmp = null;
    qntEmpEB = null;
    try {
      qntEmpEB = await _dashboardService.totalEmprestimosEmObservacao();
      if (qntEmpEB == null) {
        errorMessageEmp = 'O total de empréstimos em observação é nulo';
        return false;
      }
      return true;
    } catch (e) {
      errorMessageEmp =
          'Houve um problema ao buscar o total de empréstimos em observação';
      return false;
    }
  }

  Future<bool> buscarTotalEmpSemCorrespondencia() async {
    errorMessageEmp = null;
    qntEmpSC = null;
    try {
      qntEmpSC = await _dashboardService.totalEmprestimosSemCorrespondencia();
      if (qntEmpSC == null) {
        errorMessageEmp = 'O total de empréstimos sem correspondência é nulo';
        return false;
      }
      return true;
    } catch (e) {
      errorMessageEmp =
          'Houve um problema ao buscar o total de empréstimos sem correspondência';
      return false;
    }
  }

  Future<bool> buscarTotalEmpConcluido() async {
    errorMessageEmp = null;
    qntEmpConcluido = null;
    try {
      qntEmpConcluido = await _dashboardService.totalEmprestimosConcluidos();
      if (qntEmpConcluido == null) {
        errorMessageEmp = 'O total de empréstimos concluídos é nulo';
        return false;
      }
      return true;
    } catch (e) {
      errorMessageEmp =
          'Houve um problema ao buscar o total de empréstimos concluídos';
      return false;
    }
  }

  Future<bool> buscarDadosGraficoEmp() async {
    isLoadingEmp = true;
    errorMessageEmp = null;
    notifyListeners();
    try {
      final resultados = await Future.wait([
        buscarTotalEmprestimos(),
        buscarTotalEmpAtivo(),
        buscarTotalEmpConcluido(),
        buscarTotalEmpSemCorrespondencia(),
        buscarTotalEmpEmObservacao(),
      ]);

      if (resultados.contains(false)) return false;

      dadosEmp = {
        'Ativos': qntEmpAtivo!,
        'Concluídos': qntEmpConcluido!,
        'Sem Correspondência': qntEmpSC!,
        'Em Observação': qntEmpEB!,
      };
      return true;
    } catch (e) {
      errorMessageEmp = 'Houve um problema ao buscar os dados dos empréstimos';
      return false;
    } finally {
      isLoadingEmp = false;
      notifyListeners();
    }
  }

  Future<bool> buscarDadosGraficoDisp() async {
    isLoadingDisp = true;
    errorMessageDisp = null;
    notifyListeners();
    try {
      final resultado = await _dashboardService.totalDispositivosPorTipo();

      // Garante todos os tipos, na ordem do enum, mesmo com zero dispositivos
      dadosDisp = {
        for (final tipo in TipoDispositivo.values) tipo: resultado[tipo] ?? 0,
      };
      return true;
    } catch (e) {
      errorMessageDisp =
          'Houve um problema ao buscar os dados dos dispositivos';
      return false;
    } finally {
      isLoadingDisp = false;
      notifyListeners();
    }
  }

  Future<bool> buscarDadosGraficoUsu() async {
    isLoadingUsu = true;
    errorMessageUsu = null;
    notifyListeners();
    try {
      dadosUsu = await _dashboardService.totalEmprestimosUsuarios();
      return true;
    } catch (e) {
      errorMessageUsu = 'Houve um problema ao buscar os dados dos usuários';
      return false;
    } finally {
      isLoadingUsu = false;
      notifyListeners();
    }
  }
}
