import 'package:flutter/material.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/repositories/usuario_repository_impl.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';
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
        ChangeNotifierProvider<UsuarioViewmodel>(
          create: (context) =>
              UsuarioViewmodel(context.read<UsuarioRepository>()),
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
