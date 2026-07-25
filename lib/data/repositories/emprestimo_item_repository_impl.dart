import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/emprestimo_item_datasource.dart';
import 'package:gardien_tech/data/dto/emprestimo_item_com_dispositivo_dto.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
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
    final emprestimoItem = await (_database.select(
      _database.emprestimoItens,
    )..where((ei) => ei.id.equals(id))).getSingleOrNull();
    return emprestimoItem?.toEntity();
  }

  @override
  Future<List<EmprestimoItem>> buscarPorEmprestimo(int idEmprestimo) async {
    final emprestimoItens = await (_database.select(
      _database.emprestimoItens,
    )..where((ei) => ei.idEmprestimo.equals(idEmprestimo))).get();
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
    await (_database.update(
      _database.emprestimoItens,
    )..where((ei) => ei.id.equals(item.id!))).write(item.toCompanion());
  }

  @override
  Future<void> deletar(int id) async {
    await (_database.delete(
      _database.emprestimoItens,
    )..where((ei) => ei.id.equals(id))).go();
  }

  // Trás o emprestimo_item com os objetos dispositivos
  @override
  Future<List<EmprestimoItemComDispositivoDTO>>
  buscarEmprestimoItemComDispositivo(int idEmprestimo) async {
    final itens = await buscarPorEmprestimo(idEmprestimo);
    return Future.wait(
      itens.map((item) async {
        final dispositivosVinculados = await _edRepository
            .buscarPorEmprestimoItem(item.id!);
        final dispositivosObj = await Future.wait(
          dispositivosVinculados
              .where((emprDisp) => emprDisp.idDispositivo != null)
              .map(
                (emprDisp) =>
                    _dispositivoRepository.buscarPorId(emprDisp.idDispositivo!),
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

  @override
  Future<void> aumentarQntDevolvida(int idEmprestimoItem, int qtd) async {
    final item = await buscarPorId(idEmprestimoItem);
    if (item == null) throw ArgumentError('Item não encontrado');
    item.qtdDevolvida += qtd;
    await atualizar(item);
  }

  @override
  Future<void> diminuirQntDevolvida(int idEmprestimoItem, int qtd) async {
    final item = await buscarPorId(idEmprestimoItem);
    if (item == null) throw ArgumentError('Item não encontrado');
    item.qtdDevolvida -= qtd;
    await atualizar(item);
  }

  @override
  Future<void> aumentarQntSolicitada(int idEmprestimoItem, int qtd) async {
    final item = await buscarPorId(idEmprestimoItem);
    if (item == null) throw ArgumentError('Item não encontrado');
    item.qtdSolicitada += qtd;
    await atualizar(item);
  }

  @override
  Future<void> diminuirQntSolicitada(int idEmprestimoItem, int qtd) async {
    final item = await buscarPorId(idEmprestimoItem);
    if (item == null) throw ArgumentError('Item não encontrado');
    item.qtdSolicitada -= qtd;
    await atualizar(item);
  }

  @override
  Future<bool> verificarDevolucao(int idEmprestimoItem) async {
    EmprestimoItem? emprestimoItem = await buscarPorId(idEmprestimoItem);
    int qntSolicitada = emprestimoItem!.qtdSolicitada;
    int qntDevolvida = emprestimoItem.qtdDevolvida;

    if (qntDevolvida > qntSolicitada) {
      return false; // Se a quantidade devolvida é maior que a solicitada então é erro
    }
    if (qntDevolvida < qntSolicitada) {
      return false; // Não foi devolvido tudo
    }
    if (qntDevolvida == qntSolicitada) {
      return true; // Foi devolvido tudo
    }
    return false; // Provavelmente algum erro
  }
}
