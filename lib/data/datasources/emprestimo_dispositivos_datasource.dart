import 'package:drift/drift.dart';
import 'package:gardien_tech/data/datasources/dispositivo_datasource.dart';
import 'package:gardien_tech/data/datasources/emprestimo_item_datasource.dart';

class EmprestimoDispositivos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idEmprestimoItem => integer().references(EmprestimoItens, #id)();
  IntColumn get idDispositivo => integer().references(Dispositivos, #id).nullable()();
}