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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 10),
              Text(
                'ATIVO',
                style: TextStyle(
                  color: CoresGardien.preto,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _cardEmprestimo(CoresGardien.verdeClaro),
              const SizedBox(height: 10),
              Text(
                'O empréstimo está aberto para o usuário realizar alterações.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              Text(
                'EM OBSERVAÇÃO',
                style: TextStyle(
                  color: CoresGardien.preto,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _cardEmprestimo(CoresGardien.statusEmObservacao),
              const SizedBox(height: 10),
              Text(
                'O empréstimo possui mais de um dia aberto e requer atenção, mas ainda está aberto para o usuário realizar alterações.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              Text(
                'CONCLUÍDO',
                style: TextStyle(
                  color: CoresGardien.preto,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _cardEmprestimo(CoresGardien.statusConcluido),
              const SizedBox(height: 10),
              Text(
                'O empréstimo foi finalizado e não pode mais ser alterado, o usuário só tem disponibilidade de ler os dados.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              Text(
                'SEM CORRESPONDÊNCIA',
                style: TextStyle(
                  color: CoresGardien.preto,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _cardEmprestimo(CoresGardien.statusSemCorrespondencia),
              const SizedBox(height: 10),
              Text(
                'É quando o empréstimo foi definido como sem correspôndencia, ou seja, o empréstimo está em observação e por algum acaso não há mais como identificar quais eram os dispositivos daquele empréstimo.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              Text(
                'ERRO',
                style: TextStyle(
                  color: CoresGardien.preto,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _cardEmprestimo(CoresGardien.statusErro),
              const SizedBox(height: 10),
              Text(
                'Houve alguma falha no sistema ao identificar o status real do empréstimo.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardEmprestimo(Color corCartao) {
    return Card(
      color: corCartao,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_infoEmprestimo()],
            ),
            Center(
              child: Text(
                'Clique aqui para mais detalhes',
                style: TextStyle(
                  color: CoresGardien.branco,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoEmprestimo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '00/00/0000 - 00:00',
          style: TextStyle(
            color: CoresGardien.branco,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          'NOME DO RESPONSÁVEL',
          style: TextStyle(
            color: CoresGardien.branco,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          'CARGO\nQUANTIDADE SOLICITADA',
          style: TextStyle(color: CoresGardien.branco, fontSize: 16),
        ),
      ],
    );
  }
}
