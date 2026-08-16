import 'package:gardien_tech/data/dto/emprestimo_relatorio_dto.dart';

abstract class EmprestimoService {
  Future<void> desvincularDispositivo(int idEmprestimoDispositivo);

  Future<void> vincularDispositivo(
    int idEmprestimoDispositivo,
    int idDispositivo,
  );

  Future<void> trocarDispositivo(
    int idEmprestimoDispositivo,
    int idDispositivo,
  );

  Future<void> adicionarDispositivoAoEmprestimo(
    int idEmprestimo,
    int idDispositivo,
  );

  Future<void> criarEmprestimoItemSemVinculo(
    int idEmprestimo,
    int quantidade,
    int idTipoDispositivo,
  );

  Future<List<EmprestimoRelatorioDTO>> buscarEmprestimoPorDia(DateTime data);
  Future<List<EmprestimoRelatorioDTO>> buscarEmprestimoPorUsuario(
    int idUsuario,
  );

  Future<bool> verificarSemCorrespondencia(int idEmprestimo);
}
