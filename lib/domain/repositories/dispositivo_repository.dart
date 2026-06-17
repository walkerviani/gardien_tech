import 'package:gardien_tech/domain/entities/dispositivo.dart';

abstract class DispositivoRepository {
  Future<Dispositivo?> buscarPorId(int id);
  Future<List<Dispositivo>> buscarTodos();
  Future<List<Dispositivo>> buscarPorTipo(int idTipoDispositivo);
  Future<void> criar(Dispositivo dispositivo);
  Future<void> atualizar(Dispositivo dispositivo);
  Future<void> deletar(int id);
  Future<int> contarDisponiveisPorTipo(int idTipoDispositivo);
}