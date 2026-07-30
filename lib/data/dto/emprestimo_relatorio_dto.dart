import 'package:gardien_tech/data/dto/emprestimo_com_detalhes_dto.dart';
import 'package:gardien_tech/data/dto/emprestimo_item_com_dispositivo_dto.dart';

class EmprestimoRelatorioDTO {
  final EmprestimoComDetalhesDTO emprestimo;
  final List<EmprestimoItemComDispositivoDTO> itens;

  EmprestimoRelatorioDTO(this.emprestimo, this.itens);
}
