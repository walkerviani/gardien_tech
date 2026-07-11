import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:gardien_tech/data/dto/emprestimo_item_com_dispositivo_dto.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_item.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_item_repository.dart';

class EmprestimoDetalheViewmodel extends ChangeNotifier {
  final EmprestimoItemRepository _repository;
  final DispositivoRepository _dispositivoRepository;

  EmprestimoDetalheViewmodel(this._repository, this._dispositivoRepository);

  bool isLoading = false;
  String? errorMessage;
  List<EmprestimoItemComDispositivoDTO> itensComDispositivos = [];
  List<Dispositivo> dispositivosPesquisa = [];
  Timer? _debounce;
  int? indexEmPesquisa;

  List<EmprestimoItemComDispositivoDTO> get itensParaExibir {
    final itens = <EmprestimoItemComDispositivoDTO>[];

    for (final itemDTO in itensComDispositivos) {
      if (itemDTO.item.ehQuantitativo) {
        for (int i = 0; i < itemDTO.item.qtdSolicitada; i++) {
          itens.add(itemDTO);
        }
      } else {
        itens.add(itemDTO);
      }
    }

    return itens;
  }

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
    final itensComDispositivos = await _repository
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
      itensComDispositivos = await _repository
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
      await _repository.vincularDispositivo(idEmprestimoItem, idDispositivo);
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
      await _repository.desvincularDispositivo(idEmprestimoDispositivo);
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
      await _repository.registrarDevolucao(idEmprestimoItem, qtd);
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
      await _repository.atualizar(item);
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

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
