import '../../../shared/models/enums.dart';
import 'questao.dart';

class Avaliacao {
  final String id;
  final String processoSeletivoId;
  final String titulo;
  final String? descricao;
  final TipoAvaliacao tipo;
  final List<Questao> questoes;
  final double notaMinima;

  const Avaliacao({
    required this.id,
    required this.processoSeletivoId,
    required this.titulo,
    this.descricao,
    required this.tipo,
    required this.questoes,
    this.notaMinima = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'processoSeletivoId': processoSeletivoId,
      'titulo': titulo,
      'descricao': descricao,
      'tipo': tipo.name,
      'questoes': questoes.map((x) => x.toMap()).toList(),
      'notaMinima': notaMinima,
    };
  }

  factory Avaliacao.fromMap(Map<String, dynamic> map) {
    return Avaliacao(
      id: map['id'] ?? '',
      processoSeletivoId: map['processoSeletivoId'] ?? '',
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'],
      tipo: TipoAvaliacao.values.byName(
        map['tipo'] ?? TipoAvaliacao.provaObjetiva.name,
      ),
      questoes: List<Questao>.from(
          map['questoes']?.map((x) => Questao.fromMap(x)) ?? []),
      notaMinima: (map['notaMinima'] ?? 0.0).toDouble(),
    );
  }
}
