import 'package:flutter/material.dart';
import 'package:gardien_tech/data/dto/dispositivo_com_problema_dto.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:gardien_tech/domain/repositories/problema_repository.dart';
import 'package:gardien_tech/presentation/viewmodels/problema_list_viewmodel.dart';
import 'package:gardien_tech/presentation/views/problema_form_screen.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';
import 'package:provider/provider.dart';

class ProblemaListScreen extends StatefulWidget {
  const ProblemaListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProblemaListScreenState();
}

class _ProblemaListScreenState extends State<ProblemaListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProblemaListViewmodel>().carregarDispositivosComProblemas();
    });
  }

  void _abrirFormulario({required DispositivoComProblemaDTO problema}) async {
    final viewModel = context.read<ProblemaListViewmodel>();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (context) =>
              ProblemaListViewmodel(context.read<ProblemaRepository>()),
          child: ProblemaFormScreen(
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

  void _confirmarExcluir(DispositivoComProblemaDTO problema) {
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
              style: TextStyle(color: CoresGardien.preto),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final viewmodel = context.read<ProblemaListViewmodel>();
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
            child: const Text(
              'Excluir',
              style: TextStyle(color: CoresGardien.vermelhoClaro),
            ),
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
        backgroundColor: CoresGardien.azulClaro,
        foregroundColor: CoresGardien.branco,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            // Informações do dispositivo selecionado
            Consumer<ProblemaListViewmodel>(
              builder: (context, viewmodel, child) {
                if (viewmodel.problemasAtivos.isEmpty) {
                  // Se a lista estiver vazia não apresente as informações
                  return SizedBox.shrink();
                }
                return _cabecalho(viewmodel);
              },
            ),
            const SizedBox(height: 10),

            Expanded(
              child: Consumer<ProblemaListViewmodel>(
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
                      return _cardProblema(problemasAtivos, index);
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

  Widget _cabecalho(ProblemaListViewmodel viewmodel) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: CoresGardien.preto),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text:
                    'Problemas atuais: ${viewmodel.problemasAtivos.length} \n',
                style: TextStyle(fontSize: 15),
              ),
              TextSpan(
                text:
                    'Dispositivos com problema: ${viewmodel.quantidadeTotalDisponiveisComProblemas()}',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardProblema(DispositivoComProblemaDTO problema, int index) {
    return Tooltip(
      preferBelow: false,
      message: problema.descricao,
      textStyle: TextStyle(fontSize: 18),
      textAlign: TextAlign.center,
      verticalOffset: 100,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: CoresGardien.azulEscuro,
        borderRadius: BorderRadius.circular(5),
      ),
      showDuration: const Duration(milliseconds: 3),
      child: Card(
        key: ValueKey(problema.idProblema),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  _infoProblema(problema, index),
                  const SizedBox(width: 20),
                  _botoesProblema(problema),
                ],
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  'Clique e segure para ler a descrição',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoProblema(DispositivoComProblemaDTO problema, int index) {
    final dispositivoTipo =
        TipoDispositivo.values
            .where((tipoDisp) => tipoDisp.id == problema.idTipoDispositivo)
            .firstOrNull
            ?.nomeTipo ??
        'Cargo não encontrado';

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '${index + 1} - $dispositivoTipo\n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextSpan(
                  text: 'N° PATRIMÔNIO \n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                TextSpan(
                  text: '${problema.numPatrimonio} \n',
                  style: TextStyle(fontSize: 15),
                ),
                TextSpan(
                  text: 'N° SÉRIE \n',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                TextSpan(
                  text: problema.numSerie,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _botoesProblema(DispositivoComProblemaDTO problema) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _abrirFormulario(problema: problema),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => _confirmarExcluir(problema),
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ],
    );
  }
}
