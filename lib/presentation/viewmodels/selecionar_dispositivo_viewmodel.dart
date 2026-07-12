import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';

class SelecionarDispositivoViewmodel extends ChangeNotifier {
  final DispositivoRepository _dispositivoRepository;

  SelecionarDispositivoViewmodel(this._dispositivoRepository);
  bool isLoading = false;
  String? errorMessage;
  List<Dispositivo> dispositivos = [];

  Future<void> carregarDispositivos(int? tipoDispositivo) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (tipoDispositivo != null) {
        dispositivos = await _dispositivoRepository.buscarPorTipo(
          tipoDispositivo,
        );
      } else {
        dispositivos = await _dispositivoRepository.buscarTodos();
      }

      dispositivos = dispositivos
          .where((dispositivo) => dispositivo.idStatus == 1)
          .toList();
    } catch (e) {
      errorMessage = 'Erro ao carregar os dispositivos';
      dispositivos = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
