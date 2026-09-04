import 'alternativa.dart';

class Questao {
  final String id;
  final String enunciado;
  final List<Alternativa>? alternativas;
  final double peso;

  const Questao({
    required this.id,
    required this.enunciado,
    this.alternativas,
    this.peso = 1.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'enunciado': enunciado,
      'alternativas': alternativas?.map((x) => x.toMap()).toList(),
      'peso': peso,
    };
  }

  factory Questao.fromMap(Map<String, dynamic> map) {
    return Questao(
      id: map['id'] ?? '',
      enunciado: map['enunciado'] ?? '',
      alternativas: map['alternativas'] != null
          ? List<Alternativa>.from(
              map['alternativas']?.map((x) => Alternativa.fromMap(x)))
          : null,
      peso: (map['peso'] ?? 1.0).toDouble(),
    );
  }
}
