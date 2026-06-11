import 'package:drift/drift.dart';
import 'package:gardien_tech/data/datasources/emprestimo_status_datasource.dart';
import 'package:gardien_tech/data/datasources/usuario_datasource.dart';

@DataClassName('EmprestimoData') // Evita conflitos de nome entre classe Emprestimo no database.g.dart e entidade de domínio Emprestimo
class Emprestimos extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get dataHoraEfetuado => dateTime()(); 
  DateTimeColumn get dataHoraConcluido => dateTime().nullable()();
  IntColumn get idResponsavel => integer().references(Usuarios, #id)();
  IntColumn get idStatus => integer().references(EmprestimoStatus, #id)();
}