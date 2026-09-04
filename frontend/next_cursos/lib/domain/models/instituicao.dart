class Instituicao {
  final String id;
  final String nome;
  final String email;
  final String? cnpj;
  final String? telefone;
  final String? site;
  final String? cidade;
  final String? estado;

  const Instituicao({
    required this.id,
    required this.nome,
    required this.email,
    this.cnpj,
    this.telefone,
    this.site,
    this.cidade,
    this.estado,
  });

  Instituicao copyWith({
    String? id,
    String? nome,
    String? email,
    String? cnpj,
    String? telefone,
    String? site,
    String? cidade,
    String? estado,
  }) {
    return Instituicao(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      cnpj: cnpj ?? this.cnpj,
      telefone: telefone ?? this.telefone,
      site: site ?? this.site,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'cnpj': cnpj,
      'telefone': telefone,
      'site': site,
      'cidade': cidade,
      'estado': estado,
    };
  }

  factory Instituicao.fromMap(Map<String, dynamic> map) {
    return Instituicao(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      cnpj: map['cnpj'],
      telefone: map['telefone'],
      site: map['site'],
      cidade: map['cidade'],
      estado: map['estado'],
    );
  }
}