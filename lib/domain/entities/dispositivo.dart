import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';

class Dispositivo {
  // Atributos
  final int? _id;
  final int _idTipoDispositivo; // Não irá mudar o tipo do dispositivo
  String numSerie;
  String numPatrimonio;
  int idStatus;

  // Construtor
  Dispositivo(
    this._id,
    this._idTipoDispositivo,
    this.numSerie,
    this.numPatrimonio,
    {this.idStatus = 1} // 1 - Disponível
  );

  TipoDispositivo get tipo =>
      TipoDispositivo.values.firstWhere((t) => t.id == _idTipoDispositivo);

  static int compararPorPatrimonio(Dispositivo a, Dispositivo b) {
    return _compararStringsNaturais(a.numPatrimonio, b.numPatrimonio);
  }

  static int _compararStringsNaturais(String a, String b) {
    final aPartes = RegExp(r'[A-Za-z]+|\d+').allMatches(a).map((m) => m.group(0)!).toList();
    final bPartes = RegExp(r'[A-Za-z]+|\d+').allMatches(b).map((m) => m.group(0)!).toList();
    final limite = aPartes.length < bPartes.length ? aPartes.length : bPartes.length;

    for (int i = 0; i < limite; i++) {
      final parteA = aPartes[i];
      final parteB = bPartes[i];
      final aEhNumero = int.tryParse(parteA) != null;
      final bEhNumero = int.tryParse(parteB) != null;

      if (aEhNumero != bEhNumero) {
        return aEhNumero ? 1 : -1;
      }

      if (aEhNumero) {
        final diferenca = int.parse(parteA).compareTo(int.parse(parteB));
        if (diferenca != 0) return diferenca;
      } else {
        final diferenca = parteA.toLowerCase().compareTo(parteB.toLowerCase());
        if (diferenca != 0) return diferenca;
      }
    }

    return a.length.compareTo(b.length);
  }

  // Getters
  int? get id => _id;
  int get idTipoDispositivo => _idTipoDispositivo;

  // Json
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'idTipoDispositivo': _idTipoDispositivo,
      'numSerie': numSerie,
      'numPatrimonio': numPatrimonio,
      'idStatus': idStatus,
    };
  }

  factory Dispositivo.fromJson(Map<String, dynamic> json) {
    return Dispositivo(
      json['id'] as int?,
      json['idTipoDispositivo'] as int,
      json['numSerie'] as String,
      json['numPatrimonio'] as String,
      idStatus: json['idStatus'] as int,
    );
  }
}