import 'package:flutter/material.dart';
import 'package:gardien_tech/presentation/views/emprestimo_form_screen.dart';
import 'package:gardien_tech/presentation/views/emprestimo_list_screen.dart';
import 'package:gardien_tech/presentation/views/funcoes_screen.dart';

enum Aba { home, adicionar, funcoes}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Aba _abaAtual = Aba.home;

  Key _listKey = UniqueKey();

  Widget _buildTela() {
    return switch (_abaAtual) {
      Aba.home => EmprestimoListScreen(key: _listKey),
      Aba.funcoes => const FuncoesScreen(),
      _ => EmprestimoListScreen(key: _listKey),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gardien Tech',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
      ),
      body: _buildTela(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _abaAtual == Aba.adicionar ? 0 : Aba.values.indexOf(_abaAtual),
        onTap: (index) {
          final aba = Aba.values[index];
          if (aba == Aba.adicionar) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmprestimoFormScreen(),
              ),
            ).then((_) {
              setState(() {
                _abaAtual = Aba.home;
                _listKey = UniqueKey();
              });
            });
            return;
          }
          setState(() => _abaAtual = aba);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Página inicial'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Adicionar'),
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Funções'),
        ],
        selectedItemColor: Colors.white,
        backgroundColor: const Color(0xFF2196F3),
        unselectedItemColor: Colors.white,
      ),
    );
  }
}