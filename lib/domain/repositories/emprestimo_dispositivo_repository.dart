import 'package:gardien_tech/domain/entities/emprestimo_dispositivo.dart';

abstract class EmprestimoDispositivoRepository {
  Future<List<EmprestimoDispositivo>> buscarPorEmprestimoItem(
    int idEmprestimoItem,
  );
  Future<EmprestimoDispositivo?> buscarPorId(int id);
  Future<void> criar(EmprestimoDispositivo ed);
  Future<void> atualizar(EmprestimoDispositivo ed);
  Future<void> deletar(int id);
  Future<void> vincularDispositivo(
    int idEmprestimoDispositivo,
    int idDispositivo,
  );
  Future<void> desvincularDispositivo(int idEmprestimoDispositivo);
}
