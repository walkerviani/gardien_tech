import 'package:gardien_tech/domain/entities/equipamento.dart';

class Emprestimo {
  // Atributos
  final int _id;
  DateTime dataHoraEfetuado;
  DateTime? dataHoraConcluido; 
  int quantidadeEmprestada;
  int quantidadeDevolvida; 
  List<Equipamento> equipamentos;

  // Construtor
  Emprestimo(
    this._id,
    this.quantidadeEmprestada,
    this.equipamentos,
    {DateTime? dataHoraEfetuado,
    this.dataHoraConcluido, // nullable, pois a conclusão pode não ter ocorrido ainda
    this.quantidadeDevolvida = 0 // inicia em zero, incrementado conforme devoluções
  }) : dataHoraEfetuado = dataHoraEfetuado ?? DateTime.now(); // initializer list — executa atribuições antes do corpo do construtor
    
  // Get
  int get id => _id;

  // Métodos
  int registrarDevolucao (int qtd){
    if (qtd > quantidadeEmprestada || qtd <= 0) return 1; // 1 — quantidade inválida
    if (quantidadeDevolvida >= quantidadeEmprestada) return 2; // 2 — empréstimo já concluído
    
    quantidadeDevolvida += qtd;
  
    concluirEmprestimo();
    return 0; // 0 — devolução realizada com sucesso
  }

  void concluirEmprestimo() {
    if (quantidadeDevolvida >= quantidadeEmprestada) dataHoraConcluido = DateTime.now();
  }
}