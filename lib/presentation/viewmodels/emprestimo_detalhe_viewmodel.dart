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
  List<Dispositivo> dispositivosPesquisa = [];
  Timer? _debounce;
  int?
  indexEmPesquisa; // Utiliza o index do Card para abrir a pesquisa em apenas um Card

  void buscarDispositivo(String value, int idTipo, int indexCard) {
    _debounce?.cancel();
    indexEmPesquisa = indexCard;
    if (value.trim().isEmpty) {
      dispositivosPesquisa = [];
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 200), () async {
      final resultado = await _dispositivoRepository.buscarDescricao(value);

      dispositivosPesquisa = resultado
          .where((d) => d.tipo.id == idTipo)
          .toList(); // Apresenta apenas dispositivos que são do mesmo tipo do emprestimo_item

      notifyListeners();
    });
  }

  Future<void> selecionarDispositivo(
    Dispositivo dispositivo,
    int idEmprestimoItem,
    int idEmprestimo,
  ) async {
    final itensComDispositivos = await _empItemRepository
        .buscarEmprestimoItemComDispositivo(idEmprestimo);

    final jaAdicionado = itensComDispositivos.any((itemDTO) {
      return itemDTO.dispositivos.any(
        (empDisp) => empDisp.idDispositivo == dispositivo.id,
      );
    });

    if (jaAdicionado) {
      errorMessage = 'Este dispositivo já foi adicionado à lista.';
      notifyListeners();
      return;
    }

    await vincularDispositivoNoEmprestimo(
      idEmprestimoItem,
      dispositivo.id!,
      idEmprestimo,
    );

    dispositivosPesquisa = [];
    errorMessage = null;
    notifyListeners();
  }

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

  Future<bool> deletarItem(
    int idEmprestimoItem,
    int idEmprestimo,
    int idDispositivo,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Busca o emprestimo_dispositivo
      final emprDisp = await _emprDispRepository.buscarPorEmprestimoItem(
        idEmprestimoItem,
      );
      final emprItem = await _empItemRepository.buscarPorId(idEmprestimoItem);
      // Filtra para achar o dispositivo a excluir
      final itemParaExcluir = emprDisp.where(
        (ed) => ed.idDispositivo == idDispositivo,
      );
      // Se não achar não exclui
      if (itemParaExcluir.isEmpty) {
        errorMessage = 'Dispositivo não encontrado';
        return false;
      }
      // Verifica se faz parte do mesmo empréstimo e exclui
      if (emprDisp.isNotEmpty && emprItem?.idEmprestimo == idEmprestimo) {
        for (var item in itemParaExcluir) {
          await _emprDispRepository.deletar(item.id!);
        }
      }
      // Exclui o emprestimo_item do item excluido
      await _empItemRepository.deletar(idEmprestimoItem);

      // Se todos os itens foram excluidos exclui o empréstimo
      final itensRestantes = await _empItemRepository.buscarPorEmprestimo(
        idEmprestimo,
      );
      if (itensRestantes.isEmpty) {
        await _emprestimoRepository.deletar(idEmprestimo);
      }

      await carregarItensDoEmprestimo(idEmprestimo);
      return true;
    } catch (e) {
      errorMessage = 'Erro ao deletar item';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
