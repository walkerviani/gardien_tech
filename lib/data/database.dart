import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'datasources/usuario_datasource.dart';
import 'datasources/dispositivo_datasource.dart';
import 'datasources/problema_datasource.dart';
import 'datasources/emprestimo_datasource.dart';
import 'datasources/emprestimo_item_datasource.dart';
import 'datasources/emprestimo_dispositivos_datasource.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Dispositivos,
    Emprestimos,
    EmprestimoDispositivos,
    EmprestimoItens,
    Problemas,
    Usuarios,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Lógica de migração caso existam dados prévios
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
      await customStatement('PRAGMA journal_mode = WAL;');
      
      // Índices para otimização de query
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_emp_disp_item ON emprestimo_dispositivos(id_emprestimo_item);',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_emp_item_emprestimo ON emprestimo_itens(id_emprestimo);',
      );
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'gardien_tech.db'));
    return NativeDatabase.createInBackground(file);
  });
}