import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/entities/cargo.dart';
import 'package:gardien_tech/domain/repositories/cargo_repository.dart';

class CargoViewModel extends ChangeNotifier {
  final CargoRepository _repository;

  CargoViewModel(this._repository);

  bool isLoading = false;
  String? errorMessage;
  List<Cargo> cargos = [];

  Future<void> carregarCargos() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      cargos = await _repository.buscarTodos();
    } catch (e) {
      errorMessage = 'Erro ao carregar os cargos';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> salvar({int? id, required String nome}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      Cargo cargo = Cargo(id, nome);
      if (id != null) {
        await _repository.atualizar(cargo);
      } else {
        await _repository.criar(cargo);
      }
      return true;
    } catch (e) {
      errorMessage = 'Erro ao salvar o cargo';
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
      errorMessage = 'Erro ao excluir o cargo';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
