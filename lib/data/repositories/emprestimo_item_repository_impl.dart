import 'package:collection/collection.dart';
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

  // Cria um emprestimo_item caso não haja nenhum e já vincula o dispositivo ao emprestimo_dispositivo
  @override
  Future<void> adicionarDispositivoAoEmprestimo(
    int idEmprestimo,
    int idDispositivo,
  ) async {
    final dispositivo = await _dispositivoRepository.buscarPorId(idDispositivo);
    if (dispositivo == null) {
      throw ArgumentError('Dispositivo não encontrado');
    }
    if (dispositivo.idStatus == 3) {
      // Se o dispositivo estiver 'em uso'
      throw ArgumentError('Este dispositivo já está vinculado a um empréstimo');
    }

    // Procura se já há um emprestimo_item com o tipo do dispositivo
    final empItens = await buscarPorEmprestimo(idEmprestimo);
    var empItem = empItens.firstWhereOrNull(
      (i) => i.idTipoDispositivo == dispositivo.idTipoDispositivo,
    );

    if (empItem == null) {
      // Se já não houver um emprestimo_item com o tipo do dispositivo, crie um novo emprestimo_item com o tipo
      final novoEmpItemId = await criar(
        EmprestimoItem(
          null,
          idEmprestimo,
          dispositivo.idTipoDispositivo,
          1,
          qtdDevolvida: 0,
          estaResolvido: false,
        ),
      );
      empItem = await buscarPorId(novoEmpItemId);
    }

    // Vincula o dispositivo ao emprestimo dispositivo
    await _edRepository.criar(
      EmprestimoDispositivo(null, empItem!.id!, idDispositivo: idDispositivo),
    );
    // Marca o dispositivo em uso
    await _dispositivoRepository.marcarEmUso(idDispositivo);
  }

  /* 
  Cria emprestimo_item caso não exista nenhum do tipo do dispositivo e
  cria emprestimo_dispositivo para a quantidade informada e deixa para vincular o dispositivo posteriormente
  */
  @override
  Future<void> criarEmprestimoItemSemVinculo(
    int idEmprestimo,
    int qntDispositivo,
    int idTipoDispositivo,
  ) async {
    // Procura se já há um emprestimo_item com o tipo do dispositivo
    final empItens = await buscarPorEmprestimo(idEmprestimo);
    var empItem = empItens.firstWhereOrNull(
      (i) => i.idTipoDispositivo == idTipoDispositivo,
    );
    if (empItem == null) {
      // Se já não houver um emprestimo_item com o tipo do dispositivo, crie um novo emprestimo_item com o tipo
      final novoEmpItemId = await criar(
        EmprestimoItem(
          null,
          idEmprestimo,
          idTipoDispositivo,
          qntDispositivo,
          qtdDevolvida: 0,
          estaResolvido: false,
        ),
      );
      empItem = await buscarPorId(novoEmpItemId);
    }

    await aumentarQntSolicitada(empItem!.id!, qntDispositivo);

    for (int i = 0; i < qntDispositivo; i++) {
      // Cria um emprestimo_dispositivo para cada quantidade mas deixa a vinculação para depois
      await _edRepository.criar(
        EmprestimoDispositivo(null, empItem.id!, idDispositivo: null),
      );
    }
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
