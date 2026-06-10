import 'package:drift/drift.dart';

class TiposDispositivo extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nomeTipo => text()();
}