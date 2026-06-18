import 'package:flutter/material.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/repositories/cargo_repository_impl.dart';
import 'package:gardien_tech/domain/repositories/cargo_repository.dart';
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
        Provider<CargoRepository>(
          create: (context) => CargoRepositoryImpl(context.read<AppDatabase>()),
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
