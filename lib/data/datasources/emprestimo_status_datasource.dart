import 'package:drift/drift.dart';

@DataClassName('EmprestimoStatusData') // Evita conflitos de nome entre classe EmprestimoStatus no database.g.dart e entidade de domínio EmprestimoStatus
class EmprestimoStatus extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nomeStatus => text()();
}