import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/entities/emprestimo.dart';
import 'package:gardien_tech/domain/services/dashboard_service.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';

class HistoricoDispositivoViewmodel extends ChangeNotifier {
  final DashboardService _dashboardService;
  final UsuarioRepository _usuarioRepository;

  HistoricoDispositivoViewmodel(
    this._dashboardService,
    this._usuarioRepository,
  );

  bool isLoading = false;
  String? errorMessage;
  List<Emprestimo> emprestimos = [];
  Map<int, String> _nomesResponsaveis = {};

  String nomeUsuario(int idResponsavel) => _nomesResponsaveis[idResponsavel] ?? 'Usuário não encontrado';

  Future<void> carregarHistorico(int idDispositivo) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      emprestimos = await _dashboardService.historicoDispositivoEmprestado(idDispositivo);
      
      // Ordena emprestimos do mais recente para o mais antigo
      emprestimos.sort((a, b) => b.dataHoraEfetuado.compareTo(a.dataHoraEfetuado));
      final idsResponsaveis = emprestimos
          .map((emprestimo) => emprestimo.idResponsavel)
          .toSet();
      final nomes = await Future.wait(
        idsResponsaveis.map((id) async {
          try {
            final usuario = await _usuarioRepository.buscarPorId(id);
            return MapEntry(id, usuario?.nome ?? 'Usuário não encontrado');
          } catch (_) {
            return MapEntry(id, 'Usuário não encontrado');
          }
        }),
      );
      _nomesResponsaveis = Map.fromEntries(nomes);
    } catch (_) {
      emprestimos = [];
      _nomesResponsaveis = {};
      errorMessage = 'Erro ao carregar o histórico deste dispositivo';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
