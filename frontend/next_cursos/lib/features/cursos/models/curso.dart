import '../../../shared/models/enums.dart';

class Curso {
  final String id;
  final String instituicaoId;
  final String nome;
  final String descricao;
  final String areaConhecimento;
  final ModalidadeCurso modalidade;
  final int? cargaHoraria;
  final int? duracaoMeses;
  final String? imagemUrl;
  final bool ativo;

  const Curso({
    required this.id,
    required this.instituicaoId,
    required this.nome,
    required this.descricao,
    required this.areaConhecimento,
    required this.modalidade,
    this.cargaHoraria,
    this.duracaoMeses,
    this.imagemUrl,
    this.ativo = true,
  });

  Curso copyWith({
    String? id,
    String? instituicaoId,
    String? nome,
    String? descricao,
    String? areaConhecimento,
    ModalidadeCurso? modalidade,
    int? cargaHoraria,
    int? duracaoMeses,
    String? imagemUrl,
    bool? ativo,
  }) {
    return Curso(
      id: id ?? this.id,
      instituicaoId: instituicaoId ?? this.instituicaoId,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      areaConhecimento: areaConhecimento ?? this.areaConhecimento,
      modalidade: modalidade ?? this.modalidade,
      cargaHoraria: cargaHoraria ?? this.cargaHoraria,
      duracaoMeses: duracaoMeses ?? this.duracaoMeses,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      ativo: ativo ?? this.ativo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'instituicaoId': instituicaoId,
      'nome': nome,
      'descricao': descricao,
      'areaConhecimento': areaConhecimento,
      'modalidade': modalidade.name,
      'cargaHoraria': cargaHoraria,
      'duracaoMeses': duracaoMeses,
      'imagemUrl': imagemUrl,
      'ativo': ativo,
    };
  }

  factory Curso.fromMap(Map<String, dynamic> map) {
    return Curso(
      id: map['id'] ?? '',
      instituicaoId: map['instituicaoId'] ?? '',
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      areaConhecimento: map['areaConhecimento'] ?? '',
      modalidade: ModalidadeCurso.values.byName(
        map['modalidade'] ?? ModalidadeCurso.presencial.name,
      ),
      cargaHoraria: map['cargaHoraria'],
      duracaoMeses: map['duracaoMeses'],
      imagemUrl: map['imagemUrl'],
      ativo: map['ativo'] ?? true,
    );
  }
}
