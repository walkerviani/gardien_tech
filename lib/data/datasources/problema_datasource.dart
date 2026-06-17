import 'package:drift/drift.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/dispositivo_datasource.dart';
import 'package:gardien_tech/domain/entities/problema.dart';

@DataClassName('ProblemaData') // Evita conflitos de nome entre classe Problema no database.g.dart e entidade de domínio Problema
class Problemas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idDispositivo => integer().references(Dispositivos, #id)();
  TextColumn get descricao => text()();
}

extension ProblemaMapper on ProblemaData {
  Problema toEntity() {
    return Problema(
      id,
      idDispositivo,
      descricao,
    );
  }
}

extension ProblemaCompanionMapper on Problema {
  ProblemasCompanion toCompanion() {
    return ProblemasCompanion.insert(
      idDispositivo: idDispositivo,
      descricao: descricao,
    );
  }
}