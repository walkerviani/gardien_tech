import 'package:csv/csv.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';

class DispositivosCsvService {
  List<Dispositivo> importDispositivos(String csvString) {
    final linhas = csv.decodeWithHeaders(csvString);

    if (linhas.isEmpty) {
      throw Exception('O arquivo CSV está vazio');
    }

    final dispositivos = <Dispositivo>[];

    for (final linha in linhas) {
      final numSerie = linha['Número de Série'].toString().trim();
      final numPatrimonio = linha['Número de Patrimônio'].toString().trim();
      final tipo = linha['Tipo do Dispositivo'].toString().trim();

      // Se algum campo estiver vazio pule a linha
      if (numSerie.isEmpty || numPatrimonio.isEmpty || tipo.isEmpty) {
        continue;
      }

      final tipoDispositivo = _buscarTipoDispositivo(tipo);

      if (tipoDispositivo == null) {
        throw Exception('Tipo de dispositivo inválido: $tipo');
      }

      dispositivos.add(
        Dispositivo(null, tipoDispositivo.id, numSerie, numPatrimonio),
      );
    }

    return dispositivos;
  }

  TipoDispositivo? _buscarTipoDispositivo(String tipoStr) {
    return TipoDispositivo.values
        .where((tipo) => tipo.nomeTipo == tipoStr.trim())
        .firstOrNull;
  }
}
