import 'package:drift/drift.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';

@DataClassName('DispositivoData') // Evita conflitos de nome entre classe Dispositivo no database.g.dart e entidade de domínio Dispositivo
class Dispositivos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idTipoDispositivo => integer()();
  TextColumn get numSerie => text()();
  IntColumn get numPatrimonio => integer()();
  IntColumn get idStatus => integer()();
}

extension DispositivoMapper on DispositivoData {
  Dispositivo toEntity() {
    return Dispositivo(
      id,
      idTipoDispositivo,
      numSerie,
      numPatrimonio,
      idStatus: idStatus,
    );
  }
}

extension DispositivoCompanionMapper on Dispositivo {
  DispositivosCompanion toCompanion() {
    return DispositivosCompanion.insert(
      id: id != null ? Value(id!) : const Value.absent(),
      idTipoDispositivo: idTipoDispositivo,
      numSerie: numSerie,
      numPatrimonio: numPatrimonio,
      idStatus: idStatus,
    );
  }
}