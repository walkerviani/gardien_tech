import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/entities/cargo.dart';
import 'package:gardien_tech/domain/repositories/cargo_repository.dart';

class CargoViewModel extends ChangeNotifier{
  final CargoRepository _repository;

  CargoViewModel(this._repository);

  bool isLoading = false;
  String? errorMessage;

  Future<bool> salvar({int? id, required String nome}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      Cargo cargo = Cargo(id, nome);
      if(id != null) {
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
}