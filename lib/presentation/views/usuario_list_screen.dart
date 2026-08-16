import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';
import 'package:gardien_tech/domain/enum/tipo_cargo.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';
import 'package:gardien_tech/presentation/viewmodels/usuario_list_viewmodel.dart';
import 'package:gardien_tech/presentation/views/usuario_form_screen.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';
import 'package:provider/provider.dart';

class UsuarioListScreen extends StatefulWidget {
  const UsuarioListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UsuarioListScreenState();
}

class _UsuarioListScreenState extends State<UsuarioListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsuarioListViewmodel>().carregarUsuarios();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _executarPesquisa() {
    final termo = _searchController.text;
    context.read<UsuarioListViewmodel>().pesquisar(termo);
  }

  void _abrirFormulario({Usuario? usuario}) async {
    final viewModel = context.read<UsuarioListViewmodel>();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (context) =>
              UsuarioListViewmodel(context.read<UsuarioRepository>()),
          child: UsuarioFormScreen(
            usuarioId: usuario?.id,
            usuarioidTipoCargo: usuario?.idTipoCargo,
            usuarioNome: usuario?.nome,
          ),
        ),
      ),
    );
    if (!mounted) return;
    viewModel.carregarUsuarios();
  }

  void _confirmarExcluir(Usuario usuario) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Usuário'),
        content: Text('Deseja excluir o usuário "${usuario.nome}"?'),
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
              final viewModel = context.read<UsuarioListViewmodel>();
              final sucesso = await viewModel.deletar(usuario.id!);
              if (!mounted) return;
              if (sucesso) {
                viewModel.carregarUsuarios();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(viewModel.errorMessage ?? 'Erro ao excluir'),
                    backgroundColor: CoresGardien.vermelhoClaro,
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
        title: const Text('Usuários'),
        backgroundColor: CoresGardien.azulClaro,
        foregroundColor: CoresGardien.branco,
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _abrirFormulario(),
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresGardien.verdeClaro,
                foregroundColor: CoresGardien.branco,
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.person_add, size: 30),
                  SizedBox(width: 20),
                  Text(
                    'Adicionar novo usuário',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
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
                        possuiTexto
                            ? IconButton(
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
              child: Consumer<UsuarioListViewmodel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (viewModel.usuarios.isEmpty) {
                    return const Center(
                      child: Text('Nenhum usuário encontrado'),
                    );
                  }
                  return ListView.builder(
                    itemCount: viewModel.usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = viewModel.usuarios[index];
                      final usuarioCargo =
                          TipoCargo.values
                              .where((cargo) => cargo.id == usuario.idTipoCargo)
                              .firstOrNull
                              ?.nomeCargo ??
                          'Cargo não encontrado';
                      return Card(
                        key: ValueKey(usuario.id),
                        child: ListTile(
                          title: Text(
                            usuario.nome,
                            style: TextStyle(fontWeight: FontWeight(600)),
                          ),
                          subtitle: Text(usuarioCargo),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    _abrirFormulario(usuario: usuario),
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () => _confirmarExcluir(usuario),
                                icon: const Icon(Icons.delete),
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
