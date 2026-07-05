import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/entities/problema.dart';
import 'package:gardien_tech/domain/repositories/problema_repository.dart';
import 'package:gardien_tech/presentation/viewmodels/problema_viewmodel.dart';
import 'package:gardien_tech/presentation/views/gerenciar_problemas_screen.dart';
import 'package:provider/provider.dart';

class DispositivoProblemaScreen extends StatefulWidget {
  final int idDispositivo;
  final String? numSerie;
  final String? numPatrimonio;

  const DispositivoProblemaScreen({
    super.key,
    required this.idDispositivo,
    this.numSerie,
    this.numPatrimonio,
  });

  @override
  State<StatefulWidget> createState() => _DispositivoProblemaScreenState();
}

class _DispositivoProblemaScreenState extends State<DispositivoProblemaScreen> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProblemaViewmodel>().carregarProblemasPorDisp(
        widget.idDispositivo,
      );
    });
  }

  void _abrirFormulario({Problema? problema}) async {
    final viewModel = context.read<ProblemaViewmodel>();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (context) =>
              ProblemaViewmodel(context.read<ProblemaRepository>()),
          child: GerenciarProblemasScreen(
            problemaId: problema?.id,
            dispositivoId: widget.idDispositivo,
            descricao: problema?.descricao,
          ),
        ),
      ),
    );
    if (!mounted) return;
    viewModel.carregarProblemasPorDisp(widget.idDispositivo);
  }

  void _confirmarExcluir(Problema problema) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir problema'),
        content: Text('Deseja excluir o problema atual?'),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF000000)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final viewmodel = context.read<ProblemaViewmodel>();
              final sucesso = await viewmodel.deletar(problema.id!);
              if (!mounted) return;
              if (sucesso) {
                viewmodel.carregarProblemasPorDisp(widget.idDispositivo);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(viewmodel.errorMessage ?? 'Erro ao excluir'),
                  ),
                );
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problemas'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            /*
            Informações do dispositivo selecionado
            */

            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF000000)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Dispositivo atual \n',
                        style: TextStyle(
                          fontWeight: FontWeight(900),
                          fontSize: 13,
                        ),
                      ),
                      TextSpan(
                        text: 'Número de série: ${widget.numSerie} \n',
                        style: TextStyle(fontSize: 13),
                      ),
                      TextSpan(
                        text: 'Número de patrimônio: ${widget.numPatrimonio}',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            /*
            Botão de relatar novo problema
            */

            ElevatedButton(
              onPressed: () => _abrirFormulario(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFe76f06),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.report_problem, size: 30),
                  SizedBox(width: 20),
                  Text('Relatar novo problema', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            /*
            Espaço dos problemas salvos
            */

            Expanded(
              child: Consumer<ProblemaViewmodel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.problemas.isEmpty) {
                    return const Center(
                      child: Text('Nenhum problema encontrado'),
                    );
                  }
                  return ListView.builder(
                    itemCount: viewModel.problemas.length,
                    itemBuilder: (context, index) {
                      final problema = viewModel.problemas[index];
                      
                      /* 
                      Card de cada problema
                      */

                      return Card(
                        key: ValueKey(problema.id),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: ListTile(
                            title: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight(900),
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(problema.descricao),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      _abrirFormulario(problema: problema),
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () => _confirmarExcluir(problema),
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
