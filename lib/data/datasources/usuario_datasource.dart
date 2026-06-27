import 'package:drift/drift.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';

@DataClassName('UsuarioData') // Evita conflitos de nome entre classe Usuario no database.g.dart e entidade de domínio Usuario
class Usuarios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  IntColumn get idTipoCargo => integer()();
}

extension UsuarioMapper on UsuarioData {
  Usuario toEntity() {
    return Usuario(
      id,
      idTipoCargo,
      nome,
    );
  }
}

extension UsuarioCompanionMapper on Usuario {
  UsuariosCompanion toCompanion() {
    return UsuariosCompanion.insert(
      id: id != null ? Value(id!) : const Value.absent(),
      idTipoCargo: idTipoCargo,
      nome: nome,
    );
  }
}