import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';
import 'package:gardien_tech/domain/enum/tipo_cargo.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';
import 'package:gardien_tech/presentation/viewmodels/usuario_viewmodel.dart';
import 'package:gardien_tech/presentation/views/gerenciar_usuario_screen.dart';
import 'package:provider/provider.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {

  void _abrirFormulario({Usuario? usuario}) async {
    final viewModel = context.read<UsuarioViewmodel>();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (context) =>
              UsuarioViewmodel(context.read<UsuarioRepository>()),
          child: GerenciarUsuarioScreen(
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
              style: TextStyle(color: Color(0xFF000000)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final viewModel = context.read<UsuarioViewmodel>();
              final sucesso = await viewModel.deletar(usuario.id!);
              if (!mounted) return;
              if (sucesso) {
                viewModel.carregarUsuarios();
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
        title: const Text('Usuários'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
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
                  Icon(Icons.person_add, size: 30),
                  SizedBox(width: 20),
                  Text(
                    'Adicionar Novo Usuário',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<UsuarioViewmodel>(
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
                          title: Text(usuario.nome,style: TextStyle(
                            fontWeight: FontWeight(600),
                          )),
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
