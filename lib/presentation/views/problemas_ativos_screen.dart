import 'package:flutter/material.dart';
import 'package:gardien_tech/data/dto/dispositivo_com_problema_dto.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:gardien_tech/domain/repositories/problema_repository.dart';
import 'package:gardien_tech/presentation/viewmodels/problemas_ativos_viewmodel.dart';
import 'package:gardien_tech/presentation/views/gerenciar_problemas_screen.dart';
import 'package:provider/provider.dart';

class ProblemasAtivosScreen extends StatefulWidget {
  const ProblemasAtivosScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProblemasAtivosScreenState();
}

class _ProblemasAtivosScreenState extends State<ProblemasAtivosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProblemasAtivosViewmodel>().carregarDispositivosComProblemas();
    });
  }

  void _abrirFormulario({required DispositivoComProblemaDto problema}) async {
    final viewModel = context.read<ProblemasAtivosViewmodel>();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (context) =>
              ProblemasAtivosViewmodel(context.read<ProblemaRepository>()),
          child: GerenciarProblemasScreen(
            problemaId: problema.idProblema,
            dispositivoId: problema.idDispositivo,
            descricao: problema.descricao,
          ),
        ),
      ),
    );
    if (!mounted) return;
    viewModel.carregarDispositivosComProblemas();
  }

  void _confirmarExcluir(DispositivoComProblemaDto problema) {
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
              final viewmodel = context.read<ProblemasAtivosViewmodel>();
              final sucesso = await viewmodel.deletar(problema.idProblema);
              if (!mounted) return;
              if (sucesso) {
                viewmodel.carregarDispositivosComProblemas();
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
        title: const Text('Problemas ativos'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            /*
            Informações do dispositivo selecionado
            */
            Consumer<ProblemasAtivosViewmodel>(
              builder: (context, viewModel, child) {
                if (viewModel.problemasAtivos.isEmpty) {
                  // Se a lista estiver vazia não apresente as informações
                  return SizedBox.shrink();
                }

                return Container(
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
                            text:
                                'Problemas atuais: ${viewModel.problemasAtivos.length} \n',
                            style: TextStyle(fontSize: 13),
                          ),
                          TextSpan(
                            text:
                                'Dispositivos com problema: ${viewModel.quantidadeTotalDisponiveisComProblemas()}',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            Expanded(
              child: Consumer<ProblemasAtivosViewmodel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.problemasAtivos.isEmpty) {
                    return const Center(
                      child: Text('Nenhum problema encontrado'),
                    );
                  }
                  return ListView.builder(
                    itemCount: viewModel.problemasAtivos.length,
                    itemBuilder: (context, index) {
                      final problemasAtivos = viewModel.problemasAtivos[index];
                      final dispositivoTipo =
                          TipoDispositivo.values
                              .where(
                                (tipoDisp) =>
                                    tipoDisp.id ==
                                    problemasAtivos.idTipoDispositivo,
                              )
                              .firstOrNull
                              ?.nomeTipo ??
                          'Cargo não encontrado';
                      /* 
                      Card de cada problema
                      */

                      return Card(
                        key: ValueKey(problemasAtivos.idProblema),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /* 
                              Parte Esquerda - Info
                              */
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '${index + 1} \n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '$dispositivoTipo \n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'PATRIMÔNIO \n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${problemasAtivos.numPatrimonio} \n',
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          TextSpan(
                                            text: 'NÚMERO DE SÉRIE \n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${problemasAtivos.numSerie} \n',
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          TextSpan(
                                            text: 'DESCRIÇÃO \n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          TextSpan(
                                            text: problemasAtivos.descricao,
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),

                              /* 
                              Parte Direita - Botões de editar e excluir
                              */
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => _abrirFormulario(
                                          problema: problemasAtivos,
                                        ),
                                        icon: const Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            _confirmarExcluir(problemasAtivos),
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
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
