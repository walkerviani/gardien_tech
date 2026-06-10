import 'package:drift/drift.dart';
import 'package:gardien_tech/data/datasources/cargos_datasource.dart';

class Usuarios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  IntColumn get idCargo => integer().references(Cargos, #id)();
}