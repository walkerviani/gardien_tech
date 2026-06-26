import 'package:gardien_tech/domain/entities/emprestimo_dispositivo.dart';

abstract class EmprestimoDispositivoRepository {
  Future<List<EmprestimoDispositivo>> buscarPorEmprestimoItem(int idEmprestimoItem);
  Future<EmprestimoDispositivo?> buscarPorId(int id);
  Future<void> criar(EmprestimoDispositivo ed);
  Future<void> atualizar(EmprestimoDispositivo ed);
  Future<void> deletar(int id);
}