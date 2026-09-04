import '../../../shared/models/enums.dart';

class Inscricao {
  final String id;
  final String estudanteId;
  final String oportunidadeId;
  final DateTime dataInscricao;
  final StatusInscricao status;
  final String? comprovanteRendaUrl;
  final String? historicoEscolarUrl;

  const Inscricao({
    required this.id,
    required this.estudanteId,
    required this.oportunidadeId,
    required this.dataInscricao,
    required this.status,
    this.comprovanteRendaUrl,
    this.historicoEscolarUrl,
  });

  Inscricao copyWith({
    String? id,
    String? estudanteId,
    String? oportunidadeId,
    DateTime? dataInscricao,
    StatusInscricao? status,
    String? comprovanteRendaUrl,
    String? historicoEscolarUrl,
  }) {
    return Inscricao(
      id: id ?? this.id,
      estudanteId: estudanteId ?? this.estudanteId,
      oportunidadeId: oportunidadeId ?? this.oportunidadeId,
      dataInscricao: dataInscricao ?? this.dataInscricao,
      status: status ?? this.status,
      comprovanteRendaUrl: comprovanteRendaUrl ?? this.comprovanteRendaUrl,
      historicoEscolarUrl: historicoEscolarUrl ?? this.historicoEscolarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'estudanteId': estudanteId,
      'oportunidadeId': oportunidadeId,
      'dataInscricao': dataInscricao.toIso8601String(),
      'status': status.name,
      'comprovanteRendaUrl': comprovanteRendaUrl,
      'historicoEscolarUrl': historicoEscolarUrl,
    };
  }

  factory Inscricao.fromMap(Map<String, dynamic> map) {
    return Inscricao(
      id: map['id'] ?? '',
      estudanteId: map['estudanteId'] ?? '',
      oportunidadeId: map['oportunidadeId'] ?? '',
      dataInscricao: DateTime.parse(map['dataInscricao']),
      status: StatusInscricao.values.byName(
        map['status'] ?? StatusInscricao.pendente.name,
      ),
      comprovanteRendaUrl: map['comprovanteRendaUrl'],
      historicoEscolarUrl: map['historicoEscolarUrl'],
    );
  }
}
