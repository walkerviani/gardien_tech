import 'package:drift/drift.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/domain/entities/cargo.dart';

@DataClassName('CargoData') // Evita conflitos de nome entre classe Cargo no database.g.dart e entidade de domínio Cargo
class Cargos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nomeCargo => text()();
}

extension CargoMapper on CargoData {
  Cargo toEntity() {
    return Cargo(
      id,
      nomeCargo,
    );
  }
}

extension CargoCompanionMapper on Cargo {
  CargosCompanion toCompanion() {
    return CargosCompanion.insert(
      nomeCargo: nomeCargo,
    );
  }
}