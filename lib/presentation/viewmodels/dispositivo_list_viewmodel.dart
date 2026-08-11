import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';

class DispositivoListViewmodel extends ChangeNotifier {
  final DispositivoRepository _repository;

  DispositivoListViewmodel(this._repository);

  bool isLoading = false;
  String? errorMessage;

  List<Dispositivo> dispositivos = [];
  List<Dispositivo> todosDispositivos = [];
  String termoBusca = '';

  Future<void> carregarDispositivos() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dispositivos = await _repository.buscarTodos();
    } catch (e) {
      errorMessage = 'Erro ao carregar os dispositivos';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> salvar({
    int? id,
    required String numSerie,
    required String numPatrimonio,
    required int idTipoDispositivo,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      Dispositivo dispositivo = Dispositivo(
        id,
        idTipoDispositivo,
        numSerie,
        numPatrimonio,
      );
      if (id != null) {
        await _repository.atualizar(dispositivo);
      } else {
        await _repository.criar(dispositivo);
      }
      return true;
    } catch (e) {
      errorMessage = 'Erro ao salvar o dispositivo';
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
    } on Exception catch (e) {
      if (e.toString().contains('constraint failed')) {
        errorMessage =
            'Não é possível excluir o dispositivo, pois ele está associado a outros registros';
      } else {
        errorMessage = 'Erro ao excluir o dispositivo';
      }
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pesquisar(String termo) async {
    final query = termo.trim();
    termoBusca = query;

    if (query.isEmpty) {
      await carregarDispositivos();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dispositivos = await _repository.buscarDescricao(query);
    } catch (e) {
      errorMessage = 'Erro ao pesquisar os dispositivos';
      dispositivos = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}