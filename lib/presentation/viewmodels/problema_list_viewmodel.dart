import 'package:flutter/foundation.dart';
import 'package:gardien_tech/data/dto/dispositivo_com_problema_dto.dart';
import 'package:gardien_tech/domain/repositories/problema_repository.dart';

class ProblemaListViewmodel extends ChangeNotifier{
  final ProblemaRepository _repository;

  ProblemaListViewmodel(this._repository);

  bool isLoading = false;
  String? errorMessage;
  List<DispositivoComProblemaDTO> problemasAtivos = [];

  int quantidadeTotalDisponiveisComProblemas() {
    final idsUnicos = <int>{};
    for(var problema in problemasAtivos){
      idsUnicos.add(problema.idDispositivo);
    }
    return idsUnicos.length;
  }

  Future<void> carregarDispositivosComProblemas() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try{
      problemasAtivos = await _repository.buscarProblemasAtivosComDispositivos();
    } catch (e){
      errorMessage = 'Erro ao carregar os problemas ativos';
      problemasAtivos = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deletar(int id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _repository.deletar(id);
      return true;
    } catch (e) {
      errorMessage = 'Erro ao excluir o problema';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}