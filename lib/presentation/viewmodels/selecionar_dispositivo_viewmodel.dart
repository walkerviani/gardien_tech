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

  Future<void> carregarDispositivos({int? idTipoDispositivo, List<int> idsParaIgnorar = const []}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dispositivos = await _dispositivoRepository.buscarDisponiveisExcluindo(
        idTipoDispositivo: idTipoDispositivo,
        idsParaIgnorar: idsParaIgnorar,
      );
    } catch (e) {
      errorMessage = 'Erro ao carregar os dispositivos';
      dispositivos = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pesquisar(String termo) async {
    final query = termo.trim();

    if (query.isEmpty) {
      await carregarDispositivos();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dispositivos = await _dispositivoRepository.buscarDescricao(query);
    } catch (e) {
      errorMessage = 'Erro ao pesquisar os dispositivos';
      dispositivos = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
