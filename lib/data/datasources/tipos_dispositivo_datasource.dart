import 'package:drift/drift.dart';

@DataClassName('TipoDispositivoData') // Evita conflitos de nome entre classe TipoDispositivo no database.g.dart e entidade de domínio TipoDispositivo
class TiposDispositivo extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nomeTipo => text()();
}