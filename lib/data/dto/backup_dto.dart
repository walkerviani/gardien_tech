import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_item.dart';
import 'package:gardien_tech/domain/entities/problema.dart';
import 'package:gardien_tech/domain/entities/usuario.dart';

class BackupDTO {
  final List<Usuario> usuarios;
  final List<Dispositivo> dispositivos;
  final List<Problema> problemas;
  final List<Emprestimo> emprestimos;
  final List<EmprestimoItem> emprestimoItens;
  final List<EmprestimoDispositivo> emprestimoDispositivos;

  BackupDTO({
    required this.usuarios,
    required this.dispositivos,
    required this.problemas,
    required this.emprestimos,
    required this.emprestimoItens,
    required this.emprestimoDispositivos,
  });

  Map<String, dynamic> toJson() {
    return {
      'usuarios': usuarios.map((e) => e.toJson()).toList(),
      'dispositivos': dispositivos.map((e) => e.toJson()).toList(),
      'problemas': problemas.map((e) => e.toJson()).toList(),
      'emprestimos': emprestimos.map((e) => e.toJson()).toList(),
      'emprestimoItens': emprestimoItens.map((e) => e.toJson()).toList(),
      'emprestimoDispositivos':
          emprestimoDispositivos.map((e) => e.toJson()).toList(),
    };
  }

  factory BackupDTO.fromJson(Map<String, dynamic> json) {
    return BackupDTO(
      usuarios: (json['usuarios'] as List)
          .map((e) => Usuario.fromJson(e))
          .toList(),

      dispositivos: (json['dispositivos'] as List)
          .map((e) => Dispositivo.fromJson(e))
          .toList(),

      problemas: (json['problemas'] as List)
          .map((e) => Problema.fromJson(e))
          .toList(),

      emprestimos: (json['emprestimos'] as List)
          .map((e) => Emprestimo.fromJson(e))
          .toList(),

      emprestimoItens: (json['emprestimoItens'] as List)
          .map((e) => EmprestimoItem.fromJson(e))
          .toList(),

      emprestimoDispositivos:
          (json['emprestimoDispositivos'] as List)
              .map((e) => EmprestimoDispositivo.fromJson(e))
              .toList(),
    );
  }
}