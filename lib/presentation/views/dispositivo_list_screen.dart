import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/presentation/viewmodels/dispositivo_list_viewmodel.dart';
import 'package:gardien_tech/presentation/views/dispositivo_problema_list_screen.dart';
import 'package:gardien_tech/presentation/views/dispositivo_form_screen.dart';
import 'package:provider/provider.dart';

class DispositivoListScreen extends StatefulWidget {
  const DispositivoListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DispositivoListScreenState();
}

class _DispositivoListScreenState extends State<DispositivoListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DispositivoListViewmodel>().carregarDispositivos();
    });
  }

  void _abrirFormulario({Dispositivo? dispositivo}) async {
    final viewModel = context.read<DispositivoListViewmodel>();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (context) =>
              DispositivoListViewmodel(context.read<DispositivoRepository>()),
          child: DispositivoFormScreen(
            dispositivoId: dispositivo?.id,
            idTipoDispositivo: dispositivo?.idTipoDispositivo,
            numSerie: dispositivo?.numSerie,
            numPatrimonio: dispositivo?.numPatrimonio,
          ),
        ),
      ),
    );
    if (!mounted) return;
    viewModel.carregarDispositivos();
  }

  void _confirmarExcluir(Dispositivo dispositivo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Dispositivo'),
        content: Text(
          'Deseja excluir o dispositivo com número de série: "${dispositivo.numSerie}"?',
        ),
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
              final viewModel = context.read<DispositivoListViewmodel>();
              final sucesso = await viewModel.deletar(dispositivo.id!);
              if (!mounted) return;
              if (sucesso) {
                viewModel.carregarDispositivos();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(viewModel.errorMessage ?? 'Erro ao excluir'),
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
        title: const Text('Dispositivos'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /*
            Botão de criar novo dispositivo
            */
            ElevatedButton(
              onPressed: () => _abrirFormulario(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.add_to_queue, size: 30),
                  SizedBox(width: 20),
                  Text(
                    'Adicionar novo dispositivo',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              /*
              Espaço onde aparece os dispositivos criados
              */
              child: Consumer<DispositivoListViewmodel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.dispositivos.isEmpty) {
                    return const Center(
                      child: Text('Nenhum dispositivo encontrado'),
                    );
                  }
                  return ListView.builder(
                    itemCount: viewModel.dispositivos.length,
                    itemBuilder: (context, index) {
                      final dispositivo = viewModel.dispositivos[index];
                      final dispositivoTipo =
                          TipoDispositivo.values
                              .where(
                                (tipoDisp) =>
                                    tipoDisp.id ==
                                    dispositivo.idTipoDispositivo,
                              )
                              .firstOrNull
                              ?.nomeTipo ??
                          'Cargo não encontrado';

                      /*
                      Card de cada dispositivo
                      */

                      return Card(
                        key: ValueKey(dispositivo.id),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 6,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /* 
                              Parte Esquerda - número de patrimonio, número de serie e tipo dispositivo
                              */
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: <TextSpan>[
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
                                            text: '${dispositivo.numPatrimonio} \n',
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
                                            text: dispositivo.numSerie,
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
                              Parte Direita - Botões de editar, excluir e problemas
                              */
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => _abrirFormulario(
                                          dispositivo: dispositivo,
                                        ),
                                        icon: const Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            _confirmarExcluir(dispositivo),
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChangeNotifierProvider(
                                          create: (context) =>
                                              DispositivoListViewmodel(
                                                context
                                                    .read<
                                                      DispositivoRepository
                                                    >(),
                                              ),
                                          child: DispositivoProblemaListScreen(
                                            idDispositivo: dispositivo.id!,
                                            numSerie: dispositivo.numSerie,
                                            numPatrimonio:
                                                dispositivo.numPatrimonio,
                                          ),
                                        ),
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFFe76f06),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Problemas relatados'),
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
