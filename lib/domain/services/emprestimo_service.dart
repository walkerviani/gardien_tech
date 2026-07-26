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
}