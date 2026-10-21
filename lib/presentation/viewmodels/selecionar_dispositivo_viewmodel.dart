import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';

class SelecionarDispositivoViewmodel extends ChangeNotifier {
  final DispositivoRepository _dispositivoRepository;

  SelecionarDispositivoViewmodel(this._dispositivoRepository);
  bool isLoading = false;
  String? errorMessage;

  List<Dispositivo> dispositivosSelecionados = [];
  List<Dispositivo> todosDispositivos = [];
  String termoBusca = '';

  // Adicionar fields para guardar os filtros
  int? _idTipoDispositivoFiltro;
  List<int> _idsParaIgnorarFiltro = [];
  bool filtrarPesquisa = true; // Valida se deve ser filtrado para quando for telas de empréstimos (true) e se for para histórico de dispositivos (false)

  Future<void> carregarDispositivos({
    int? idTipoDispositivo,
    List<int> idsParaIgnorar = const [],
    bool filtrarPesquisa = true,
  }) async {
    isLoading = true;
    errorMessage = null;
    this.filtrarPesquisa = filtrarPesquisa;

    // Guardar os filtros para uso em pesquisas posteriores
    _idTipoDispositivoFiltro = idTipoDispositivo;
    _idsParaIgnorarFiltro = idsParaIgnorar;

    notifyListeners();

    try {
      if (filtrarPesquisa) { // Tela de empréstimo
        dispositivosSelecionados = await _dispositivoRepository
            .buscarDisponiveisExcluindo(
              idTipoDispositivo: idTipoDispositivo,
              idsParaIgnorar: idsParaIgnorar,
            );
      } else { // Tela de histórico
        final dispositivos = await _dispositivoRepository.buscarTodos();
        dispositivosSelecionados = dispositivos.where((dispositivo) {
          if (idTipoDispositivo != null &&
              dispositivo.idTipoDispositivo != idTipoDispositivo) {
            return false;
          }
          return !idsParaIgnorar.contains(dispositivo.id);
        }).toList();
      }
      todosDispositivos = dispositivosSelecionados;
    } catch (e) {
      errorMessage = 'Erro ao carregar os dispositivos';
      dispositivosSelecionados = [];
      todosDispositivos = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pesquisar(String pesquisa) async {
    final query = pesquisa.trim();

    if (query.isEmpty) {
      // Se campo vazio, recarregar com os filtros originais
      await carregarDispositivos(
        idTipoDispositivo: _idTipoDispositivoFiltro,
        idsParaIgnorar: _idsParaIgnorarFiltro,
      );
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Buscar todos os dispositivos que correspondem à descrição
      var resultados = await _dispositivoRepository.buscarDescricao(query);

      // Aplicar os mesmos filtros que foram aplicados inicialmente
      dispositivosSelecionados = resultados.where((dispositivo) {
        // Filtrar por tipo se foi especificado
        if (_idTipoDispositivoFiltro != null &&
            dispositivo.idTipoDispositivo != _idTipoDispositivoFiltro) {
          return false;
        }

        // Filtrar dispositivos que já estão selecionados em outros cards
        if (_idsParaIgnorarFiltro.contains(dispositivo.id)) {
          return false;
        }

        // Filtrar dispositivos que estão em uso (status 3) em outros empréstimos
        if (filtrarPesquisa && dispositivo.idStatus == 3) {
          return false;
        }

        return true;
      }).toList();
    } catch (e) {
      errorMessage = 'Erro ao pesquisar os dispositivos';
      dispositivosSelecionados = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
