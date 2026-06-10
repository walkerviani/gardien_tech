import 'package:flutter/material.dart';
import 'package:gardien_tech/presentation/views/funcoes_screen.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});
  
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  int _indice = 0;

  final List<Widget> _telas = [
    const Center(child: Text('Página Inicial')),
    const Center(child: Text('Adicionar')),
    const FuncoesScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gardien Tech'),
        backgroundColor: const Color(0xFF2196F3), 
        foregroundColor: Colors.white,
      ),
      body: _telas[_indice],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        onTap: (index){
          setState(() {
            _indice = index;
          });
        },
        items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Página Inicial'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Adicionar'),
        BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Funções')
      ], 
      selectedItemColor: const Color(0xFF2196F3),
      unselectedItemColor: Colors.black,
      ),
    );
  }
}