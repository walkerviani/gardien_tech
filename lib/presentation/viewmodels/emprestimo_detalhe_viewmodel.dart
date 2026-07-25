import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gardien_tech/data/dto/emprestimo_item_com_dispositivo_dto.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_item.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_item_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_repository.dart';
import 'package:gardien_tech/domain/services/emprestimo_service.dart';

class EmprestimoDetalheViewmodel extends ChangeNotifier {
  final EmprestimoRepository _emprestimoRepository;
  final EmprestimoItemRepository _empItemRepository;
  final DispositivoRepository _dispositivoRepository;
  final EmprestimoDispositivoRepository _empDispositivoRepository;
  final EmprestimoService _emprestimoService;

  EmprestimoDetalheViewmodel(
    this._empItemRepository,
    this._dispositivoRepository,
    this._empDispositivoRepository,
    this._emprestimoRepository,
    this._emprestimoService,
  );

  bool isLoading = false;
  String? errorMessage;
  List<EmprestimoItemComDispositivoDTO> dispositivosDoEmprestimo =
      []; // Lista dos dispositivos presente no emprestimo
  List<EmprestimoItem> empItens =
      []; // Lista usada para verificar a devolução dos dispositivos de cada emprestimo_item
  bool empFinalizado =
      false; // Usado para controlar a visualização da lista na tela (entre edição e leitura)

  // Lista todos os dispositivos do emprestimo informado
  Future<void> carregarDispositivosDoEmprestimo(int idEmprestimo) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dispositivosDoEmprestimo = await _empItemRepository
          .buscarEmprestimoItemComDispositivo(idEmprestimo);
      await verificarStatusEmprestimo(idEmprestimo);
    } catch (e) {
      errorMessage = "Erro ao carregar o empréstimo";
      dispositivosDoEmprestimo = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Verifica se o empréstimo está finalizado, se está define a var para true
  Future<bool> verificarStatusEmprestimo(int idEmprestimo) async {
    Emprestimo? emprestimo = await _emprestimoRepository.buscarPorId(
      idEmprestimo,
    );
    if (emprestimo!.idStatus == 3) {
      // Status finalizado
      empFinalizado = true;
    } else {
      empFinalizado = false;
    }
    return false;
  }

  // Adiciona um novo emprestimo_dispositivo com um objeto dispositivo já vinculado ao emprestimo_item
  Future<bool> adicionarDispositivo(int idEmprestimo, int idDispositivo) async {
    errorMessage = null;

    try {
      await _emprestimoService.adicionarDispositivoAoEmprestimo(
        idEmprestimo,
        idDispositivo,
      );
      return true;
    } catch (e) {
      errorMessage = "Erro ao adicionar o dispositivo";
      return false;
    }
  }

  // Vincula um dispositivo em um emprestimo_dispositivo vazio
  Future<bool> vincularDispositivo(
    int idEmprestimoDispositivo,
    int idDispositivo,
  ) async {
    errorMessage = null;

    try {
      await _emprestimoService.vincularDispositivo(
        idEmprestimoDispositivo,
        idDispositivo,
      );
      return true;
    } catch (e) {
      errorMessage = "Erro ao vincular o dispositivo";
      return false;
    }
  }

  // Remove o emprestimo_dispositivo do emprestimo_item
  Future<bool> removerDispositivo(int idEmprestimoDispositivo) async {
    errorMessage = null;

    try {
      await _emprestimoService.desvincularDispositivo(idEmprestimoDispositivo);
      return true;
    } catch (e) {
      errorMessage = "Erro ao remover o dispositivo";
      return false;
    }
  }

  // Trocar o dispositivo do emprestimo_dispositivo
  Future<bool> trocarDispositivo(
    int idEmprestimoDispositivo,
    int idDispositivo,
  ) async {
    errorMessage = null;

    try {
      EmprestimoDispositivo? emprestimoDispositivo =
          await _empDispositivoRepository.buscarPorId(idEmprestimoDispositivo);

      if (emprestimoDispositivo == null) {
        errorMessage = "O item não existe";
        return false;
      }

      if (emprestimoDispositivo.idDispositivo == null) {
        errorMessage = "O item não possui dispositivo vinculado";
        return false;
      }

      // Busca cada dispositivo
      int idDispositivoAntigo = emprestimoDispositivo.idDispositivo!;
      Dispositivo? dispositivoAntigo = await _dispositivoRepository.buscarPorId(
        idDispositivoAntigo,
      );
      Dispositivo? dispositivoNovo = await _dispositivoRepository.buscarPorId(
        idDispositivo,
      );
      if (dispositivoNovo == null) {
        errorMessage = "O dispositivo não existe";
        return false;
      }

      // Verifica se os dispositivos são do mesmo tipo
      if (dispositivoAntigo?.idTipoDispositivo !=
          dispositivoNovo.idTipoDispositivo) {
        errorMessage = "O dispositivo precisa ter o mesmo tipo";
        return false;
      }
      EmprestimoDispositivo novoEmpDisp = EmprestimoDispositivo(
        emprestimoDispositivo.id,
        emprestimoDispositivo.idEmprestimoItem,
        idDispositivo: dispositivoNovo.id,
      );

      // Atualiza o item
      await _empDispositivoRepository.atualizar(novoEmpDisp);
      return true;
    } catch (e) {
      errorMessage = "Erro ao trocar o dispositivo";
      return false;
    }
  }

  // Verifica se ocorreu a devolução completa de cada emprestimo_item
  Future<bool> finalizarEmprestimo(int idEmprestimo) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      empItens = await _empItemRepository.buscarPorEmprestimo(idEmprestimo);

      for (EmprestimoItem empItem in empItens) {
        bool sucesso = await _empItemRepository.verificarDevolucao(empItem.id!);
        if (!sucesso) {
          errorMessage = "Ainda há dispositivos a serem devolvidos";
          return false;
        }
      }
      await _emprestimoRepository.concluir(idEmprestimo);
      return true;
    } catch (e) {
      errorMessage = "Erro ao finalizar o empréstimo";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
