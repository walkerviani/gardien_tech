import 'package:gardien_tech/data/dto/dispositivo_com_problema_dto.dart';
import 'package:gardien_tech/domain/entities/problema.dart';

abstract class ProblemaRepository {
  Future<List<Problema>> buscarTodos();
  Future<List<Problema>> buscarTodosPorDispositivo(int idDispositivo);
  Future<Problema?> buscarPorId(int id);
  Future<void> criar(Problema problema);
  Future<void> atualizar(Problema problema);
  Future<void> deletar(int id);
  Future<List<DispositivoComProblemaDTO>> buscarProblemasAtivosComDispositivos();
}