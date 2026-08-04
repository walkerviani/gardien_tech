import 'dart:convert';

import 'package:gardien_tech/data/dto/backup_dto.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_item_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_repository.dart';
import 'package:gardien_tech/domain/repositories/problema_repository.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';
import 'package:gardien_tech/domain/services/backup_service.dart';

class BackupServiceImpl implements BackupService {
  final UsuarioRepository usuarioRepository;
  final DispositivoRepository dispositivoRepository;
  final ProblemaRepository problemaRepository;
  final EmprestimoRepository emprestimoRepository;
  final EmprestimoItemRepository emprestimoItemRepository;
  final EmprestimoDispositivoRepository emprestimoDispositivoRepository;

  BackupServiceImpl(
    this.usuarioRepository,
    this.dispositivoRepository,
    this.problemaRepository,
    this.emprestimoRepository,
    this.emprestimoItemRepository,
    this.emprestimoDispositivoRepository,
  );

  @override
  Future<String> exportarJson() async {
    final backup = BackupDTO(
      usuarios: await usuarioRepository.buscarTodos(),
      dispositivos: await dispositivoRepository.buscarTodos(),
      problemas: await problemaRepository.buscarTodos(),
      emprestimos: await emprestimoRepository.buscarTodos(),
      emprestimoItens: await emprestimoItemRepository.buscarTodos(),
      emprestimoDispositivos: await emprestimoDispositivoRepository.buscarTodos(),
    );

    return jsonEncode(backup.toJson());
  }

  @override
  Future<void> importarJson(String jsonString) async {
    final mapa = jsonDecode(jsonString) as Map<String, dynamic>;
    final backup = BackupDTO.fromJson(mapa);

    // Limpeza do banco respeitando foreign keys: 
    // emprestimo_dispositivos, emprestimo_itens, emprestimos, problemas, dispositivos, usuarios
    for (final empDisp in await emprestimoDispositivoRepository.buscarTodos()) {
      await emprestimoDispositivoRepository.deletar(empDisp.id!);
    }
    for (final empItem in await emprestimoItemRepository.buscarTodos()) {
      await emprestimoItemRepository.deletar(empItem.id!);
    }
    for (final emp in await emprestimoRepository.buscarTodos()) {
      await emprestimoRepository.deletar(emp.id!);
    }
    for (final prob in await problemaRepository.buscarTodos()) {
      await problemaRepository.deletar(prob.id!);
    }
    for (final disp in await dispositivoRepository.buscarTodos()) {
      await dispositivoRepository.deletar(disp.id!);
    }
    for (final user in await usuarioRepository.buscarTodos()) {
      await usuarioRepository.deletar(user.id!);
    }

    // Inserção respeitando foreign keys: 
    // usuarios, dispositivos, problemas, emprestimos, emprestimo_itens, emprestimo_dispositivos
    for (final usuario in backup.usuarios) {
      await usuarioRepository.criar(usuario);
    }
    for (final dispositivo in backup.dispositivos) {
      await dispositivoRepository.criar(dispositivo);
    }
    for (final problema in backup.problemas) {
      await problemaRepository.criar(problema);
    }
    for (final emprestimo in backup.emprestimos) {
      await emprestimoRepository.criar(emprestimo);
    }
    for (final emprestimoItem in backup.emprestimoItens) {
      await emprestimoItemRepository.criar(emprestimoItem);
    }
    for (final emprestimoDispositivo in backup.emprestimoDispositivos) {
      await emprestimoDispositivoRepository.criar(emprestimoDispositivo);
    }
  }
}