import 'package:drift/drift.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/usuario_datasource.dart';
import 'package:gardien_tech/domain/entities/emprestimo.dart';

@DataClassName('EmprestimoData') // Evita conflitos de nome entre classe Emprestimo no database.g.dart e entidade de domínio Emprestimo
class Emprestimos extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get dataHoraEfetuado => dateTime()(); 
  DateTimeColumn get dataHoraConcluido => dateTime().nullable()();
  IntColumn get idResponsavel => integer().references(Usuarios, #id)();
  IntColumn get idStatus => integer()();
}

extension EmprestimoMapper on EmprestimoData {
  Emprestimo toEntity() {
    return Emprestimo(
      id,
      idResponsavel,
      dataHoraEfetuado: dataHoraEfetuado,
      dataHoraConcluido: dataHoraConcluido,
      idStatus: idStatus,
    );
  }
}

extension EmprestimoCompanionMapper on Emprestimo {
  EmprestimosCompanion toCompanion() {
    return EmprestimosCompanion.insert(
      dataHoraEfetuado: dataHoraEfetuado,
      dataHoraConcluido: Value(dataHoraConcluido),
      idResponsavel: idResponsavel,
      idStatus: idStatus,
    );
  }
}