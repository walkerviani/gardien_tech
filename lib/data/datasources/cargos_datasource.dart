import 'package:drift/drift.dart';

@DataClassName('CargoData') // Evita conflitos de nome entre classe Cargo no database.g.dart e entidade de domínio Cargo
class Cargos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nomeCargo => text()();
}