import '../../domain/models/estudante.dart';

final List<Estudante> estudantesMock = [
  const Estudante(
    id: 'est-001',
    nome: 'Daniel Silva',
    email: 'daniel.silva@aluno.univesp.br',
    telefone: '(11) 98888-7777',
    cidade: 'São Paulo',
    estado: 'SP',
  ),
  const Estudante(
    id: 'est-002',
    nome: 'Maria Oliveira',
    email: 'maria.oliveira@email.com',
    telefone: '(21) 97777-6666',
    cidade: 'Rio de Janeiro',
    estado: 'RJ',
  ),
];
