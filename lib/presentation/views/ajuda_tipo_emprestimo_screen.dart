import 'package:flutter/material.dart';

class AjudaTipoEmprestimoScreen extends StatelessWidget {
  const AjudaTipoEmprestimoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipo de empréstimo'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Padding(
          padding: EdgeInsets.only(bottom: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Quais são os tipos de criação dos empréstimos e o que cada um deles quer dizer?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 5),
              Text(
                'Os empréstimos são criados através de dois métodos:',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              Text(
                'POR QUANTIDADE',
                style: TextStyle(
                  color: const Color(0xFF2196F3),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'O usuário informa o tipo de dispositivo e a quantidade que será emprestada no momento de criação (podendo registrar mais de um tipo de dispositivo por empréstimo).'
                'No momento de finalizar o empréstimo, o usuário precisará vincular cada um dos dispositivos que estavam naquele empréstimo.\n'
                '(Será criado um cartão para cada um dos dispositivos selecionados na criação, porém é possível adicionar mais dispositivos depois de criado o empréstimo)',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 5),
              Text(
                "O método 'Por Quantidade' é ideal para momentos em que o usuário não tem muito tempo e há muitos dispositivos a serem anotados, ao invés de anotar tudo naquele momento, ele deixa para anotar no final do empréstimo.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              Text(
                'POR UNIDADE',
                style: TextStyle(
                  color: const Color(0xFF2196F3),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'O usuário no momento de criação do empréstimo já informa quais são os dispositivos presente no empréstimo.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 5),
              Text(
                "O método 'Por Unidade' é ideal para momentos em que o usuário está livre para anotar todos os dispositivos no momento ou o empréstimo é composto de poucos dispositivos.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              Text(
                "Observação: Apesar de houver dois métodos de criação, o método 'Por Unidade' é o mais recomendado por possuir mais vericidade nos dados.",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              Text(
                "O método 'Por Quantidade' foi criado com o objetivo de ajudar o usuário em casos de empréstimos grandes que podem acabar tomando muito tempo para serem criados.",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
