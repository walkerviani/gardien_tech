import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_item.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';
import 'package:gardien_tech/domain/enum/tipo_dispositivo.dart';
import 'package:gardien_tech/domain/repositories/dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_dispositivo_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_item_repository.dart';
import 'package:gardien_tech/domain/repositories/emprestimo_repository.dart';
import 'package:gardien_tech/domain/repositories/usuario_repository.dart';

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
  List<Dispositivo> opcoesUnidade = [];
  List<Usuario> opcoesResponsavel = [];
  Usuario? responsavelSelecionado;
  String? erroBusca;

  final TextEditingController responsavelController = TextEditingController();
  final TextEditingController pesquisaController = TextEditingController();

  Timer? _debounce;
  Timer? _debounceResponsavel;

  final DispositivoRepository dispositivoRepository;
  final UsuarioRepository usuarioRepository;
  final EmprestimoRepository emprestimoRepository;
  final EmprestimoItemRepository emprestimoItemRepository;
  final EmprestimoDispositivoRepository emprestimoDispositivoRepository;

  EmprestimoFormViewModel({
    required this.dispositivoRepository,
    required this.usuarioRepository,
    required this.emprestimoRepository,
    required this.emprestimoItemRepository,
    required this.emprestimoDispositivoRepository,
  });

  void alternarOpcao(OpcaoEmprestimo novaOpcao) {
    opcaoView = novaOpcao;
    notifyListeners();
  }

  void adicionarItemQuantidade() {
    itensQuantidade.add(
      ItemQuantidade(
        tipoDisp: '',
        quantidade: TextEditingController(),
      ),
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
    itensQuantidade[index].tipoDisp = novoTipo ?? itensQuantidade[index].tipoDisp;
    notifyListeners();
  }

  void atualizarAvisoQuantidade(int index, int quantidade) {
    itensQuantidade[index].mostrarAviso = quantidade >= 100;
    notifyListeners();
  }

  void buscarResponsavel(String value) {
    _debounceResponsavel?.cancel();

    if (responsavelSelecionado != null && value != responsavelSelecionado!.nome) {
      responsavelSelecionado = null;
    }

    if (value.trim().isEmpty) {
      opcoesResponsavel = [];
      notifyListeners();
      return;
    }

    _debounceResponsavel = Timer(const Duration(milliseconds: 200), () async {
      final resultado = await usuarioRepository.buscarNome(value);
      opcoesResponsavel = resultado;
      notifyListeners();
    });
  }

  void selecionarResponsavel(Usuario usuario) {
    responsavelSelecionado = usuario;
    responsavelController.text = usuario.nome;
    opcoesResponsavel = [];
    notifyListeners();
  }

  void buscarDispositivo(String value) {
    _debounce?.cancel();

    if (erroBusca != null) {
      erroBusca = null;
    }

    if (value.trim().isEmpty) {
      opcoesUnidade = [];
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 200), () async {
      final resultado = await dispositivoRepository.buscarDescricao(value);
      opcoesUnidade = resultado;
      notifyListeners();
    });
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
        tipoDisp: dispositivo.tipo.nomeTipo,
        numSerie: dispositivo.numSerie,
        numPatrimonio: dispositivo.numPatrimonio,
      ),
    );

    opcoesUnidade = [];
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
        if (item.quantidade.text.trim().isEmpty || item.quantidade.text == '0') {
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
    _debounce?.cancel();
    _debounceResponsavel?.cancel();

    for (final item in itensQuantidade) {
      item.quantidade.dispose();
    }

    super.dispose();
  }

  Future<void> confirmar() async {
    final emprestimo = Emprestimo(null, responsavelSelecionado!.id!);
    final idEmprestimo = await emprestimoRepository.criar(emprestimo);

    try {
      if (opcaoView == OpcaoEmprestimo.quantidade) {
        await _criarItensQuantidade(idEmprestimo);
      } else {
        await _criarItensUnidade(idEmprestimo);
      }
    } catch (e) {
      // Se algo falhar, deleta o empréstimo inteiro
      await emprestimoRepository.deletar(idEmprestimo);
      rethrow;
    }
  }

  Future<void> _criarItensQuantidade(int idEmprestimo) async {
    for (final item in itensQuantidade) {
      final tipoDisp = TipoDispositivo.values.firstWhere(
        (t) => t.nomeTipo == item.tipoDisp,
      );
      final emprestimoItem = EmprestimoItem(
        null,
        idEmprestimo,
        tipoDisp.id,
        int.parse(item.quantidade.text),
        true, // ehQuantitativo
        estaResolvido: false,
      );
      await emprestimoItemRepository.criar(emprestimoItem);
    }
  }

  Future<void> _criarItensUnidade(int idEmprestimo) async {
    final porTipo = <String, List<ItemUnidade>>{};
    for (final item in itensUnidade) {
      porTipo.putIfAbsent(item.tipoDisp!, () => []).add(item);
    }

    for (final entry in porTipo.entries) {
      final tipoDisp = TipoDispositivo.values.firstWhere(
        (t) => t.nomeTipo == entry.key,
      );
      await emprestimoItemRepository.criar(
        EmprestimoItem(
          null,
          idEmprestimo,
          tipoDisp.id,
          entry.value.length,
          false,
          estaResolvido: false,
        ),
      );

      for (final item in entry.value) {
        final dispositivo = await dispositivoRepository.buscarPorPatrimonio(
          item.numPatrimonio!,
        );
        if (dispositivo != null) {
          await emprestimoItemRepository.vincularDispositivo(
            idEmprestimo,
            dispositivo.id!,
          );
        }
      }
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
  String? tipoDisp;
  String? numSerie;
  String? numPatrimonio;
  final Key key = UniqueKey();

  ItemUnidade({
    required this.tipoDisp,
    required this.numSerie,
    this.numPatrimonio,
  });
}