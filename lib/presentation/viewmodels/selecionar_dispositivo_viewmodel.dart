import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';

class SelecionarDispositivoViewmodel extends ChangeNotifier {
  final DispositivoRepository _dispositivoRepository;

  SelecionarDispositivoViewmodel(this._dispositivoRepository);
  bool isLoading = false;
  String? errorMessage;

  List<Dispositivo> dispositivos = [];
  List<Dispositivo> todosDispositivos = [];
  String termoBusca = '';
  
  // Adicionar fields para guardar os filtros
  int? _idTipoDispositivoFiltro;
  List<int> _idsParaIgnorarFiltro = [];

  Future<void> carregarDispositivos({int? idTipoDispositivo, List<int> idsParaIgnorar = const []}) async {
    isLoading = true;
    errorMessage = null;
    
    // Guardar os filtros para uso em pesquisas posteriores
    _idTipoDispositivoFiltro = idTipoDispositivo;
    _idsParaIgnorarFiltro = idsParaIgnorar;
    
    notifyListeners();

    try {
      dispositivos = await _dispositivoRepository.buscarDisponiveisExcluindo(
        idTipoDispositivo: idTipoDispositivo,
        idsParaIgnorar: idsParaIgnorar,
      );
      todosDispositivos = dispositivos;
    } catch (e) {
      errorMessage = 'Erro ao carregar os dispositivos';
      dispositivos = [];
      todosDispositivos = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pesquisar(String termo) async {
    final query = termo.trim();

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
      dispositivos = resultados.where((dispositivo) {
        // Filtrar por tipo se foi especificado
        if (_idTipoDispositivoFiltro != null && dispositivo.idTipoDispositivo != _idTipoDispositivoFiltro) {
          return false;
        }
        
        // Filtrar dispositivos que já estão selecionados em outros cards
        if (_idsParaIgnorarFiltro.contains(dispositivo.id)) {
          return false;
        }
        
        return true;
      }).toList();
    } catch (e) {
      errorMessage = 'Erro ao pesquisar os dispositivos';
      dispositivos = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}