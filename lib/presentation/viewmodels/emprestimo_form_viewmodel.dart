import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_repository.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';
import 'package:gardien_tech/domain/services/emprestimo_service.dart';

enum OpcaoEmprestimo { quantidade, unidade }

class EmprestimoFormViewModel extends ChangeNotifier {
  OpcaoEmprestimo opcaoView = OpcaoEmprestimo.quantidade;
  final List<ItemQuantidade> itensQuantidade = [
    ItemQuantidade(
      tipoDisp: TipoDispositivo.notebook.nomeTipo,
      quantidade: TextEditingController(),
    ),
  ];
  final List<ItemUnidade> itensUnidade = [];
  Usuario? responsavelSelecionado;
  String? erroBusca;

  final TextEditingController responsavelController = TextEditingController();
  final TextEditingController pesquisaController = TextEditingController();

  final DispositivoRepository _dispositivoRepository;
  final UsuarioRepository _usuarioRepository;
  final EmprestimoRepository _emprestimoRepository;
  final EmprestimoService _emprestimoService;

  EmprestimoFormViewModel({
    required this._dispositivoRepository,
    required this._usuarioRepository,
    required this._emprestimoRepository,
    required this._emprestimoService,
  });

  void alternarOpcao(OpcaoEmprestimo novaOpcao) {
    opcaoView = novaOpcao;
    notifyListeners();
  }

  void adicionarItemQuantidade() {
    itensQuantidade.add(
      ItemQuantidade(tipoDisp: '', quantidade: TextEditingController()),
    );
    notifyListeners();
  }

  void removerItemQuantidade(int index) {
    itensQuantidade[index].quantidade.dispose();
    itensQuantidade.removeAt(index);
    notifyListeners();
  }

  void removerItemUnidade(int index) {
    itensUnidade.removeAt(index);
    notifyListeners();
  }

  void atualizarTipoDispositivo(int index, String? novoTipo) {
    itensQuantidade[index].tipoDisp =
        novoTipo ?? itensQuantidade[index].tipoDisp;
    notifyListeners();
  }

  void atualizarAvisoQuantidade(int index, int quantidade) {
    itensQuantidade[index].mostrarAviso = quantidade >= 100;
    notifyListeners();
  }

  Future<List<Usuario>> buscarResponsavel(String value) async {
    if (responsavelSelecionado != null &&
        value != responsavelSelecionado!.nome) {
      responsavelSelecionado = null;
    }

    if (value.trim().isEmpty) {
      return [];
    }

    return await _usuarioRepository.buscarNome(value);
  }

  void selecionarResponsavel(Usuario usuario) {
    responsavelSelecionado = usuario;
    responsavelController.text = usuario.nome;
    notifyListeners();
  }

  Future<List<Dispositivo>> buscarDispositivo(String value) async {
    if (erroBusca != null) {
      erroBusca = null;
      notifyListeners();
    }

    if (value.trim().isEmpty) {
      return [];
    }

    final dispositivos = await _dispositivoRepository.buscarDescricao(value);

    return dispositivos.where((dispositivo) {
      // Filtra para remover dispositivos que estão Em Uso
      final disponivel = dispositivo.idStatus != 3;

      // Filtra para remover dispositivos já adicionados na lista atual
      final naoAdicionado = !itensUnidade.any(
        (item) => item.numPatrimonio == dispositivo.numPatrimonio,
      );

      return disponivel && naoAdicionado;
    }).toList();
  }

  void selecionarDispositivo(Dispositivo dispositivo) {
    final jaAdicionado = itensUnidade.any(
      (item) => item.numPatrimonio == dispositivo.numPatrimonio,
    );

    if (jaAdicionado) {
      erroBusca = 'Este dispositivo já foi adicionado à lista.';
      notifyListeners();
      return;
    }

    itensUnidade.add(
      ItemUnidade(
        idTipoDispositivo: dispositivo.idTipoDispositivo,
        tipoDisp: dispositivo.tipo.nomeTipo,
        numSerie: dispositivo.numSerie,
        numPatrimonio: dispositivo.numPatrimonio,
      ),
    );

    erroBusca = null;
    pesquisaController.clear();
    notifyListeners();
  }

  List<String> validarEConfirmar() {
    final erros = <String>[];

    if (responsavelSelecionado == null) {
      erros.add('Responsável é obrigatório');
    }

    if (opcaoView == OpcaoEmprestimo.quantidade) {
      if (itensQuantidade.isEmpty) {
        erros.add('Adicione pelo menos um tipo de dispositivo');
      }

      for (int i = 0; i < itensQuantidade.length; i++) {
        final item = itensQuantidade[i];
        if (item.quantidade.text.trim().isEmpty ||
            item.quantidade.text == '0') {
          erros.add('Item ${i + 1}: informe a quantidade');
        }
        if (item.tipoDisp == null || item.tipoDisp!.isEmpty) {
          erros.add('Item ${i + 1}: selecione o tipo de dispositivo');
        }
      }
    } else {
      if (itensUnidade.isEmpty) {
        erros.add('Adicione pelo menos um dispositivo por unidade');
      }
    }

    return erros;
  }

  @override
  void dispose() {
    responsavelController.dispose();
    pesquisaController.dispose();

    for (final item in itensQuantidade) {
      item.quantidade.dispose();
    }

    super.dispose();
  }

  Future<void> confirmar() async {
    final emprestimo = Emprestimo(null, responsavelSelecionado!.id!);
    final idEmprestimo = await _emprestimoRepository.criar(emprestimo);

    try {
      if (opcaoView == OpcaoEmprestimo.quantidade) {
        await _criarItensQuantidade(idEmprestimo);
      } else {
        await _criarItensUnidade(idEmprestimo);
      }
    } catch (e) {
      await _emprestimoRepository.deletar(idEmprestimo);
      rethrow;
    }
  }

  Future<void> _criarItensQuantidade(int idEmprestimo) async {
    for (final item in itensQuantidade) {
      final tipo = TipoDispositivo.values.firstWhere(
        (t) => t.nomeTipo == item.tipoDisp,
      );

      await _emprestimoService.criarEmprestimoItemSemVinculo(
        idEmprestimo,
        int.parse(item.quantidade.text),
        tipo.id,
      );
    }
  }

  Future<void> _criarItensUnidade(int idEmprestimo) async {
    for (final item in itensUnidade) {
      final dispositivo = await _dispositivoRepository.buscarPorPatrimonio(
        item.numPatrimonio!,
      );

      if (dispositivo == null) {
        throw ArgumentError('Dispositivo não encontrado.');
      }

      await _emprestimoService.adicionarDispositivoAoEmprestimo(
        idEmprestimo,
        dispositivo.id!,
      );
    }
  }
}

class ItemQuantidade {
  String? tipoDisp;
  bool mostrarAviso = false;
  TextEditingController quantidade;
  final Key key = UniqueKey();

  ItemQuantidade({required this.tipoDisp, required this.quantidade});
}

class ItemUnidade {
  int? idTipoDispositivo;
  String? tipoDisp;
  String? numSerie;
  String? numPatrimonio;
  final Key key = UniqueKey();

  ItemUnidade({
    this.idTipoDispositivo,
    required this.tipoDisp,
    required this.numSerie,
    this.numPatrimonio,
  });
}