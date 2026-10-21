import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/entities/emprestimo.dart';
import 'package:gardien_tech/domain/enum/emprestimo_status.dart';
import 'package:gardien_tech/presentation/viewmodels/historico_dispositivo_viewmodel.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoricoDispositivoScreen extends StatefulWidget {
  final int idDispositivo;
  final String? numSerie;
  final String? numPatrimonio;

  const HistoricoDispositivoScreen(
    this.idDispositivo, {
    super.key,
    this.numSerie,
    this.numPatrimonio,
  });

  @override
  State<StatefulWidget> createState() => _HistoricoDispositivoScreenState();
}

class _HistoricoDispositivoScreenState extends State<HistoricoDispositivoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoricoDispositivoViewmodel>().carregarHistorico(
        widget.idDispositivo,
      );
    });
  }

  String _formatarData(DateTime data) =>
      DateFormat('dd/MM/yyyy - HH:mm').format(data);

  // Procura no enum EmprestimoStatus o status cujo id corresponde ao recebido.
  // Retorna o nomeStatus; se não encontrar, retorna STATUS DESCONHECIDO
  String _nomeStatus(int idStatus) {
    return EmprestimoStatus.values
    .where((status) => status.id == idStatus)
    .firstOrNull ?.nomeStatus ?? 'STATUS DESCONHECIDO';
  }

  // Procura o nome do usuário a partir do id do responsável
  String _nomeUsuario(int idResponsavel) {
    return context.read<HistoricoDispositivoViewmodel>().nomeUsuario(
      idResponsavel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico do dispositivo'),
        backgroundColor: CoresGardien.azulClaro,
        foregroundColor: CoresGardien.branco,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _infoDispositivo(),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<HistoricoDispositivoViewmodel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            viewModel.errorMessage!,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () => viewModel.carregarHistorico(
                              widget.idDispositivo,
                            ),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (viewModel.emprestimos.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum empréstimo encontrado para este dispositivo',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Empréstimos (${viewModel.emprestimos.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: viewModel.emprestimos.length,
                          itemBuilder: (context, index) => _cardEmprestimo(
                            viewModel.emprestimos[index],
                            index,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoDispositivo() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: CoresGardien.preto),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dispositivo selecionado:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          if (widget.numPatrimonio != null)Text('Nº Patrimônio: ${widget.numPatrimonio}'),
          if (widget.numSerie != null) Text('Nº Série: ${widget.numSerie}'),
        ],
      ),
    );
  }

  Widget _cardEmprestimo(Emprestimo emprestimo, int index) {
    return Card(
      //color: Color.fromARGB(166, 64, 64, 64),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Empréstimo Nº${emprestimo.id ?? index + 1}',
              style: const TextStyle(
                color: CoresGardien.preto,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Status: ${_nomeStatus(emprestimo.idStatus)}',
              style: const TextStyle(color: CoresGardien.preto),
            ),
            
            Text(
              'Requisitado: ${_formatarData(emprestimo.dataHoraEfetuado)}',
              style: const TextStyle(color: CoresGardien.preto),
            ),
            if (emprestimo.dataHoraConcluido != null)
              Text(
                'Concluído: ${_formatarData(emprestimo.dataHoraConcluido!)}',
                style: const TextStyle(color: CoresGardien.preto),
              ),
            Text(
              'Responsável: ${_nomeUsuario(emprestimo.idResponsavel)}',
              style: const TextStyle(color: CoresGardien.preto),
            ),
          ],
        ),
      ),
    );
  }
}
