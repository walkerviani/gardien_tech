import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/enum/tipo_cargo.dart';
import 'package:gardien_tech/presentation/viewmodels/selecionar_usuario_viewmodel.dart';
import 'package:provider/provider.dart';

class SelecionarUsuarioScreen extends StatefulWidget {
  const SelecionarUsuarioScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SelecionarUsuarioScreenState();
}

class _SelecionarUsuarioScreenState extends State<SelecionarUsuarioScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SelecionarUsuarioViewmodel>().carregarUsuarios();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _executarPesquisa() {
    final termo = _searchController.text;
    context.read<SelecionarUsuarioViewmodel>().pesquisar(termo);
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
            /*
            Campo de pesquisa de usuário
            */
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, child) {
                final possuiTexto = value.text.isNotEmpty;

                return TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Digite o nome...',
                    border: const OutlineInputBorder(),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        possuiTexto ?
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _executarPesquisa();
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: _executarPesquisa,
                          ),
                      ],
                    ),
                  ),
                  onSubmitted: (_) => _executarPesquisa(),
                );
              },
            ),
            const SizedBox(height: 12),
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
