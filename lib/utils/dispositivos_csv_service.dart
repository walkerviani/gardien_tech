import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';

class DispositivosCsvService {
  Future<List<Dispositivo>> importDispositivos(File arquivo) async {
    final List<List<dynamic>> linhas = await arquivo
        .openRead()
        .transform(utf8.decoder)
        .transform(csv.decoder)
        .toList();

    if (linhas.isEmpty) {
      throw Exception('O arquivo CSV está vazio');
    }

    final dispositivos = <Dispositivo>[];

    for (int i = 1; i < linhas.length; i++) {
      final linha = linhas[i];

      // Validar se linha tem pelo menos 3 elementos
      if (linha.length < 3) {
        continue;
      }

      final numPatrimonio = linha[0].toString().trim();
      final numSerie = linha[1].toString().trim();
      final tipo = linha[2].toString().trim();

      if (numPatrimonio.isEmpty || numSerie.isEmpty || tipo.isEmpty) {
        continue;
      }

      final tipoDispositivo = _buscarTipoDispositivo(tipo);
      if (tipoDispositivo == null) {
        continue;
      }

      dispositivos.add(
        Dispositivo(null, tipoDispositivo.id, numSerie, numPatrimonio),
      );
    }

    if (dispositivos.isEmpty) {
      throw Exception('Nenhum dispositivo válido foi encontrado no arquivo');
    }

    return dispositivos;
  }

  TipoDispositivo? _buscarTipoDispositivo(String tipoStr) {
    return TipoDispositivo.values
        .where((tipo) => tipo.nomeTipo == tipoStr.trim())
        .firstOrNull;
  }
}
