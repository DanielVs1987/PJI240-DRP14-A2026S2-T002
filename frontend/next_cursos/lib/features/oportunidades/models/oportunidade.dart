import '../../../shared/models/enums.dart';

class Oportunidade {
  final String id;
  final String cursoId;
  final String titulo;
  final String descricao;
  final TipoOportunidade tipo;
  final StatusOportunidade status;
  final DateTime dataInicioInscricao;
  final DateTime dataFimInscricao;
  final DateTime? dataInicioCurso;
  final int vagas;
  final double? percentualBolsa;
  final bool destaque;
  final String? requisitos;
  final String? editalUrl;
  final String? observacoes;
  final String? imagemUrl;
  final bool historicoEscolarObrigatorio;
  final bool comprovanteRendaObrigatorio;
  final bool possuiProcessoSeletivo;

  const Oportunidade({
    required this.id,
    required this.cursoId,
    required this.titulo,
    required this.descricao,
    required this.tipo,
    required this.status,
    required this.dataInicioInscricao,
    required this.dataFimInscricao,
    this.dataInicioCurso,
    required this.vagas,
    this.percentualBolsa,
    this.destaque = false,
    this.requisitos,
    this.editalUrl,
    this.observacoes,
    this.imagemUrl,
    required this.historicoEscolarObrigatorio,
    required this.comprovanteRendaObrigatorio,
    this.possuiProcessoSeletivo = false,
  });

  Oportunidade copyWith({
    String? id,
    String? cursoId,
    String? titulo,
    String? descricao,
    TipoOportunidade? tipo,
    StatusOportunidade? status,
    DateTime? dataInicioInscricao,
    DateTime? dataFimInscricao,
    DateTime? dataInicioCurso,
    int? vagas,
    double? percentualBolsa,
    bool? destaque,
    String? requisitos,
    String? editalUrl,
    String? observacoes,
    String? imagemUrl,
    bool? historicoEscolarObrigatorio,
    bool? comprovanteRendaObrigatorio,
    bool? possuiProcessoSeletivo,
  }) {
    return Oportunidade(
      id: id ?? this.id,
      cursoId: cursoId ?? this.cursoId,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      tipo: tipo ?? this.tipo,
      status: status ?? this.status,
      dataInicioInscricao: dataInicioInscricao ?? this.dataInicioInscricao,
      dataFimInscricao: dataFimInscricao ?? this.dataFimInscricao,
      dataInicioCurso: dataInicioCurso ?? this.dataInicioCurso,
      vagas: vagas ?? this.vagas,
      percentualBolsa: percentualBolsa ?? this.percentualBolsa,
      destaque: destaque ?? this.destaque,
      requisitos: requisitos ?? this.requisitos,
      editalUrl: editalUrl ?? this.editalUrl,
      observacoes: observacoes ?? this.observacoes,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      historicoEscolarObrigatorio:
          historicoEscolarObrigatorio ?? this.historicoEscolarObrigatorio,
      comprovanteRendaObrigatorio:
          comprovanteRendaObrigatorio ?? this.comprovanteRendaObrigatorio,
      possuiProcessoSeletivo:
          possuiProcessoSeletivo ?? this.possuiProcessoSeletivo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cursoId': cursoId,
      'titulo': titulo,
      'descricao': descricao,
      'tipo': tipo.name,
      'status': status.name,
      'dataInicioInscricao': dataInicioInscricao.toIso8601String(),
      'dataFimInscricao': dataFimInscricao.toIso8601String(),
      'dataInicioCurso': dataInicioCurso?.toIso8601String(),
      'vagas': vagas,
      'percentualBolsa': percentualBolsa,
      'destaque': destaque,
      'requisitos': requisitos,
      'editalUrl': editalUrl,
      'observacoes': observacoes,
      'imagemUrl': imagemUrl,
      'historicoEscolarObrigatorio': historicoEscolarObrigatorio,
      'comprovanteRendaObrigatorio': comprovanteRendaObrigatorio,
      'possuiProcessoSeletivo': possuiProcessoSeletivo,
    };
  }

  factory Oportunidade.fromMap(Map<String, dynamic> map) {
    return Oportunidade(
      id: map['id'] ?? '',
      cursoId: map['cursoId'] ?? '',
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      tipo: TipoOportunidade.values.byName(
        map['tipo'] ?? TipoOportunidade.cursoGratuito.name,
      ),
      status: StatusOportunidade.values.byName(
        map['status'] ?? StatusOportunidade.rascunho.name,
      ),
      dataInicioInscricao: DateTime.parse(map['dataInicioInscricao']),
      dataFimInscricao: DateTime.parse(map['dataFimInscricao']),
      dataInicioCurso: map['dataInicioCurso'] != null
          ? DateTime.parse(map['dataInicioCurso'])
          : null,
      vagas: map['vagas'] ?? 0,
      percentualBolsa: (map['percentualBolsa'])?.toDouble(),
      destaque: map['destaque'] ?? false,
      requisitos: map['requisitos'],
      editalUrl: map['editalUrl'],
      observacoes: map['observacoes'],
      imagemUrl: map['imagemUrl'] ?? '',
      historicoEscolarObrigatorio: map['historicoEscolarObrigatorio'] ?? false,
      comprovanteRendaObrigatorio: map['comprovanteRendaObrigatorio'] ?? false,
      possuiProcessoSeletivo: map['possuiProcessoSeletivo'] ?? false,
    );
  }
}
