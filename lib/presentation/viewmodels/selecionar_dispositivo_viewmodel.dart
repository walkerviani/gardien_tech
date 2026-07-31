import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';

class SelecionarDispositivoViewmodel extends ChangeNotifier {
  final DispositivoRepository _dispositivoRepository;

  SelecionarDispositivoViewmodel(this._dispositivoRepository);
  bool isLoading = false;
  String? errorMessage;
  List<Dispositivo> dispositivos = [];

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
}
