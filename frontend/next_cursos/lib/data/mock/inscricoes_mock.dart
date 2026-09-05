import '../../features/inscricoes/models/inscricao.dart';
import '../../shared/models/enums.dart';

final List<Inscricao> inscricoesMock = [
  Inscricao(
    id: 'ins-001',
    estudanteId: 'est-001',
    oportunidadeId: 'op-001',
    dataInscricao: DateTime(2026, 8, 5),
    status: StatusInscricao.emAnalise,
    comprovanteRendaUrl: 'https://storage.example.com/renda_est001.pdf',
    historicoEscolarUrl: 'https://storage.example.com/historico_est001.pdf',
  ),
  Inscricao(
    id: 'ins-002',
    estudanteId: 'est-001',
    oportunidadeId: 'op-002',
    dataInscricao: DateTime(2026, 8, 20),
    status: StatusInscricao.inscrita,
  ),
  Inscricao(
    id: 'ins-003',
    estudanteId: 'est-002',
    oportunidadeId: 'op-003',
    dataInscricao: DateTime(2026, 8, 25),
    status: StatusInscricao.pendente,
  ),
  Inscricao(
    id: 'ins-004',
    estudanteId: 'est-002',
    oportunidadeId: 'op-001',
    dataInscricao: DateTime(2026, 8, 25),
    status: StatusInscricao.aprovado,
  ),

];
