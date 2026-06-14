import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'datasources/cargo_datasource.dart';
import 'datasources/usuario_datasource.dart';
import 'datasources/dispositivo_datasource.dart';
import 'datasources/problema_datasource.dart';
import 'datasources/emprestimo_datasource.dart';
import 'datasources/emprestimo_item_datasource.dart';
import 'datasources/emprestimo_dispositivos_datasource.dart';
import 'datasources/emprestimo_status_datasource.dart';
import 'datasources/tipos_dispositivo_datasource.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Cargos,
  Dispositivos,
  Emprestimos,
  EmprestimoDispositivos,
  EmprestimoItens,
  EmprestimoStatus,
  Problemas,
  TiposDispositivo,
  Usuarios
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'gardien_tech.db'));
    return NativeDatabase.createInBackground(file);
  });
}