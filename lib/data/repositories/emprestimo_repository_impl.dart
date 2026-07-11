import 'package:drift/drift.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/emprestimo_datasource.dart';
import 'package:gardien_tech/data/dto/emprestimo_com_detalhes_dto.dart';
import 'package:gardien_tech/domain/entities/emprestimo.dart';
import 'package:gardien_tech/domain/enum/emprestimo_status.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_item_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_repository.dart';

class EmprestimoRepositoryImpl implements EmprestimoRepository {
  final AppDatabase _database;
  final EmprestimoItemRepository _emprestimoItemRepository;

  EmprestimoRepositoryImpl(this._database, this._emprestimoItemRepository);

  @override
  Future<List<Emprestimo>> buscarTodos() async {
    final emprestimos = await _database.select(_database.emprestimos).get();

    return emprestimos.map((emprestimo) => emprestimo.toEntity()).toList();
  }

  @override
  Future<List<Emprestimo>> buscarTodosAtivos() async {
    final emprestimos = await (_database.select(
      _database.emprestimos,
    )..where((emprestimo) => emprestimo.idStatus.equals(1))).get();

    return emprestimos.map((emprestimo) => emprestimo.toEntity()).toList();
  }

  @override
  Future<Emprestimo?> buscarPorId(int id) async {
    final emprestimo = await (_database.select(
      _database.emprestimos,
    )..where((emprestimo) => emprestimo.id.equals(id))).getSingleOrNull();

    return emprestimo?.toEntity();
  }

  @override
  Future<int> criar(Emprestimo emprestimo) async {
    return await _database
        .into(_database.emprestimos)
        .insert(emprestimo.toCompanion());
  }

  @override
  Future<void> atualizar(Emprestimo emprestimo) async {
    if (emprestimo.id == null) {
      throw ArgumentError('Não é possível atualizar um empréstimo sem id');
    }

    await (_database.update(_database.emprestimos)
          ..where((e) => e.id.equals(emprestimo.id!)))
        .write(emprestimo.toCompanion());
  }

  @override
  Future<void> deletar(int id) async {
    await (_database.delete(
      _database.emprestimos,
    )..where((e) => e.id.equals(id))).go();
  }

  @override
  Future<void> concluir(int id) async {
    final emprestimo = await buscarPorId(id);
    if (emprestimo == null) throw ArgumentError('Empréstimo não encontrado');

    final itens = await _emprestimoItemRepository.buscarPorEmprestimo(id);
    final pendentes = itens.where((item) => !item.estaResolvido);

    if (pendentes.isNotEmpty) {
      throw StateError('Existem itens sem dispositivos vinculados');
    }

    emprestimo.dataHoraConcluido = DateTime.now();
    emprestimo.idStatus = EmprestimoStatus.concluido.id;
    await atualizar(emprestimo);
  }

  @override
  Future<List<EmprestimoComDetalhesDTO>> buscarPorDiaComDetalhes(
    DateTime data,
  ) async {
    final rows = await (_database.select(_database.emprestimos).join([
      innerJoin(
        _database.usuarios,
        _database.emprestimos.idResponsavel.equalsExp(_database.usuarios.id),
      ),
      innerJoin(
        _database.emprestimoItens,
        _database.emprestimoItens.idEmprestimo.equalsExp(
          _database.emprestimos.id,
        ),
      ),
    ])).get();
    final Map<int, EmprestimoComDetalhesDTO> mapa = {};
    for (final row in rows) {
      final emprestimo = row.readTable(_database.emprestimos);
      final dataEmprestimo = emprestimo.dataHoraEfetuado;

      if (dataEmprestimo.day == data.day &&
          dataEmprestimo.month == data.month &&
          dataEmprestimo.year == data.year) {
        final usuario = row.readTable(_database.usuarios);
        final emprestimoItem = row.readTable(_database.emprestimoItens);

        if (mapa.containsKey(emprestimo.id)) {
          mapa[emprestimo.id]!.qtdSolicitada += emprestimoItem.qtdSolicitada;
        } else {
          mapa[emprestimo.id] = EmprestimoComDetalhesDTO(
            idEmprestimo: emprestimo.id,
            idUsuario: usuario.id,
            idEmprestimoItem: emprestimoItem.id,
            idTipoCargo: usuario.idTipoCargo,
            idStatusEmprestimo: emprestimo.idStatus,
            qtdSolicitada: emprestimoItem.qtdSolicitada,
            dataHoraEfetuado: emprestimo.dataHoraEfetuado,
            nomeUsuario: usuario.nome,
          );
        }
      }
    }

    return mapa.values.toList();
  }
}
