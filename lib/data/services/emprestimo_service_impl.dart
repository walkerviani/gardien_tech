import 'package:gardien_tech/domain/entities/emprestimo_dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_item.dart';
import 'package:gardien_tech/domain/enum/dispositivo_status.dart';

import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_item_repository.dart';

import 'package:gardien_tech/domain/services/emprestimo_service.dart';

import 'package:collection/collection.dart';

class EmprestimoServiceImpl implements EmprestimoService {
  final EmprestimoItemRepository _emprestimoItemRepository;
  final EmprestimoDispositivoRepository _emprestimoDispRepository;
  final DispositivoRepository _dispositivoRepository;

  EmprestimoServiceImpl(
    this._emprestimoItemRepository,
    this._emprestimoDispRepository,
    this._dispositivoRepository,
  );

  //  Desfazer a associação. Usado quando o dispositivo errado foi associado
  //  ou quando o dispositivo é devolvido e precisa ser liberado
  @override
  Future<void> desvincularDispositivo(int idEmprestimoDispositivo) async {
    final empDispositivo = await _emprestimoDispRepository.buscarPorId(
      idEmprestimoDispositivo,
    );
    if (empDispositivo == null) {
      throw ArgumentError('Dispositivo não encontrado');
    }
    // Se tiver um dispositivo, marca como disponível
    if (empDispositivo.idDispositivo != null) {
      await _dispositivoRepository.marcarDisponivel(
        empDispositivo.idDispositivo!,
      );
    }
    await _emprestimoDispRepository.deletar(idEmprestimoDispositivo);
    await _emprestimoItemRepository.diminuirQntSolicitada(
      empDispositivo.idEmprestimoItem,
      1,
    );
  }

  // Associa um dispositivo a um emprestimo_dispositivo vazio
  @override
  Future<void> vincularDispositivo(
    int idEmprestimoDispositivo,
    int idDispositivo,
  ) async {
    final dispositivo = await _dispositivoRepository.buscarPorId(idDispositivo);
    final emprestimoDispositivo = await _emprestimoDispRepository.buscarPorId(
      idEmprestimoDispositivo,
    );
    final idEmprestimoItem = emprestimoDispositivo?.idEmprestimoItem;

    if (dispositivo == null) {
      throw ArgumentError('Dispositivo não encontrado');
    }
    if (dispositivo.idStatus == DispositivoStatus.emUso.id) {
      throw ArgumentError('Este dispositivo já está vinculado a um empréstimo');
    }

    // Apenas vincula, sem validar quantidade
    await _emprestimoDispRepository.atualizar(
      EmprestimoDispositivo(
        idEmprestimoDispositivo,
        idEmprestimoItem!,
        idDispositivo: idDispositivo,
      ),
    );
    await _dispositivoRepository.marcarEmUso(idDispositivo);
  }

  @override
  Future<void> trocarDispositivo(
    int idEmprestimoDispositivo,
    int idDispositivo,
  ) async {
    final emprestimoDispositivo =
        await _emprestimoDispRepository.buscarPorId(idEmprestimoDispositivo);
    if (emprestimoDispositivo == null) {
      throw ArgumentError('Item de empréstimo não encontrado');
    }
    if (emprestimoDispositivo.idDispositivo == null) {
      throw ArgumentError('O item não possui dispositivo vinculado');
    }

    final dispositivoNovo = await _dispositivoRepository.buscarPorId(idDispositivo);
    if (dispositivoNovo == null) {
      throw ArgumentError('Dispositivo não encontrado');
    }
    if (dispositivoNovo.idStatus == DispositivoStatus.emUso.id) {
      throw ArgumentError('Este dispositivo já está vinculado a um empréstimo');
    }

    final dispositivoAntigo = await _dispositivoRepository.buscarPorId(
      emprestimoDispositivo.idDispositivo!,
    );
    if (dispositivoAntigo == null) {
      throw ArgumentError('Dispositivo antigo não encontrado');
    }

    if (dispositivoAntigo.idTipoDispositivo !=
        dispositivoNovo.idTipoDispositivo) {
      throw ArgumentError('O dispositivo precisa ter o mesmo tipo');
    }

    if (dispositivoNovo.id == dispositivoAntigo.id) {
      throw ArgumentError('O dispositivo selecionado é o mesmo');
    }

    try {
      await _dispositivoRepository.marcarDisponivel(dispositivoAntigo.id!);
      await _dispositivoRepository.marcarEmUso(idDispositivo);
      await _emprestimoDispRepository.atualizar(
        EmprestimoDispositivo(
          idEmprestimoDispositivo,
          emprestimoDispositivo.idEmprestimoItem,
          idDispositivo: idDispositivo,
        ),
      );
    } catch (e) {
      if (dispositivoAntigo.id != null) {
        await _dispositivoRepository.marcarEmUso(dispositivoAntigo.id!);
      }
      await _dispositivoRepository.marcarDisponivel(idDispositivo);
      rethrow;
    }
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
    final empItens = await _emprestimoItemRepository.buscarPorEmprestimo(
      idEmprestimo,
    );
    EmprestimoItem? empItem = empItens.firstWhereOrNull(
      (i) => i.idTipoDispositivo == dispositivo.idTipoDispositivo,
    );

    if (empItem == null) {
      // Se já não houver um emprestimo_item com o tipo do dispositivo, crie um novo emprestimo_item com quantidade inicial 0
      final novoEmpItemId = await _emprestimoItemRepository.criar(
        EmprestimoItem(
          null,
          idEmprestimo,
          dispositivo.idTipoDispositivo,
          0,
          qtdDevolvida: 0,
          estaResolvido: false,
        ),
      );
      empItem = await _emprestimoItemRepository.buscarPorId(novoEmpItemId);
    }

    await _emprestimoItemRepository.aumentarQntSolicitada(empItem!.id!, 1);
    // Vincula o dispositivo ao emprestimo dispositivo
    await _emprestimoDispRepository.criar(
      EmprestimoDispositivo(null, empItem.id!, idDispositivo: idDispositivo),
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
    final empItens = await _emprestimoItemRepository.buscarPorEmprestimo(
      idEmprestimo,
    );
    var empItem = empItens.firstWhereOrNull(
      (i) => i.idTipoDispositivo == idTipoDispositivo,
    );
    if (empItem == null) {
      // Se já não houver um emprestimo_item com o tipo do dispositivo, crie um novo emprestimo_item com quantidade inicial 0
      final novoEmpItemId = await _emprestimoItemRepository.criar(
        EmprestimoItem(
          null,
          idEmprestimo,
          idTipoDispositivo,
          0,
          qtdDevolvida: 0,
          estaResolvido: false,
        ),
      );
      empItem = await _emprestimoItemRepository.buscarPorId(novoEmpItemId);
    }

    await _emprestimoItemRepository.aumentarQntSolicitada(
      empItem!.id!,
      qntDispositivo,
    );

    for (int i = 0; i < qntDispositivo; i++) {
      // Cria um emprestimo_dispositivo para cada quantidade mas deixa a vinculação para depois
      await _emprestimoDispRepository.criar(
        EmprestimoDispositivo(null, empItem.id!, idDispositivo: null),
      );
    }
  }
}
