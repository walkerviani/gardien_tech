import 'package:flutter/foundation.dart';
import 'package:gardien_tech/data/dto/emprestimo_com_detalhes_dto.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_repository.dart';

class EmprestimoListViewmodel extends ChangeNotifier {
  final EmprestimoRepository _repository;

  EmprestimoListViewmodel(this._repository);

  bool isLoading = false;
  String? errorMessage;
  List<EmprestimoComDetalhesDTO> emprestimos = [];

  Future<void> carregarEmprestimosDoDia(DateTime data) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      emprestimos = await _repository.buscarporDiaTelaInicial(data);
    } catch (e) {
      errorMessage = 'Erro ao carregar os empréstimos do dia selecionado';
      emprestimos = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Define todos os empréstimos ativos com data anterior ao dia atual em 'Em observação'
  Future<void> definirEmObservacao() async {
    errorMessage = null;
    try {
      await _repository.definirEmObservacao();
    } catch (e) {
      errorMessage = 'Erro ao definir os empréstimos em observação';
    }
  }
}
