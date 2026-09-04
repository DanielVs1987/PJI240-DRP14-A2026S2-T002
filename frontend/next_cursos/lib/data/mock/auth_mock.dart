enum UserType { estudante, instituicao }

class AuthCredentialMock {
  final String email;
  final String password;
  final String userId;
  final UserType type;

  const AuthCredentialMock({
    required this.email,
    required this.password,
    required this.userId,
    required this.type,
  });
}

final List<AuthCredentialMock> authCredentialsMock = [
  const AuthCredentialMock(
    email: 'daniel.silva@aluno.univesp.br',
    password: '123456',
    userId: 'est-001',
    type: UserType.estudante,
  ),
  const AuthCredentialMock(
    email: 'maria.oliveira@email.com',
    password: 'password123',
    userId: 'est-002',
    type: UserType.estudante,
  ),
  const AuthCredentialMock(
    email: 'contato@alpha.edu.br',
    password: 'admin123',
    userId: 'inst-001',
    type: UserType.instituicao,
  ),
  const AuthCredentialMock(
    email: 'secretaria@cti.org.br',
    password: 'cti_password',
    userId: 'inst-002',
    type: UserType.instituicao,
  ),
];
