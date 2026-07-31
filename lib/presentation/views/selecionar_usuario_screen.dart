import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gardien_tech/domain/enum/tipo_cargo.dart';
import 'package:gardien_tech/presentation/viewmodels/selecionar_usuario_viewmodel.dart';
import 'package:provider/provider.dart';

class SelecionarUsuarioScreen extends StatefulWidget {
  const SelecionarUsuarioScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SelecionarUsuarioScreenState();
}

class _SelecionarUsuarioScreenState extends State<SelecionarUsuarioScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SelecionarUsuarioViewmodel>().carregarUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione o usuário'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Consumer<SelecionarUsuarioViewmodel>(
                builder: (context, viewmodel, child) {
                  if (viewmodel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewmodel.usuarios.isEmpty) {
                    return Center(
                      child: const Text(
                        'Nenhum usuário encontrado',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: viewmodel.usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = viewmodel.usuarios[index];
                      final idCargo = usuario.idTipoCargo;
                      final cargoStr =
                          TipoCargo.values
                              .where((tipo) => tipo.id == idCargo)
                              .firstOrNull
                              ?.nomeCargo ??
                          'Cargo não encontrado';

                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text(
                              usuario.nome,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(cargoStr),
                            trailing: IconButton(
                              onPressed: () {
                                Navigator.pop(context, usuario);
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
