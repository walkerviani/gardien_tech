import 'package:flutter/foundation.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/problema_repository.dart';
import 'package:gardien_tech/domain/services/emprestimo_service.dart';
import 'package:gardien_tech/utils/relatorio_pdf_service.dart';

class RelatoriosViewmodel extends ChangeNotifier {
  final RelatorioPdfService _relatorioPdfService;
  final DispositivoRepository _dispositivoRepository;
  final ProblemaRepository _problemaRepository;
  final EmprestimoService _emprestimoService;

  RelatoriosViewmodel(
    this._relatorioPdfService,
    this._dispositivoRepository,
    this._problemaRepository,
    this._emprestimoService,
  );
  String? errorMessage;

  // Relatório de empréstimos do dia selecionado pelo usuário
  Future<Uint8List?> gerarRelatorioEmpDia(DateTime data) async {
    errorMessage = null;
    try {
      final relatorios = await _emprestimoService.buscarEmprestimoPorDia(data);
      if (relatorios.isEmpty) {
        errorMessage = 'Não foi encontrado nenhum empréstimo nessa data';
        return null;
      }
      return _relatorioPdfService.gerarPdfEmprestimoDia(relatorios, data);
    } catch (e) {
      errorMessage = 'Erro ao gerar relatório';
      return null;
    }
  }

  // Relatório de empréstimos por usuário
  Future<Uint8List?> gerarRelatorioEmpUsuario(Usuario usuario) async {
    errorMessage = null;
    try {
      final relatorios = await _emprestimoService.buscarEmprestimoPorUsuario(
        usuario.id!,
      );
      if (relatorios.isEmpty) {
        errorMessage = 'Não foi encontrado nenhum empréstimo para esse usuário';
        return null;
      }
      return _relatorioPdfService.gerarPdfEmprestimoUsuario(
        relatorios,
        usuario,
      );
    } catch (e) {
      errorMessage = 'Erro ao gerar relatório';
      return null;
    }
  }

  // Relatório de problemas relatados
  Future<Uint8List?> gerarRelatorioProblemas() async {
    errorMessage = null;
    try {
      final problemas = await _problemaRepository
          .buscarProblemasAtivosComDispositivos();
      if (problemas.isEmpty) {
        errorMessage = 'Não foi encontrado nenhum problema';
        return null;
      }
      return _relatorioPdfService.gerarPdfProblemas(problemas);
    } catch (e) {
      errorMessage = 'Erro ao gerar relatório';
      return null;
    }
  }

  // Relatório de dispositivos cadastrados
  Future<Uint8List?> gerarRelatorioDispositivos() async {
    errorMessage = null;
    try {
      final dispositivos = await _dispositivoRepository.buscarTodos();
      if (dispositivos.isEmpty) {
        errorMessage = 'Não foi encontrado nenhum dispositivo';
        return null;
      }
      return _relatorioPdfService.gerarPdfDispositivos(dispositivos);
    } catch (e) {
      errorMessage = 'Erro ao gerar relatório';
      return null;
    }
  }
}
