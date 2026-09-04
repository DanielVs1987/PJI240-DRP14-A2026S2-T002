class Alternativa {
  final String id;
  final String texto;
  final bool ehCorreta;

  const Alternativa({
    required this.id,
    required this.texto,
    required this.ehCorreta,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'texto': texto,
      'ehCorreta': ehCorreta,
    };
  }

  factory Alternativa.fromMap(Map<String, dynamic> map) {
    return Alternativa(
      id: map['id'] ?? '',
      texto: map['texto'] ?? '',
      ehCorreta: map['ehCorreta'] ?? false,
    );
  }
}
