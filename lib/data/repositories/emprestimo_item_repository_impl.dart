import 'package:drift/drift.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/dispositivo_datasource.dart';
import 'package:gardien_tech/data/datasources/emprestimo_dispositivos_datasource.dart';
import 'package:gardien_tech/data/datasources/emprestimo_item_datasource.dart';
import 'package:gardien_tech/data/dto/emprestimo_item_com_dispositivo_dto.dart';
import 'package:gardien_tech/domain/entities/emprestimo_item.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_item_repository.dart';

class EmprestimoItemRepositoryImpl implements EmprestimoItemRepository {
  final AppDatabase _database;

  EmprestimoItemRepositoryImpl(this._database);

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
    final rows = await (_database.select(_database.emprestimoItens)
      ..where((ei) => ei.idEmprestimo.equals(idEmprestimo)))
      .join([
        leftOuterJoin(
          _database.emprestimoDispositivos,
          _database.emprestimoDispositivos.idEmprestimoItem
              .equalsExp(_database.emprestimoItens.id),
        ),
        leftOuterJoin(
          _database.dispositivos,
          _database.dispositivos.id.equalsExp(
            _database.emprestimoDispositivos.idDispositivo,
          ),
        ),
      ])
      .get();

    // Agrupa os resultados por EmprestimoItem
    final Map<int, EmprestimoItemData> itensMap = {};
    final Map<int, List<EmprestimoDispositivoData>> dispositivosMap = {};
    final Map<int, List<DispositivoData>> dispositivosObjMap = {};

    for (final row in rows) {
      final item = row.readTable(_database.emprestimoItens);
      final emprDisp = row.readTableOrNull(_database.emprestimoDispositivos);
      final dispositivo = row.readTableOrNull(_database.dispositivos);

      if (!itensMap.containsKey(item.id)) {
        itensMap[item.id] = item;
        dispositivosMap[item.id] = [];
        dispositivosObjMap[item.id] = [];
      }

      if (emprDisp != null) {
        dispositivosMap[item.id]!.add(emprDisp);
      }
      if (dispositivo != null) {
        dispositivosObjMap[item.id]!.add(dispositivo);
      }
    }

    return itensMap.entries.map((entry) {
      final item = entry.value.toEntity();
      final empDisps = dispositivosMap[entry.key]!
          .map((ed) => ed.toEntity())
          .toList();
      final disps = dispositivosObjMap[entry.key]!
          .map((d) => d.toEntity())
          .toList();
      return EmprestimoItemComDispositivoDTO(item, empDisps, disps);
    }).toList();
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
