import 'package:drift/drift.dart';

class EmprestimoStatus extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nomeStatus => text()();
}