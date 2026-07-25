import 'package:gardien_tech/data/database.dart';
import 'package:gardien_tech/data/datasources/emprestimo_dispositivos_datasource.dart';
import 'package:gardien_tech/domain/entities/emprestimo_dispositivo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_item_repository.dart';

class EmprestimoDispositivoRepositoryImpl
    implements EmprestimoDispositivoRepository {
  final AppDatabase _database;
  final EmprestimoItemRepository _emprestimoItemRepository;
  final DispositivoRepository _dispositivoRepository;

  EmprestimoDispositivoRepositoryImpl(
    this._database,
    this._dispositivoRepository,
    this._emprestimoItemRepository,
  );

  @override
  Future<EmprestimoDispositivo?> buscarPorId(int id) async {
    final emprestimoDispositivo = await (_database.select(
      _database.emprestimoDispositivos,
    )..where((ed) => ed.id.equals(id))).getSingleOrNull();

    return emprestimoDispositivo?.toEntity();
  }

  @override
  Future<List<EmprestimoDispositivo>> buscarPorEmprestimoItem(
    int idEmprestimoItem,
  ) async {
    final emprestimoDispositivos = await (_database.select(
      _database.emprestimoDispositivos,
    )..where((ed) => ed.idEmprestimoItem.equals(idEmprestimoItem))).get();

    return emprestimoDispositivos.map((ed) => ed.toEntity()).toList();
  }

  @override
  Future<void> criar(EmprestimoDispositivo emprestimoDispositivo) async {
    await _database
        .into(_database.emprestimoDispositivos)
        .insert(emprestimoDispositivo.toCompanion());
  }

  @override
  Future<void> atualizar(EmprestimoDispositivo emprestimoDispositivo) async {
    if (emprestimoDispositivo.id == null) {
      throw ArgumentError(
        'Não é possível atualizar um empréstimo de dispositivo sem id',
      );
    }

    await (_database.update(_database.emprestimoDispositivos)
          ..where((ed) => ed.id.equals(emprestimoDispositivo.id!)))
        .write(emprestimoDispositivo.toCompanion());
  }

  @override
  Future<void> deletar(int id) async {
    await (_database.delete(
      _database.emprestimoDispositivos,
    )..where((ed) => ed.id.equals(id))).go();
  }

  //  Desfazer a associação. Usado quando o dispositivo errado foi associado
  //  ou quando o dispositivo é devolvido e precisa ser liberado
  @override
  Future<void> desvincularDispositivo(int idEmprestimoDispositivo) async {
    final empDispositivo = await buscarPorId(idEmprestimoDispositivo);
    if (empDispositivo == null) {
      throw ArgumentError('Dispositivo não encontrado');
    }
    // Se tiver um dispositivo, marca como disponível
    if (empDispositivo.idDispositivo != null) {
      await _dispositivoRepository.marcarDisponivel(
        empDispositivo.idDispositivo!,
      );
    }
    await deletar(idEmprestimoDispositivo);
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
    final emprestimoDispositivo = await buscarPorId(idEmprestimoDispositivo);
    final idEmprestimoItem = emprestimoDispositivo?.idEmprestimoItem;

    if (dispositivo == null) {
      throw ArgumentError('Dispositivo não encontrado');
    }
    if (dispositivo.idStatus == 3) {
      throw ArgumentError('Este dispositivo já está vinculado a um empréstimo');
    }

    // Apenas vincula, sem validar quantidade
    await atualizar(
      EmprestimoDispositivo(
        idEmprestimoDispositivo,
        idEmprestimoItem!,
        idDispositivo: idDispositivo,
      ),
    );
    await _dispositivoRepository.marcarEmUso(idDispositivo);
  }
}
