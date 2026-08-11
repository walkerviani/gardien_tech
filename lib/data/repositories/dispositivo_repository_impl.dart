import 'package:drift/drift.dart';
import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/dispositivo_datasource.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/enum/dispositivo_status.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';

class DispositivoRepositoryImpl implements DispositivoRepository {
  final AppDatabase _database;

  DispositivoRepositoryImpl(this._database);

  @override
  Future<Dispositivo?> buscarPorId(int id) async {
    final dispositivos = await (_database.select(_database.dispositivos)
      ..where((d) => d.id.equals(id))).getSingleOrNull();
      
    return dispositivos?.toEntity();
  }

  @override
  Future<List<Dispositivo>> buscarTodos() async {
    final dispositivos = await (_database.select(_database.dispositivos)
      ..orderBy([(d) => OrderingTerm.asc(d.numPatrimonio)])).get();
    return dispositivos.map((d) => d.toEntity()).toList();
  }

  @override
  Future<List<Dispositivo>> buscarPorTipo(int idTipoDispositivo) async {
    final dispositivos = await (_database.select(_database.dispositivos)
      ..where((d) => d.idTipoDispositivo.equals(idTipoDispositivo))
      ..orderBy([(d) => OrderingTerm.asc(d.numPatrimonio)]))
        .get();
    return dispositivos.map((d) => d.toEntity()).toList();
  }

  @override
  Future<List<Dispositivo>> buscarDescricao(String filtro) async {
    final f = filtro.trim();

    if (f.isEmpty) return [];

    final query = _database.select(_database.dispositivos)
      ..where((d) =>
          d.numPatrimonio.contains(f) |
          d.numSerie.contains(f))
      ..orderBy([(d) => OrderingTerm.asc(d.numPatrimonio)]);

    final rows = await query.get();
    final dispositivos = rows.map((d) => d.toEntity()).toList();

    // Agrupa por numPatrimonio
    final Map<String, List<Dispositivo>> grupos = {};
    for (final d in dispositivos) {
      grupos.putIfAbsent(d.numPatrimonio, () => []).add(d);
    }

    // Define prioridade do grupo: 0 = patrimônio contém f, 1 = alguma série contém f
    int prioridade(String patrimonio, List<Dispositivo> itens) {
      if (patrimonio.contains(f)) return 0;
      if (itens.any((i) => i.numSerie.contains(f))) return 1;
      return 2;
    }

    final entries = grupos.entries.toList();

    // Ordena itens dentro do grupo: primeiro itens cujo patrimônio contenha f, depois por série, depois os demais
    for (final e in entries) {
      e.value.sort((a, b) {
        final aPat = a.numPatrimonio.contains(f) ? 0 : (a.numSerie.contains(f) ? 1 : 2);
        final bPat = b.numPatrimonio.contains(f) ? 0 : (b.numSerie.contains(f) ? 1 : 2);
        if (aPat != bPat) return aPat - bPat;
        return a.numPatrimonio.compareTo(b.numPatrimonio);
      });
    }

    // Ordena grupos por prioridade e por chave
    entries.sort((a, b) {
      final pa = prioridade(a.key, a.value);
      final pb = prioridade(b.key, b.value);
      if (pa != pb) return pa - pb;
      return a.key.compareTo(b.key);
    });

    // Achata em uma lista ordenada
    final List<Dispositivo> resultado = [];
    for (final e in entries) {
      resultado.addAll(e.value);
    }

    return resultado;
  }

  @override
  Future<void> criar(Dispositivo dispositivo) async {
    await _database.into(_database.dispositivos).insert(dispositivo.toCompanion());
  }

  @override
  Future<void> atualizar(Dispositivo dispositivo) async {
    if (dispositivo.id == null) {
      throw ArgumentError('Não é possível atualizar um dispositivo sem id');
    }

    await (_database.update(_database.dispositivos)..where((d) => d.id.equals(dispositivo.id!)))
      .write(dispositivo.toCompanion());
  }

  @override
  Future<void> deletar(int id) async {
    await (_database.delete(_database.dispositivos)..where((d) => d.id.equals(id))).go();
  }
  
  @override
  Future<int> contarDisponiveisPorTipo(int idTipoDispositivo) async {
    final dispositivos = await (_database.select(_database.dispositivos)
        ..where((d) => d.idTipoDispositivo.equals(idTipoDispositivo) & d.idStatus.equals(1)))
          .get();

    return dispositivos.length;
  }
  
  @override
  Future<void> marcarDisponivel(int id) async {
    final dispositivo = await buscarPorId(id);
    if (dispositivo == null) throw ArgumentError('Dispositivo não encontrado');
    dispositivo.idStatus = DispositivoStatus.disponivel.id;
    await atualizar(dispositivo);
  }
  
  @override
  Future<void> marcarEmUso(int id) async {
    final dispositivo = await buscarPorId(id);
    if (dispositivo == null) throw ArgumentError('Dispositivo não encontrado');
    dispositivo.idStatus = DispositivoStatus.emUso.id;
    await atualizar(dispositivo);
  }

  @override
  Future<void> marcarIndisponivel(int id) async {
    final dispositivo = await buscarPorId(id);
    if (dispositivo == null) throw ArgumentError('Dispositivo não encontrado');
    dispositivo.idStatus = DispositivoStatus.indisponivel.id;
    await atualizar(dispositivo);
  }
  
  @override
  Future<Dispositivo?> buscarPorPatrimonio(String numPatrimonio) async {
    final result = await (_database.select(_database.dispositivos)
      ..where((d) => d.numPatrimonio.equals(numPatrimonio)))
      .getSingleOrNull();
    return result?.toEntity();
  }

  @override
  Future<bool> existePorPatrimonioOuSerie(String numPatrimonio, String numSerie) async {
    final result = await (_database.select(_database.dispositivos)
      ..where((d) => d.numPatrimonio.equals(numPatrimonio) | d.numSerie.equals(numSerie)))
      .getSingleOrNull();
    return result != null;
  }

  @override
  Future<List<Dispositivo>> buscarDisponiveisExcluindo({int? idTipoDispositivo, List<int> idsParaIgnorar = const []}) async {
    final query = _database.select(_database.dispositivos)
      ..where((d) => d.idStatus.equals(DispositivoStatus.disponivel.id))
      ..orderBy([(d) => OrderingTerm.asc(d.numPatrimonio)]);

    // Filtra por tipo, se informado
    if (idTipoDispositivo != null) {
      query.where((d) => d.idTipoDispositivo.equals(idTipoDispositivo));
    }

    // Ignora dispositivos que já estão na lista
    if (idsParaIgnorar.isNotEmpty) {
      query.where((d) => d.id.isNotIn(idsParaIgnorar));
    }

    final result = await query.get();
    return result.map((d) => d.toEntity()).toList();
  }
}