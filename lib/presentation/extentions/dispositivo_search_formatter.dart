import 'package:gardien_tech/domain/entities/dispositivo.dart';

/// Formatação de exibição do Dispositivo usada na tela de busca.
/// Fica fora da entidade porque é responsabilidade de apresentação, não de domínio.
extension DispositivoSearchFormatter on Dispositivo {
  String get descricaoBusca => '$numPatrimonio - ${tipo.nomeTipo} - $numSerie';
}