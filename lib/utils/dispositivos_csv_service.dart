import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';

class DispositivosCsvService {
  Future<(List<Dispositivo>, List<String>)> importDispositivos(
    File arquivo,
  ) async {
    final List<List<dynamic>> linhas = await arquivo
        .openRead()
        .transform(utf8.decoder)
        .transform(csv.decoder)
        .toList();

    if (linhas.isEmpty) {
      throw Exception('O arquivo CSV está vazio');
    }

    final dispositivos = <Dispositivo>[];
    final erros = <String>[];

    for (int i = 1; i < linhas.length; i++) {
      final linha = linhas[i];
      final numeroLinha = i + 1; // linha real no arquivo (cabeçalho = 1)

      // Validar se linha tem pelo menos 3 elementos
      if (linha.length < 3) {
        erros.add('Linha $numeroLinha: menos de 3 colunas');
        continue;
      }

      final numPatrimonio = linha[0].toString().trim();
      final numSerie = linha[1].toString().trim();
      final tipo = linha[2].toString().trim();

      if (numPatrimonio.isEmpty || numSerie.isEmpty || tipo.isEmpty) {
        erros.add('Linha $numeroLinha: campo vazio');
        continue;
      }

      final tipoDispositivo = _buscarTipoDispositivo(tipo);
      if (tipoDispositivo == null) {
        erros.add('Linha $numeroLinha: tipo "$tipo" inválido');
        continue;
      }

      dispositivos.add(
        Dispositivo(null, tipoDispositivo.id, numSerie, numPatrimonio),
      );
    }

    if (dispositivos.isEmpty) {
      throw Exception('Nenhum dispositivo válido foi encontrado no arquivo.');
    }

    return (dispositivos, erros);
  }

  TipoDispositivo? _buscarTipoDispositivo(String tipoStr) {
    final valor = tipoStr.trim();

    // Tenta pelo nome
    final porNome = TipoDispositivo.values
        .where((tipo) => tipo.nomeTipo == valor)
        .firstOrNull;

    if (porNome != null) {
      return porNome;
    }
    // Tenta pelo índice
    final indice = int.tryParse(valor);

    if (indice != null &&
        indice >= 0 &&
        indice < TipoDispositivo.values.length) {
      return TipoDispositivo.values[indice];
    }
    return null;
  }
}
