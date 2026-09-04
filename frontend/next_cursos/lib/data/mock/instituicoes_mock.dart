import '../../domain/models/instituicao.dart';

final List<Instituicao> instituicoesMock = [
  const Instituicao(
    id: 'inst-001',
    nome: 'Universidade Tecnológica Alpha',
    email: 'contato@alpha.edu.br',
    cnpj: '12.345.678/0001-90',
    telefone: '(11) 3333-4444',
    site: 'www.alpha.edu.br',
    cidade: 'São Paulo',
    estado: 'SP',
  ),
  const Instituicao(
    id: 'inst-002',
    nome: 'Centro de Tecnologia e Inovação',
    email: 'secretaria@cti.org.br',
    cnpj: '98.765.432/0001-21',
    telefone: '(19) 3232-1010',
    site: 'www.cti.org.br',
    cidade: 'Campinas',
    estado: 'SP',
  ),
  const Instituicao(
    id: 'inst-003',
    nome: 'Escola de Gestão e Negócios',
    email: 'info@egn.edu.br',
    cnpj: '11.222.333/0001-44',
    telefone: '(21) 2525-8080',
    site: 'www.egn.edu.br',
    cidade: 'Rio de Janeiro',
    estado: 'RJ',
  ),
];
