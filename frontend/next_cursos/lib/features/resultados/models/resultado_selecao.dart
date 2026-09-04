import '../../../shared/models/enums.dart';

class ResultadoSelecao {
  final String id;
  final String inscricaoId;
  final String processoSeletivoId;
  final double notaFinal;
  final int classificacao;
  final StatusResultado status;
  final DateTime dataPublicacao;

  const ResultadoSelecao({
    required this.id,
    required this.inscricaoId,
    required this.processoSeletivoId,
    required this.notaFinal,
    required this.classificacao,
    required this.status,
    required this.dataPublicacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'inscricaoId': inscricaoId,
      'processoSeletivoId': processoSeletivoId,
      'notaFinal': notaFinal,
      'classificacao': classificacao,
      'status': status.name,
      'dataPublicacao': dataPublicacao.toIso8601String(),
    };
  }

  factory ResultadoSelecao.fromMap(Map<String, dynamic> map) {
    return ResultadoSelecao(
      id: map['id'] ?? '',
      inscricaoId: map['inscricaoId'] ?? '',
      processoSeletivoId: map['processoSeletivoId'] ?? '',
      notaFinal: (map['notaFinal'] ?? 0.0).toDouble(),
      classificacao: map['classificacao'] ?? 0,
      status: StatusResultado.values.byName(
        map['status'] ?? StatusResultado.reprovado.name,
      ),
      dataPublicacao: DateTime.parse(map['dataPublicacao']),
    );
  }
}
