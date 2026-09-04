class ProcessoSeletivo {
  final String id;
  final String oportunidadeId;
  final List<String> etapasIds;
  final DateTime dataInicio;
  final DateTime dataFim;
  final bool ativo;

  const ProcessoSeletivo({
    required this.id,
    required this.oportunidadeId,
    required this.etapasIds,
    required this.dataInicio,
    required this.dataFim,
    this.ativo = true,
  });

  ProcessoSeletivo copyWith({
    String? id,
    String? oportunidadeId,
    List<String>? etapasIds,
    DateTime? dataInicio,
    DateTime? dataFim,
    bool? ativo,
  }) {
    return ProcessoSeletivo(
      id: id ?? this.id,
      oportunidadeId: oportunidadeId ?? this.oportunidadeId,
      etapasIds: etapasIds ?? this.etapasIds,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      ativo: ativo ?? this.ativo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'oportunidadeId': oportunidadeId,
      'etapasIds': etapasIds,
      'dataInicio': dataInicio.toIso8601String(),
      'dataFim': dataFim.toIso8601String(),
      'ativo': ativo,
    };
  }

  factory ProcessoSeletivo.fromMap(Map<String, dynamic> map) {
    return ProcessoSeletivo(
      id: map['id'] ?? '',
      oportunidadeId: map['oportunidadeId'] ?? '',
      etapasIds: List<String>.from(map['etapasIds'] ?? []),
      dataInicio: DateTime.parse(map['dataInicio']),
      dataFim: DateTime.parse(map['dataFim']),
      ativo: map['ativo'] ?? true,
    );
  }
}
