import 'package:gardien_tech/domain/entities/problema.dart';

class Dispositivo {
  // Atributos
  final int _id;
  List<Problema> problemas;

  // Construtor
  Dispositivo(this._id, this.problemas);

  // Get
  int get id => _id;
}