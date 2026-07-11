import 'package:gardien_tech/domain/entities/dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_dispositivo.dart';
import 'package:gardien_tech/domain/entities/emprestimo_item.dart';

class EmprestimoItemComDispositivoDTO {
  final EmprestimoItem item;
  final List<EmprestimoDispositivo> dispositivos;
  final List<Dispositivo> dispositivosObj;

  EmprestimoItemComDispositivoDTO(this.item, this.dispositivos, this.dispositivosObj);
}