import 'package:flutter/material.dart';
import 'package:gardien_tech/presentation/views/emprestimo_form_screen.dart';
import 'package:gardien_tech/presentation/views/funcoes_screen.dart';

enum Aba { home, adicionar, funcoes}

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});
  
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  Aba _abaAtual = Aba.home;

  final Map<Aba, Widget> _telas = {
    Aba.home: Center(child: Text('Página Inicial')),
    Aba.funcoes: const FuncoesScreen(),
  };
  
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
      body: _telas[_abaAtual]!,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: Aba.values.indexOf(_abaAtual),
        onTap: (index){
          final aba = Aba.values[index];

          if(aba == Aba.adicionar) {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmprestimoFormScreen()),
            );
            return;
          }
          setState(() => _abaAtual = aba);
        },
        items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Página inicial'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Adicionar'),
        BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Funções')
      ], 
      selectedItemColor: Colors.white,
      backgroundColor: const Color(0xFF2196F3),
      unselectedItemColor: Colors.white,
      ),
    );
  }
}