import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
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
  final EmprestimoDispositivoRepository _empDispositivoRepository;

  EmprestimoDetalheViewmodel(
    this._empItemRepository,
    this._dispositivoRepository,
    this._empDispositivoRepository,
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

  // Cria um novo emprestimo_dispositivo e adiciona no emprestimo_item
  Future<bool> vincularDispositivoNoEmprestimo(
    int idDispositivo,
    int idEmprestimo,
    ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _empItemRepository.vincularDispositivo(
        idEmprestimo,
        idDispositivo,
      );
      // Após vincular, aumenta qtdSolicitada
      final itens = await _empItemRepository.buscarPorEmprestimo(idEmprestimo);
      final dispositivo = await _dispositivoRepository.buscarPorId(idDispositivo);
      
      if (dispositivo != null) {
        final item = itens.firstWhereOrNull(
          (i) => i.idTipoDispositivo == dispositivo.idTipoDispositivo,
        );
        if (item != null) {
          item.qtdSolicitada++;
          await _empItemRepository.atualizar(item);
        }
      }
      
      await carregarItensDoEmprestimo(idEmprestimo);
      return true;
    } catch (e) {
      errorMessage = 'Erro ao vincular o dispositivo: $e';
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

  Future<bool> deletarItem(
    int idEmprestimoItem,
    int idEmprestimo,
    int idDispositivo,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final emprDisp = await _empDispositivoRepository.buscarPorEmprestimoItem(
        idEmprestimoItem,
      );
      final emprItem = await _empItemRepository.buscarPorId(idEmprestimoItem);
      final itemParaExcluir = emprDisp.where(
        (ed) => ed.idDispositivo == idDispositivo,
      );
      if (itemParaExcluir.isEmpty) {
        errorMessage = 'Dispositivo não encontrado';
        return false;
      }
      if (emprDisp.isNotEmpty && emprItem?.idEmprestimo == idEmprestimo) {
        for (var item in itemParaExcluir) {
          await _dispositivoRepository.marcarDisponivel(idDispositivo); // libera o dispositivo removido
          await _empDispositivoRepository.deletar(item.id!);
          emprItem!.qtdSolicitada--;
          if (emprItem.qtdSolicitada == 0) {
            await _empItemRepository.deletar(emprItem.id!);
          } else {
            await _empItemRepository.atualizar(emprItem);
          }
        }
      }
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

  Future<bool> removerUnidade(
    int idEmprestimoItem,
    int idEmprestimo,
    int? idEmprestimoDispositivo,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      // Desvínculas o dispositivo
      if (idEmprestimoDispositivo != null) {
        await _empItemRepository.desvincularDispositivo(idEmprestimoDispositivo);
      }
      
      // Reduz a quantidade solicitada
      final item = await _empItemRepository.buscarPorId(idEmprestimoItem);
      if (item != null) {
        item.qtdSolicitada--;
        await _empItemRepository.atualizar(item);
      }
      
      await carregarItensDoEmprestimo(idEmprestimo);
      return true;
    } catch (e) {
      errorMessage = 'Erro ao remover unidade: $e';
      print('DEBUG: Erro removerUnidade = $e');
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