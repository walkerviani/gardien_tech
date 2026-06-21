import 'package:drift/drift.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/emprestimo_datasource.dart';
import 'package:gardien_tech/domain/entities/emprestimo_item.dart';

@DataClassName('EmprestimoItemData') // Evita conflitos de nome entre classe EmprestimoItem no database.g.dart e entidade de domínio EmprestimoItem
class EmprestimoItens extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idEmprestimo => integer().references(Emprestimos, #id)();
  IntColumn get idTipoDispositivo => integer()();
  IntColumn get qtdSolicitada => integer()();
  IntColumn get qtdDevolvida => integer()();
  BoolColumn get estaResolvido => boolean()();
  BoolColumn get ehQuantitativo => boolean()();
}

extension EmprestimoItemMapper on EmprestimoItemData {
  EmprestimoItem toEntity() {
    return EmprestimoItem(
      id,
      idEmprestimo,
      idTipoDispositivo,
      qtdSolicitada,
      ehQuantitativo,
      qtdDevolvida: qtdDevolvida,
      estaResolvido: estaResolvido,
    );
  }
}

extension EmprestimoItemCompanionMapper on EmprestimoItem {
  EmprestimoItensCompanion toCompanion() {
    return EmprestimoItensCompanion.insert(
      id: id != null ? Value(id!) : const Value.absent(),
      idEmprestimo: idEmprestimo,
      idTipoDispositivo: idTipoDispositivo,
      qtdSolicitada: qtdSolicitada,
      qtdDevolvida: qtdDevolvida,
      estaResolvido: estaResolvido,
      ehQuantitativo: ehQuantitativo,
    );
  }
}