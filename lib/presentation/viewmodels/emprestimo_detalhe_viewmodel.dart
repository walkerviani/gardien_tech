import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:gardien_tech/data/dto/emprestimo_item_com_dispositivo_dto.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_item.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_item_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_repository.dart';

class EmprestimoDetalheViewmodel extends ChangeNotifier {
  final EmprestimoRepository _emprestimoRepository;
  final EmprestimoItemRepository _empItemRepository;
  final DispositivoRepository _dispositivoRepository;
  final EmprestimoDispositivoRepository _emprDispRepository;

  EmprestimoDetalheViewmodel(
    this._empItemRepository,
    this._dispositivoRepository,
    this._emprDispRepository,
    this._emprestimoRepository,
  );

  bool isLoading = false;
  String? errorMessage;
  List<EmprestimoItemComDispositivoDTO> itensComDispositivos = [];
  int?
  indexEmPesquisa; // Utiliza o index do Card para abrir a pesquisa em apenas um Card

  Future<void> carregarItensDoEmprestimo(int idEmprestimo) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      itensComDispositivos = await _empItemRepository
          .buscarEmprestimoItemComDispositivo(idEmprestimo);
    } catch (e) {
      errorMessage = 'Erro ao carregar os itens do empréstimos selecionado';
      itensComDispositivos = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Cria um novo emprestimo_dispositivo e adiciona no emprestimo_item
  Future<bool> vincularDispositivoNoEmprestimo(
    int idEmprestimoItem,
    int idDispositivo,
    int idEmprestimo,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _empItemRepository.vincularDispositivo(
        idEmprestimoItem,
        idDispositivo,
      );
      await carregarItensDoEmprestimo(idEmprestimo);
      return true;
    } catch (e) {
      errorMessage = 'Erro ao vincular o dispositivo';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Exclui o emprestimo_dispositivo do emprestimo_item
  Future<bool> desvincularDispositivoDoEmprestimo(
    int idEmprestimoDispositivo,
    int idEmprestimo,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _empItemRepository.desvincularDispositivo(idEmprestimoDispositivo);
      await carregarItensDoEmprestimo(idEmprestimo);
      return true;
    } catch (e) {
      errorMessage = 'Erro ao desvincular o dispositivo';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Registra a devolução = aumenta o valor de qntDevolvida do emprestimo_item
  Future<bool> registrarDevolucao(
    int idEmprestimoItem,
    int qtd,
    int idEmprestimo,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _empItemRepository.registrarDevolucao(idEmprestimoItem, qtd);
      await carregarItensDoEmprestimo(idEmprestimo);
      return true;
    } catch (e) {
      errorMessage = 'Erro ao registrar a devolução';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> atualizar(EmprestimoItem item, int idEmprestimo) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _empItemRepository.atualizar(item);
      await carregarItensDoEmprestimo(idEmprestimo);
      return true;
    } catch (e) {
      errorMessage = 'Erro ao atualizar';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> alternarDevolucao(
    int idDispositivo,
    bool devolvido,
    int idEmprestimo,
  ) async {
    if (devolvido) {
      await _dispositivoRepository.marcarDisponivel(idDispositivo);
    } else {
      await _dispositivoRepository.marcarEmUso(idDispositivo);
    }
    // seta isLoading = true e reconstrói toda a lista com o CircularProgressIndicator, "reseta" a lista visualmente
    await carregarItensDoEmprestimo(idEmprestimo); 
  }
}
