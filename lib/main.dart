import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gardien_tech/data/database.dart';

import 'package:gardien_tech/data/repositories/dispositivo_repository_impl.dart';
import 'package:gardien_tech/data/repositories/emprestimo_dispositivo_repository_impl.dart';
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

import 'package:gardien_tech/presentation/viewmodels/dispositivo_form_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/dispositivo_list_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/dispositivo_problema_list_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/problema_form_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/problema_list_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/usuario_form_viewmodel.dart';
import 'package:gardien_tech/presentation/viewmodels/usuario_list_viewmodel.dart';

import 'package:gardien_tech/presentation/views/main_screen.dart';


void main() {
  final database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [

        // ==========================
        // DATABASE
        // ==========================

        Provider<AppDatabase>(
          create: (_) => database,
          dispose: (_, db) => db.close(),
        ),


        // ==========================
        // REPOSITÓRIOS BÁSICOS
        // ==========================

        Provider<UsuarioRepository>(
          create: (context) =>
              UsuarioRepositoryImpl(
                context.read<AppDatabase>(),
              ),
        ),

        Provider<DispositivoRepository>(
          create: (context) =>
              DispositivoRepositoryImpl(
                context.read<AppDatabase>(),
              ),
        ),

        Provider<ProblemaRepository>(
          create: (context) =>
              ProblemaRepositoryImpl(
                context.read<AppDatabase>(),
              ),
        ),


        // ==========================
        // REPOSITÓRIOS DE EMPRÉSTIMO
        // ORDEM IMPORTANTE
        // ==========================


        // 1º
        Provider<EmprestimoDispositivoRepository>(
          create: (context) =>
              EmprestimoDispositivoRepositoryImpl(
                context.read<AppDatabase>(),
              ),
        ),


        // 2º depende de:
        // EmprestimoDispositivoRepository
        // DispositivoRepository

        Provider<EmprestimoItemRepository>(
          create: (context) =>
              EmprestimoItemRepositoryImpl(
                context.read<AppDatabase>(),
                context.read<EmprestimoDispositivoRepository>(),
                context.read<DispositivoRepository>(),
              ),
        ),


        // 3º depende de:
        // EmprestimoItemRepository

        Provider<EmprestimoRepository>(
          create: (context) =>
              EmprestimoRepositoryImpl(
                context.read<AppDatabase>(),
                context.read<EmprestimoItemRepository>(),
              ),
        ),



        // ==========================
        // VIEWMODELS
        // ==========================


        ChangeNotifierProvider<UsuarioListViewmodel>(
          create: (context) =>
              UsuarioListViewmodel(
                context.read<UsuarioRepository>(),
              ),
        ),


        ChangeNotifierProvider<DispositivoListViewmodel>(
          create: (context) =>
              DispositivoListViewmodel(
                context.read<DispositivoRepository>(),
              ),
        ),


        ChangeNotifierProvider<ProblemaListViewmodel>(
          create: (context) =>
              ProblemaListViewmodel(
                context.read<ProblemaRepository>(),
              ),
        ),


        ChangeNotifierProvider<DispositivoProblemaListViewmodel>(
          create: (context) =>
              DispositivoProblemaListViewmodel(
                context.read<ProblemaRepository>(),
              ),
        ),


        ChangeNotifierProvider<UsuarioFormViewmodel>(
          create: (context) =>
              UsuarioFormViewmodel(
                context.read<UsuarioRepository>(),
              ),
        ),


        ChangeNotifierProvider<ProblemaFormViewmodel>(
          create: (context) =>
              ProblemaFormViewmodel(
                context.read<ProblemaRepository>(),
              ),
        ),


        ChangeNotifierProvider<DispositivoFormViewmodel>(
          create: (context) =>
              DispositivoFormViewmodel(
                context.read<DispositivoRepository>(),
              ),
        ),

      ],

      child: const MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Gardien Tech',
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );

  }
}