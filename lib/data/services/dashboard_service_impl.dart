import 'package:drift/drift.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/emprestimo_datasource.dart';
import 'package:gardien_tech/domain/entities/emprestimo.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_repository.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';
import 'package:gardien_tech/domain/services/dashboard_service.dart';

class DashboardServiceImpl implements DashboardService {
  final AppDatabase _database;

  final EmprestimoRepository _emprestimoRepository;
  final DispositivoRepository _dispositivoRepository;
  final UsuarioRepository _usuarioRepository;

  DashboardServiceImpl(
    this._database,
    this._emprestimoRepository,
    this._dispositivoRepository,
    this._usuarioRepository,
  );

  @override
  Future<List<Emprestimo>> historicoDispositivoEmprestado(
    int idDispositivo,
  ) async {
    final rows =
        await (_database.select(_database.emprestimos).join([
              innerJoin(
                _database.emprestimoItens,
                _database.emprestimoItens.idEmprestimo.equalsExp(
                  _database.emprestimos.id,
                ),
              ),
              innerJoin(
                _database.emprestimoDispositivos,
                _database.emprestimoDispositivos.idEmprestimoItem.equalsExp(
                  _database.emprestimoItens.id,
                ),
              ),
            ])..where(
              _database.emprestimoDispositivos.idDispositivo.equals(
                idDispositivo,
              ),
            ))
            .get();

    final emprestimosPorId = <int, EmprestimoData>{};
    for (final row in rows) {
      final emprestimo = row.readTable(_database.emprestimos);
      emprestimosPorId[emprestimo.id] = emprestimo;
    }

    return emprestimosPorId.values
        .map((emprestimo) => emprestimo.toEntity())
        .toList();
  }

  @override
  Future<int> totalEmprestimos() async {
    final emprestimos = await _emprestimoRepository.buscarTodos();
    return emprestimos.length;
  }

  @override
  Future<int> totalEmprestimosAtivos() async {
    final emprestimos = await _emprestimoRepository.buscarTodosAtivos();
    return emprestimos.length;
  }

  @override
  Future<int> totalEmprestimosEmObservacao() async {
    final emprestimos = await _emprestimoRepository.buscarTodosEmObservacao();
    return emprestimos.length;
  }

  @override
  Future<int> totalEmprestimosSemCorrespondencia() async {
    final emprestimos = await _emprestimoRepository
        .buscarTodosSemCorrespondencia();
    return emprestimos.length;
  }

  @override
  Future<int> totalEmprestimosConcluidos() async {
    final emprestimos = await _emprestimoRepository.buscarTodosConcluidos();
    return emprestimos.length;
  }

  @override
  Future<int> totalDispositivos() async {
    final dispositivos = await _dispositivoRepository.buscarTodos();
    return dispositivos.length;
  }

  @override
  Future<int> totalDispositivosDisponiveis() async {
    final dispositivos = await _dispositivoRepository.buscarTodosDisponiveis();
    return dispositivos.length;
  }

  @override
  Future<int> totalDispositivosIndisponiveis() async {
    final dispositivos = await _dispositivoRepository
        .buscarTodosIndisponiveis();
    return dispositivos.length;
  }

  @override
  Future<int> totalDispositivosEmUso() async {
    final dispositivos = await _dispositivoRepository.buscarTodosEmUso();
    return dispositivos.length;
  }

  @override
  Future<Map<String, int>> totalEmprestimosUsuarios() async {
    final usuarios = await _usuarioRepository.buscarTodos();
    final emprestimos = await _emprestimoRepository.buscarTodos();

    final contagem = <int, int>{};
    for (final emprestimo in emprestimos) {
      contagem[emprestimo.idResponsavel] =
          (contagem[emprestimo.idResponsavel] ?? 0) + 1;
    }
    return {
      for (final usuario in usuarios) usuario.nome: contagem[usuario.id] ?? 0,
    };
  }

  @override
  Future<Map<TipoDispositivo, int>> totalDispositivosPorTipo() async {
    final dispositivos = await _dispositivoRepository.buscarTodos();
    final quantidades = {
      for (final tipo in TipoDispositivo.values) tipo: 0,
    }; // Cria um mapa com uma entrada para cada valor de TipoDispositivo, iniciando todas as quantidades em 0

    for (final dispositivo in dispositivos) {
      quantidades[dispositivo.tipo] = quantidades[dispositivo.tipo]! + 1;
    }

    return quantidades;
  }
}
