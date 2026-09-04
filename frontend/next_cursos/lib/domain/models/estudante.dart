class Estudante {
  final String id;
  final String nome;
  final String email;
  final String? telefone;
  final String? cidade;
  final String? estado;

  const Estudante({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
    this.cidade,
    this.estado,
  });

  Estudante copyWith({
    String? id,
    String? nome,
    String? email,
    String? telefone,
    String? cidade,
    String? estado,
  }) {
    return Estudante(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cidade': cidade,
      'estado': estado,
    };
  }

  factory Estudante.fromMap(Map<String, dynamic> map) {
    return Estudante(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'],
      cidade: map['cidade'],
      estado: map['estado'],
    );
  }
}