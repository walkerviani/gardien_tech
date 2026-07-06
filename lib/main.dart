import 'package:flutter/material.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/repositories/dispositivo_repository_impl.dart';
import 'package:gardien_tech/data/repositories/problema_repository_impl.dart';
import 'package:gardien_tech/data/repositories/usuario_repository_impl.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/problema_repository.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';
import 'package:gardien_tech/presentation/viewmodels/dispositivo_list_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/dispositivo_form_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/gerenciar_problemas_viewmodel.dart';
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
        ChangeNotifierProvider<UsuarioListViewmodel>(
          create: (context) =>
              UsuarioListViewmodel(context.read<UsuarioRepository>()),
        ),
        ChangeNotifierProvider<DispositivoListViewmodel>(
          create: (context) =>
              DispositivoListViewmodel(context.read<DispositivoRepository>()),
        ),
        ChangeNotifierProvider<DispositivoProblemaListViewmodel>(
          create: ((context) =>
              DispositivoProblemaListViewmodel(context.read<ProblemaRepository>())),
        ),
        ChangeNotifierProvider<ProblemaListViewmodel>(
          create: ((context) =>
              ProblemaListViewmodel(context.read<ProblemaRepository>())),
        ),
        ChangeNotifierProvider<UsuarioFormViewmodel>(
          create: ((context) =>
              UsuarioFormViewmodel(context.read<UsuarioRepository>())),
        ),
        ChangeNotifierProvider<GerenciarProblemasViewmodel>(
          create: ((context) =>
              GerenciarProblemasViewmodel(context.read<ProblemaRepository>())),
        ),
        ChangeNotifierProvider<DispositivoFormViewmodel>(
          create: (context) =>
              DispositivoFormViewmodel(context.read<DispositivoRepository>()),
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
