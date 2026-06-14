import 'package:drift/drift.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';

@DataClassName('DispositivoData') // Evita conflitos de nome entre classe Dispositivo no database.g.dart e entidade de domínio Dispositivo
class Dispositivos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get numSerie => integer()();
  IntColumn get numPatrimonio => integer()();
  IntColumn get idTipoDispositivo => integer()();
  IntColumn get idStatus => integer()();
  IntColumn get qtdTotal => integer()();
  IntColumn get qtdDisponivel => integer()();
}

extension DispositivoMapper on DispositivoData {
  Dispositivo toEntity() {
    return Dispositivo(
      id,
      idTipoDispositivo,
      numSerie,
      numPatrimonio,
      qtdTotal,
      qtdDisponivel,
      idStatus: idStatus,
    );
  }
}

extension DispositivoCompanionMapper on Dispositivo {
  DispositivosCompanion toCompanion() {
    return DispositivosCompanion.insert(
      numSerie: numSerie,
      numPatrimonio: numPatrimonio,
      idTipoDispositivo: idTipoDispositivo,
      idStatus: idStatus,
      qtdTotal: qtdTotal,
      qtdDisponivel: qtdDisponivel,
    );
  }
}