import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:gardien_tech/presentation/viewmodels/selecionar_dispositivo_viewmodel.dart';
import 'package:provider/provider.dart';

class SelecionarDispositivoScreen extends StatefulWidget {
  final int? idtipoDispositivo;
  final int idEmprestimo;

  const SelecionarDispositivoScreen(
    this.idtipoDispositivo,
    this.idEmprestimo, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SelecionarDispositivoScreenState();
}

class _SelecionarDispositivoScreenState
    extends State<SelecionarDispositivoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SelecionarDispositivoViewmodel>().carregarDispositivos(
        widget.idtipoDispositivo,
      );
    });
  }

  IconData _selecionarIcone(int tipoDispositivo) {
    switch (tipoDispositivo) {
      case 1:
        return Icons.laptop;
      case 2:
        return Icons.tablet_android;
      case 3:
        return Icons.smartphone;
      case 4:
        return Icons.mouse;
      case 5:
        return Icons.keyboard;
      case 6:
        return Icons.monitor;
      case 7:
        return Icons.videocam;
      case 8:
        return Icons.camera;
      case 9:
        return Icons.headset;
      case 10:
        return Icons.cable;
      case 11:
        return Icons.usb;
      case 12:
        return Icons.router;
      case 13:
        return Icons.router;
      case 14:
        return Icons.print_rounded;
      case 15:
        return Icons.surround_sound;
      default:
        return Icons.question_mark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione o dispositivo'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Consumer<SelecionarDispositivoViewmodel>(
                builder: (context, viewmodel, child) {
                  if (viewmodel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewmodel.dispositivos.isEmpty) {
                    return Center(
                      child: const Text(
                        'Nenhum dispositivo encontrado',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: viewmodel.dispositivos.length,
                    itemBuilder: (context, index) {
                      final dispositivo = viewmodel.dispositivos[index];
                      final idTipo = dispositivo.idTipoDispositivo;
                      final tipoDispositivoStr =
                          TipoDispositivo.values
                              .where((tipo) => tipo.id == idTipo)
                              .firstOrNull
                              ?.nomeTipo ??
                          'Tipo não encontrado';

                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: ListTile(
                            leading: Icon(_selecionarIcone(idTipo)),
                            title: Text(
                              'Patrimônio N° ${dispositivo.numPatrimonio}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '$tipoDispositivoStr\nN° Serial: ${dispositivo.numSerie}',
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                Navigator.pop(context, {
                                  'idDispositivo': dispositivo.id,
                                  'numPatrimonio': dispositivo.numPatrimonio,
                                  'tipo': dispositivo.idTipoDispositivo,
                                });
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    5,
                                  ),
                                ),
                              ),
                              icon: Icon(Icons.add, color: Colors.white),
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
