class Resposta {
  final String id;
  final String inscricaoId;
  final String avaliacaoId;
  final String questaoId;
  final String? alternativaId; // Para questões objetivas
  final String? textoResposta; // Para questões dissertativas
  final double? notaAtribuida;

  const Resposta({
    required this.id,
    required this.inscricaoId,
    required this.avaliacaoId,
    required this.questaoId,
    this.alternativaId,
    this.textoResposta,
    this.notaAtribuida,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'inscricaoId': inscricaoId,
      'avaliacaoId': avaliacaoId,
      'questaoId': questaoId,
      'alternativaId': alternativaId,
      'textoResposta': textoResposta,
      'notaAtribuida': notaAtribuida,
    };
  }

  factory Resposta.fromMap(Map<String, dynamic> map) {
    return Resposta(
      id: map['id'] ?? '',
      inscricaoId: map['inscricaoId'] ?? '',
      avaliacaoId: map['avaliacaoId'] ?? '',
      questaoId: map['questaoId'] ?? '',
      alternativaId: map['alternativaId'],
      textoResposta: map['textoResposta'],
      notaAtribuida: (map['notaAtribuida'])?.toDouble(),
    );
  }
}
