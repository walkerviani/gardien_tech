import 'package:drift/drift.dart';
import 'package:gardien_tech/data/datasources/emprestimo_status_datasource.dart';
import 'package:gardien_tech/data/datasources/usuario_datasource.dart';

class Emprestimos extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get dataHoraEfetuado => dateTime()(); 
  DateTimeColumn get dataHoraConcluido => dateTime().nullable()();
  IntColumn get idResponsavel => integer().references(Usuarios, #id)();
  IntColumn get idStatus => integer().references(EmprestimoStatus, #id)();
}