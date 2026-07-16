import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/emprestimo_item_datasource.dart';
import 'package:gardien_tech/data/dto/emprestimo_item_com_dispositivo_dto.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_item.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_item_repository.dart';

class EmprestimoItemRepositoryImpl implements EmprestimoItemRepository {
  final AppDatabase _database;
  final EmprestimoDispositivoRepository _edRepository;
  final DispositivoRepository _dispositivoRepository;

  EmprestimoItemRepositoryImpl(
    this._database,
    this._edRepository,
    this._dispositivoRepository,
  );

  @override
  Future<EmprestimoItem?> buscarPorId(int id) async {
    final emprestimoItem = await (_database.select(_database.emprestimoItens)
          ..where((ei) => ei.id.equals(id)))
        .getSingleOrNull();

    return emprestimoItem?.toEntity();
  }

  @override
  Future<List<EmprestimoItem>> buscarPorEmprestimo(int idEmprestimo) async {
    final emprestimoItens = await (_database.select(_database.emprestimoItens)
          ..where((ei) => ei.idEmprestimo.equals(idEmprestimo)))
        .get();

    return emprestimoItens.map((ei) => ei.toEntity()).toList();
  }

  @override
  Future<int> criar(EmprestimoItem item) async {
    return await _database
        .into(_database.emprestimoItens)
        .insert(item.toCompanion());
  }

  @override
  Future<void> atualizar(EmprestimoItem item) async {
    if (item.id == null) {
      throw ArgumentError(
        'Não é possível atualizar um item de empréstimo sem id',
      );
    }

    await (_database.update(_database.emprestimoItens)
          ..where((ei) => ei.id.equals(item.id!)))
        .write(item.toCompanion());
  }

  @override
  Future<void> deletar(int id) async {
    await (_database.delete(_database.emprestimoItens)
          ..where((ei) => ei.id.equals(id)))
        .go();
  }

  @override
  Future<void> adicionarQuantidade(int idEmprestimoItem, int qtd) async {
    final item = await buscarPorId(idEmprestimoItem);
    if (item == null) throw ArgumentError('Item não encontrado');

    item.qtdSolicitada += qtd;
    await atualizar(item);
  }

  @override
  Future<void> registrarDevolucao(int idEmprestimoItem, int qtd) async {
    final item = await buscarPorId(idEmprestimoItem);
    if (item == null) throw ArgumentError('Item não encontrado');

    item.qtdDevolvida += qtd;
    await atualizar(item);
  }

  // Associar um dispositivo específico a um item de empréstimo
  @override
  Future<void> vincularDispositivo(
    int idEmprestimo,
    int idDispositivo,
  ) async {
    // Busca o dispositivo para saber o tipo
    final dispositivo =
        await _dispositivoRepository.buscarPorId(idDispositivo);

    if (dispositivo == null) {
      throw ArgumentError('Dispositivo não encontrado');
    }

    // Verifica se o dispositivo já está vinculado
    if (dispositivo.idStatus == 3) {
      throw ArgumentError(
        'Este dispositivo já está vinculado a um empréstimo',
      );
    }

    // Busca o EmprestimoItem do mesmo tipo dentro do empréstimo
    final itens = await buscarPorEmprestimo(idEmprestimo);

    final item = itens.firstWhere(
      (i) => i.idTipoDispositivo == dispositivo.idTipoDispositivo,
      orElse: () => throw ArgumentError(
        'Não há nenhum item do tipo ${dispositivo.tipo.nomeTipo} neste empréstimo',
      ),
    );

    final vinculados =
        await _edRepository.buscarPorEmprestimoItem(item.id!);

    // Impede de criar mais vínculos que a quantidade solicitada
    if (vinculados.length >= item.qtdSolicitada) {
      throw ArgumentError(
        'Todos os dispositivos deste item já foram vinculados.',
      );
    }

    // Vincula o dispositivo ao item correto
    await _edRepository.criar(
      EmprestimoDispositivo(
        null,
        item.id!,
        idDispositivo: idDispositivo,
      ),
    );

    await _dispositivoRepository.marcarEmUso(idDispositivo);

    final vinculadosAtualizados =
        await _edRepository.buscarPorEmprestimoItem(item.id!);

    item.estaResolvido =
        vinculadosAtualizados.length >= item.qtdSolicitada;

    await atualizar(item);
  }

  //  Desfazer essa associação. Usado quando o dispositivo errado foi associado
  //  ou quando o dispositivo é devolvido e precisa ser liberado
  @override
  Future<void> desvincularDispositivo(
    int idEmprestimoDispositivo,
  ) async {
    final ed =
        await _edRepository.buscarPorId(idEmprestimoDispositivo);

    if (ed == null) {
      throw ArgumentError('Dispositivo não encontrado');
    }

    if (ed.idDispositivo != null) {
      await _dispositivoRepository
          .marcarDisponivel(ed.idDispositivo!);
    }

    await _edRepository.deletar(idEmprestimoDispositivo);

    // Reavalia estaResolvido do item
    final item = await buscarPorId(ed.idEmprestimoItem);

    if (item != null) {
      final vinculadosRestantes =
          await _edRepository.buscarPorEmprestimoItem(item.id!);

      item.estaResolvido =
          vinculadosRestantes.length >= item.qtdSolicitada;

      await atualizar(item);
    }
  }

  @override
  Future<List<EmprestimoItemComDispositivoDTO>>
      buscarEmprestimoItemComDispositivo(int idEmprestimo) async {
    final itens = await buscarPorEmprestimo(idEmprestimo);

    return Future.wait(
      itens.map((item) async {
        final dispositivosVinculados =
            await _edRepository.buscarPorEmprestimoItem(item.id!);

        final dispositivosObj = await Future.wait(
          dispositivosVinculados
              .where((emprDisp) => emprDisp.idDispositivo != null)
              .map(
                (emprDisp) => _dispositivoRepository.buscarPorId(
                  emprDisp.idDispositivo!,
                ),
              ),
        );

        return EmprestimoItemComDispositivoDTO(
          item,
          dispositivosVinculados,
          dispositivosObj.whereType<Dispositivo>().toList(),
        );
      }),
    );
  }
}