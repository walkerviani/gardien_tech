import 'package:flutter/material.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';

class AjudaCardScreen extends StatelessWidget {
  const AjudaCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cor do cartão'),
        backgroundColor: CoresGardien.azulClaro,
        foregroundColor: CoresGardien.branco,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'O que significa cada cor dos cartões dos empréstimos?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Cada cor representa um status do empréstimo:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 5),
            Text(
              'ATIVO',
              style: TextStyle(
                color: CoresGardien.statusAtivo,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'O empréstimo está aberto para o usuário realizar alterações.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 5),
            Text(
              'EM OBSERVAÇÃO',
              style: TextStyle(
                color: CoresGardien.statusEmObservacao,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'O empréstimo possui mais de um dia aberto e requer atenção, mas ainda está aberto para o usuário realizar alterações.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 5),
            Text(
              'CONCLUÍDO',
              style: TextStyle(
                color: CoresGardien.statusConcluido,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'O empréstimo foi finalizado e não pode mais ser alterado, o usuário só tem disponibilidade de ler os dados.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 5),
            Text(
              'SEM CORRESPONDÊNCIA',
              style: TextStyle(
                color: CoresGardien.statusSemCorrespondencia,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'É quando o empréstimo foi definido como sem correspôndencia, ou seja, o empréstimo está em observação e por algum acaso não há mais como identificar quais eram os dispositivos daquele empréstimo.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 5),
            Text(
              'ERRO',
              style: TextStyle(
                color: CoresGardien.statusErro,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Houve alguma falha no sistema ao identificar o status real do empréstimo.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
