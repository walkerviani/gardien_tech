import 'package:flutter/material.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/repositories/dispositivo_repository_impl.dart';
import 'package:gardien_tech/data/repositories/emprestimo_dispositivo_repository_iml.dart';
import 'package:gardien_tech/data/repositories/emprestimo_item_repository_impl.dart';
import 'package:gardien_tech/data/repositories/emprestimo_repository_impl.dart';
import 'package:gardien_tech/data/repositories/problema_repository_impl.dart';
import 'package:gardien_tech/data/repositories/usuario_repository_impl.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_item_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_repository.dart';
import 'package:gardien_tech/domain/repositories/problema_repository.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';
import 'package:gardien_tech/presentation/viewmodels/dispositivo_list_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/dispositivo_form_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/emprestimo_list_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/problema_form_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/usuario_form_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/dispositivo_problema_list_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/problema_list_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/usuario_list_viewmodel.dart';
import 'package:gardien_tech/presentation/views/main_screen.dart';
import 'package:provider/provider.dart';

void main() {
  final database = AppDatabase();
  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => database,
          dispose: (_, db) => db.close(),
        ),
        Provider<UsuarioRepository>(
          create: (context) =>
              UsuarioRepositoryImpl(context.read<AppDatabase>()),
        ),
        Provider<DispositivoRepository>(
          create: (context) =>
              DispositivoRepositoryImpl(context.read<AppDatabase>()),
        ),
        Provider<ProblemaRepository>(
          create: (context) =>
              ProblemaRepositoryImpl(context.read<AppDatabase>()),
        ),
        
        Provider<EmprestimoDispositivoRepository>(
          create: (context) => EmprestimoDispositivoRepositoryIml(
            context.read<AppDatabase>(),
          ),
        ),
        Provider<EmprestimoItemRepository>(
          create: (context) => EmprestimoItemRepositoryIml(
            context.read<AppDatabase>(),
            context.read<EmprestimoDispositivoRepository>(),
            context.read<DispositivoRepository>(),
          ),
        ),
        Provider<EmprestimoRepository>(
          create: (context) => EmprestimoRepositoryImpl(
            context.read<AppDatabase>(),
            context.read<EmprestimoItemRepository>(),
          ),
        ),
        ChangeNotifierProvider<UsuarioListViewmodel>(
          create: (context) =>
              UsuarioListViewmodel(context.read<UsuarioRepository>()),
        ),
        ChangeNotifierProvider<DispositivoListViewmodel>(
          create: (context) =>
              DispositivoListViewmodel(context.read<DispositivoRepository>()),
        ),
        ChangeNotifierProvider<DispositivoProblemaListViewmodel>(
          create: ((context) => DispositivoProblemaListViewmodel(
            context.read<ProblemaRepository>(),
          )),
        ),
        ChangeNotifierProvider<ProblemaListViewmodel>(
          create: ((context) =>
              ProblemaListViewmodel(context.read<ProblemaRepository>())),
        ),
        ChangeNotifierProvider<UsuarioFormViewmodel>(
          create: ((context) =>
              UsuarioFormViewmodel(context.read<UsuarioRepository>())),
        ),
        ChangeNotifierProvider<ProblemaFormViewmodel>(
          create: ((context) =>
              ProblemaFormViewmodel(context.read<ProblemaRepository>())),
        ),
        ChangeNotifierProvider<DispositivoFormViewmodel>(
          create: (context) =>
              DispositivoFormViewmodel(context.read<DispositivoRepository>()),
        ),
        ChangeNotifierProvider<EmprestimoListViewmodel>(
          create: ((context) =>
              EmprestimoListViewmodel(context.read<EmprestimoRepository>())),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Gardien Tech', home: const MainScreen());
  }
}
