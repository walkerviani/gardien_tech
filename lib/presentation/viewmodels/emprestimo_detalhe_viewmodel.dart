import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:gardien_tech/data/dto/emprestimo_item_com_dispositivo_dto.dart';
import 'package:gardien_tech/domain/entities/emprestimo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_item.dart';
import 'package:gardien_tech/domain/enum/emprestimo_status.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_item_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_repository.dart';
import 'package:gardien_tech/domain/services/emprestimo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmprestimoDetalheViewmodel extends ChangeNotifier {
  final EmprestimoRepository _emprestimoRepository;
  final EmprestimoItemRepository _empItemRepository;
  final EmprestimoService _emprestimoService;
  final DispositivoRepository _dispositivoRepository;
  final EmprestimoDispositivoRepository _empDispositivoRepository;

  // Cache para manter o estado dos checkboxes mesmo após sair e voltar da tela
  final Map<int, bool> _dispositivosDevolvidos = {};

  EmprestimoDetalheViewmodel(
    this._empItemRepository,
    this._emprestimoRepository,
    this._emprestimoService,
    this._dispositivoRepository,
    this._empDispositivoRepository,
  );

  bool isLoading =
      true; // true por padrão para permitir a renderização do Shimmer
  String? errorMessage;
  List<EmprestimoItemComDispositivoDTO> dispositivosDoEmprestimo =
      []; // Lista dos dispositivos presente no emprestimo
  List<EmprestimoItem> empItens =
      []; // Lista usada para verificar a devolução dos dispositivos de cada emprestimo_item
  bool empFinalizado =
      false; // Usado para controlar a visualização da lista na tela (entre edição e leitura)
  bool empSemCorrespondencia = false;

  // Restaura na memória local o estado das marcações de devolução (checkboxes) dos dispositivos de um empréstimo
  Future<void> carregarCacheDevolvidos(int idEmprestimo) async {
    final prefs = await SharedPreferences.getInstance();
    _dispositivosDevolvidos.clear();

    // Busca as chaves gravadas no armazenamento e seleciona apenas as que começam com o padrão "devolvido_emp{idEmprestimo}_"
    final chaves = prefs.getKeys();
    for (var chave in chaves) {
      if (chave.startsWith('devolvido_emp${idEmprestimo}_')) {
        final idEmpDisp = int.parse(
          chave.replaceFirst('devolvido_emp${idEmprestimo}_', ''),
        );
        final valor = prefs.getBool(chave) ?? false;
        _dispositivosDevolvidos[idEmpDisp] = valor;
      }
    }
  }

  // Salva o estado no cache quando marca/desmarca
  Future<void> salvarCacheDevolvido(
    int idEmprestimo,
    int idEmpDisp,
    bool marcado,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final chave = 'devolvido_emp${idEmprestimo}_$idEmpDisp';
    await prefs.setBool(chave, marcado);
    _dispositivosDevolvidos[idEmpDisp] = marcado;
  }

  // Retorna o estado do cache (sem consultar banco)
  bool? obterEstadoCache(int idEmpDisp) {
    return _dispositivosDevolvidos[idEmpDisp];
  }

  // Lista todos os dispositivos do emprestimo informado
  Future<void> carregarDispositivosDoEmprestimo(int idEmprestimo) async {
    isLoading = true;
    errorMessage = null;
    dispositivosDoEmprestimo = [];
    notifyListeners();

    await Future.delayed(Duration.zero);

    try {
      // Carrega banco de dados e cache em paralelo com a tela Shimmer
      final resultados = await Future.wait([
        _empItemRepository.buscarEmprestimoItemComDispositivo(idEmprestimo),
        carregarCacheDevolvidos(idEmprestimo),
        verificarStatusEmprestimo(idEmprestimo),
      ]);

      dispositivosDoEmprestimo =
          resultados[0] as List<EmprestimoItemComDispositivoDTO>;
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
    if (emprestimo != null &&
        (emprestimo.idStatus == 3 || emprestimo.idStatus == 4)) {
      // Status finalizado
      empFinalizado = true;
    } else {
      empFinalizado = false;
    }
    return empFinalizado;
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
      await _emprestimoService.trocarDispositivo(
        idEmprestimoDispositivo,
        idDispositivo,
      );
      return true;
    } catch (e) {
      errorMessage = "Erro ao trocar o dispositivo";
      return false;
    }
  }

  // Verifica se ocorreu a devolução completa de cada emprestimo_item
  Future<bool> finalizarEmprestimo(int idEmprestimo) async {
    errorMessage = null;

    isLoading = true;
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

  Future<bool> definirSemCorrespondencia(int idEmprestimo) async {
    errorMessage = null;

    isLoading = true;
    notifyListeners();

    final emprestimo = await _emprestimoRepository.buscarPorId(idEmprestimo);
    final estaEmObservacao =
        emprestimo?.idStatus == EmprestimoStatus.emObservacao.id;

    try {
      if (!estaEmObservacao) {
        errorMessage =
            'Essa operação requer que o empréstimo esteja Em Observação';
        return false;
      }

      final sucesso = await _emprestimoService.verificarSemCorrespondencia(
        idEmprestimo,
      );
      if (!sucesso) {
        errorMessage = 'Não é possível definir como Sem Correspondência';
        return false;
      }

      await _emprestimoRepository.definirSemCorrespondencia(idEmprestimo);
      return true;
    } catch (e) {
      errorMessage =
          'Ocorreu um erro ao definir o empréstimo como "Sem correspondência"';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Exclui empréstimo não finalizado e libera os dispositivos vinculados
  Future<bool> excluirEmprestimo(int idEmprestimo) async {
    try {
      final itensDTO = await _empItemRepository
          .buscarEmprestimoItemComDispositivo(idEmprestimo);

      // Libera os dispositivos
      for (final itemDTO in itensDTO) {
        for (final dispositivo in itemDTO.dispositivosObj) {
          await _dispositivoRepository.marcarDisponivel(dispositivo.id!);
        }
      }

      // Remove os vínculos dos dispositivos
      for (final itemDTO in itensDTO) {
        for (final empDispositivo in itemDTO.dispositivos) {
          await _empDispositivoRepository.deletar(empDispositivo.id!);
        }
      }

      // Remove os itens
      final itens = await _empItemRepository.buscarPorEmprestimo(idEmprestimo);
      for (final item in itens) {
        await _empItemRepository.deletar(item.id!);
      }

      // Remove o empréstimo
      await _emprestimoRepository.deletar(idEmprestimo);

      return true;
    } catch (e) {
      errorMessage = "Erro ao excluir o empréstimo";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> alternarDevolucao(
    int idDispositivo,
    bool marcarDevolvido,
    int idEmprestimo,
    int idEmprestimoDispositivo,
    int idEmprestimoItem,
  ) async {
    if (marcarDevolvido) {
      // Marca como disponível no banco
      await _dispositivoRepository.marcarDisponivel(idDispositivo);
      // Aumenta a quantidade devolvida do item
      await _empItemRepository.aumentarQntDevolvida(idEmprestimoItem, 1);
      // Salva no cache que foi marcado como devolvido neste empréstimo
      await salvarCacheDevolvido(idEmprestimo, idEmprestimoDispositivo, true);
      return true;
    } else {
      // Verifica se o dispositivo está em uso em outro empréstimo
      final dispositivo = await _dispositivoRepository.buscarPorId(
        idDispositivo,
      );
      if (dispositivo != null && dispositivo.idStatus == 3) {
        // Status EM_USO
        errorMessage = 'Este dispositivo está sendo usado em outro empréstimo';
        notifyListeners();
        return false;
      }
      await _dispositivoRepository.marcarEmUso(idDispositivo);
      // Diminui a quantidade devolvida do item
      final item = await _empItemRepository.buscarPorId(idEmprestimoItem);
      if (item != null && item.qtdDevolvida > 0) {
        await _empItemRepository.diminuirQntDevolvida(idEmprestimoItem, 1);
      }
      // Salva no cache que foi desmarcado neste empréstimo
      await salvarCacheDevolvido(idEmprestimo, idEmprestimoDispositivo, false);
      return true;
    }
  }

  // Marca todos dispositivos como disponível
  Future<bool> marcarTodos(int idEmprestimo) async {
    try {
      for (final itemDTO in dispositivosDoEmprestimo) {
        for (final empDispositivo in itemDTO.dispositivos) {
          if (empDispositivo.id == null) {
            continue;
          }

          final dispositivo = itemDTO.dispositivosObj.firstWhereOrNull(
            (d) => d.id == empDispositivo.idDispositivo,
          );

          if (dispositivo == null) {
            continue;
          }

          final marcado = obterEstadoCache(empDispositivo.id!) ?? false;

          if (!marcado) {
            await alternarDevolucao(
              dispositivo.id!,
              true,
              idEmprestimo,
              empDispositivo.id!,
              itemDTO.item.id!,
            );
          }
        }
      }

      await carregarDispositivosDoEmprestimo(idEmprestimo);
      return true;
    } catch (e) {
      errorMessage = 'Erro ao marcar todos os dispositivos.';
      return false;
    }
  }

  // Desmarca todos dispositivos (ficando Em Uso)
  Future<bool> desmarcarTodos(int idEmprestimo) async {
    try {
      for (final itemDTO in dispositivosDoEmprestimo) {
        for (final empDispositivo in itemDTO.dispositivos) {
          // Ignora vínculos vazios
          if (empDispositivo.id == null ||
              empDispositivo.idDispositivo == null) {
            continue;
          }

          final dispositivo = itemDTO.dispositivosObj.firstWhereOrNull(
            (d) => d.id == empDispositivo.idDispositivo,
          );

          if (dispositivo == null) {
            continue;
          }

          final marcado = obterEstadoCache(empDispositivo.id!) ?? false;

          if (marcado) {
            final sucesso = await alternarDevolucao(
              dispositivo.id!,
              false,
              idEmprestimo,
              empDispositivo.id!,
              itemDTO.item.id!,
            );

            if (!sucesso) {
              return false;
            }
          }
        }
      }

      await carregarDispositivosDoEmprestimo(idEmprestimo);
      return true;
    } catch (e) {
      errorMessage = 'Erro ao desmarcar todos os dispositivos.';
      return false;
    }
  }

  void resetState() {
    isLoading = true;
    errorMessage = null;
    empFinalizado = false;
    dispositivosDoEmprestimo.clear();
    empItens.clear();
    notifyListeners();
  }
}
