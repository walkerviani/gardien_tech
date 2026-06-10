import 'package:drift/drift.dart';
import 'package:gardien_tech/data/datasources/emprestimo_status_datasource.dart';
import 'package:gardien_tech/data/datasources/tipos_dispositivo_datasource.dart';

class Dispositivos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get numSerie => integer()();
  IntColumn get numPatrimonio => integer()();
  IntColumn get idTipoDispositivo => integer().references(TiposDispositivo, #id)();
  IntColumn get idStatus => integer().references(EmprestimoStatus, #id)();
  IntColumn get qtdTotal => integer()();
  IntColumn get qtdDisponivel => integer()();
}