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
    TipoDispositivo.values.firstWhere(
      (t) => t.id == _idTipoDispositivo,
    );

  // Getters
  int? get id => _id;
  int get idTipoDispositivo => _idTipoDispositivo;
  String get descricao => '$numPatrimonio - ${tipo.nomeTipo} - $numSerie';
}