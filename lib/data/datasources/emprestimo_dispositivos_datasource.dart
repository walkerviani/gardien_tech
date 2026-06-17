import 'package:drift/drift.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/dispositivo_datasource.dart';
import 'package:gardien_tech/data/datasources/emprestimo_item_datasource.dart';
import 'package:gardien_tech/domain/entities/emprestimo_dispositivo.dart';

@DataClassName('EmprestimoDispositivoData') // Evita conflitos de nome entre classe EmprestimoDispositivo no database.g.dart e entidade de domínio EmprestimoDispositivo
class EmprestimoDispositivos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idEmprestimoItem => integer().references(EmprestimoItens, #id)();
  IntColumn get idDispositivo => integer().references(Dispositivos, #id).nullable()();
}

extension EmprestimoDispositivoMapper on EmprestimoDispositivoData {
  EmprestimoDispositivo toEntity() {
    return EmprestimoDispositivo(
      id,
      idEmprestimoItem,
      idDispositivo: idDispositivo,
    );
  }
}

extension EmprestimoDispositivoCompanionMapper on EmprestimoDispositivo {
  EmprestimoDispositivosCompanion toCompanion() {
    return EmprestimoDispositivosCompanion.insert(
      idEmprestimoItem: idEmprestimoItem,
      idDispositivo: Value(idDispositivo),
    );
  }
}