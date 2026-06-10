import 'package:drift/drift.dart';

class Cargos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nomeCargo => text()();
}