import 'package:drift/drift.dart';
import 'package:gardien_tech/data/datasources/cargos_datasource.dart';

@DataClassName('UsuarioData') // Evita conflitos de nome entre classe Usuario no database.g.dart e entidade de domínio Usuario
class Usuarios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  IntColumn get idCargo => integer().references(Cargos, #id)();
}