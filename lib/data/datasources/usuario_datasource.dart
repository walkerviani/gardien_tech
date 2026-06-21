import 'package:drift/drift.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/cargo_datasource.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';

@DataClassName('UsuarioData') // Evita conflitos de nome entre classe Usuario no database.g.dart e entidade de domínio Usuario
class Usuarios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  IntColumn get idCargo => integer().references(Cargos, #id)();
}

extension UsuarioMapper on UsuarioData {
  Usuario toEntity() {
    return Usuario(
      id,
      idCargo,
      nome,
    );
  }
}

extension UsuarioCompanionMapper on Usuario {
  UsuariosCompanion toCompanion() {
    return UsuariosCompanion.insert(
      id: id != null ? Value(id!) : const Value.absent(),
      idCargo: idCargo,
      nome: nome,
    );
  }
}