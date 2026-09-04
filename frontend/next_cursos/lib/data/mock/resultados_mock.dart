import '../../features/resultados/models/resultado_selecao.dart';
import '../../shared/models/enums.dart';

final List<ResultadoSelecao> resultadosMock = [
  ResultadoSelecao(
    id: 'res-001',
    inscricaoId: 'ins-001',
    processoSeletivoId: 'ps-001',
    notaFinal: 8.5,
    classificacao: 1,
    status: StatusResultado.aprovado,
    dataPublicacao: DateTime(2026, 8, 30),
  ),
  ResultadoSelecao(
    id: 'res-002',
    inscricaoId: 'ins-002',
    processoSeletivoId: 'ps-002',
    notaFinal: 7.0,
    classificacao: 5,
    status: StatusResultado.listaEspera,
    dataPublicacao: DateTime(2026, 8, 30),
  ),
];
