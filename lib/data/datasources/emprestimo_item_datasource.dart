import 'package:drift/drift.dart';
import 'package:gardien_tech/data/datasources/emprestimo_datasource.dart';
import 'package:gardien_tech/data/datasources/tipos_dispositivo_datasource.dart';

@DataClassName('EmprestimoItemData') // Evita conflitos de nome entre classe EmprestimoItem no database.g.dart e entidade de domínio EmprestimoItem
class EmprestimoItens extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idEmprestimo => integer().references(Emprestimos, #id)();
  IntColumn get idTipoDispositivo => integer().references(TiposDispositivo, #id)();
  IntColumn get qtdSolicitada => integer()();
  IntColumn get qtdDevolvida => integer()();
  BoolColumn get estaResolvido => boolean()();
}