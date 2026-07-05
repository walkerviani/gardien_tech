import 'package:flutter/foundation.dart';
import 'package:gardien_tech/data/dto/dispositivo_com_problema_dto.dart';
import 'package:gardien_tech/domain/entities/problema.dart';
import 'package:gardien_tech/domain/repositories/problema_repository.dart';

class ProblemaViewmodel extends ChangeNotifier{
  final ProblemaRepository _repository;

  ProblemaViewmodel(this._repository);

  bool isLoading = false;
  String? errorMessage;
  List<Problema> problemas = [];
  List<DispositivoComProblemaDto> problemasAtivos = [];

  int quantidadeTotalDisponiveisComProblemas() {
    final idsUnicos = <int>{};
    for(var problema in problemasAtivos){
      idsUnicos.add(problema.idDispositivo);
    }
    return idsUnicos.length;
  }

  Future<void> carregarProblemas() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      problemas = await _repository.buscarTodos();
    } catch (e) {
      errorMessage = 'Erro ao carregar os problemas do dispositivo';
      problemas = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarProblemasPorDisp(int idDispositivo) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      problemas = await _repository.buscarTodosPorDispositivo(idDispositivo);
    } catch (e) {
      errorMessage = 'Erro ao carregar os problemas do dispositivo';
      problemas = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
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

  Future<bool> salvar({
    int? id,
    required int idDispositivo,
    required String descricao,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    if (descricao.trim().isEmpty) {
      errorMessage = 'A descrição é obrigatória';
      isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      Problema problema = Problema(id, idDispositivo, descricao);
      if (id != null) {
        await _repository.atualizar(problema);
      } else {
        await _repository.criar(problema);
      }
      return true;
    } catch (e) {
      errorMessage = 'Erro ao salvar o problema';
      return false;
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