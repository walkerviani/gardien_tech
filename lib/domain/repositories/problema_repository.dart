import 'package:gardien_tech/domain/entities/problema.dart';

abstract class ProblemaRepository {
  Future<List<Problema>> obterTodos();
  Future<List<Problema>> obterTodosPorDispositivo(int idDispositivo);
  Future<Problema?> buscarPorId(int id);
  Future<void> criar(Problema problema);
  Future<void> atualizar(Problema problema);
  Future<void> deletar(int id);
}