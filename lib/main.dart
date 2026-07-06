import 'package:flutter/material.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/repositories/dispositivo_repository_impl.dart';
import 'package:gardien_tech/data/repositories/problema_repository_impl.dart';
import 'package:gardien_tech/data/repositories/usuario_repository_impl.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/problema_repository.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';
import 'package:gardien_tech/presentation/viewmodels/dispositivo_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/problema_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/problemas_ativos_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/usuario_viewmodel.dart';
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
        ChangeNotifierProvider<UsuarioViewmodel>(
          create: (context) =>
              UsuarioViewmodel(context.read<UsuarioRepository>()),
        ),
        ChangeNotifierProvider<DispositivoViewmodel>(
          create: (context) =>
              DispositivoViewmodel(context.read<DispositivoRepository>()),
        ),
        ChangeNotifierProvider<ProblemaViewmodel>(
          create: ((context) =>
              ProblemaViewmodel(context.read<ProblemaRepository>())),
        ),
        ChangeNotifierProvider<ProblemasAtivosViewmodel>(
          create: ((context) =>
              ProblemasAtivosViewmodel(context.read<ProblemaRepository>())),
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
