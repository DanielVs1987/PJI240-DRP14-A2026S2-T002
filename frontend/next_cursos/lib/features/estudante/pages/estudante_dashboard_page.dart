import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_cursos/shared/widgets/build_footer.dart';
import 'package:next_cursos/shared/widgets/divisor_barra.dart';
import '../../../core/theme/theme.dart';
import '../../../data/mock/auth_mock.dart';
import '../../../data/mock/estudantes_mock.dart';
import '../../../data/mock/inscricoes_mock.dart';
import '../../../data/mock/oportunidades_mock.dart';
import '../../../shared/models/enums.dart';
import '../../oportunidades/models/oportunidade.dart';
import '../../inscricoes/models/inscricao.dart';
import '../../../shared/widgets/nome_app.dart';
import '../../../core/auth/auth_service.dart';
import '../../../app/app_routes.dart';
import '../../../domain/models/estudante.dart';
import '../../oportunidades/pages/oportunidades_list_page.dart';

class EstudanteDashboardPage extends StatefulWidget {
  const EstudanteDashboardPage({super.key});

  @override
  State<EstudanteDashboardPage> createState() => _EstudanteDashboardPageState();
}

class _EstudanteDashboardPageState extends State<EstudanteDashboardPage> {
  late final Estudante estudante;

  AuthCredentialMock? authUser;

  @override
  void initState() {
    super.initState();
    authUser = AuthService().currentUser;
    estudante = estudantesMock.firstWhere((e) => e.id == authUser?.userId);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 800;

    // Filtra inscrições do estudante logado
    final minhasInscricoes = inscricoesMock
        .where((i) => i.estudanteId == estudante.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: nomeApp(context),
        elevation: 1,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.oportunidadesLista,
                arguments: OportunidadesListArgs(
                  titulo: 'Cursos Gratuitos',
                  tipos: [
                    TipoOportunidade.cursoGratuito,
                    TipoOportunidade.bolsaIntegral,
                    TipoOportunidade.bolsaParcial,
                   // TipoOportunidade.processoSeletivo,
                  ],
                  authUser: authUser,
                ),
              );
            },
            child: Row(
              children: [

                const Icon(Icons.search_rounded, size: 28),
                SizedBox(width: 8),
                Text(isMobile ? '' : 'Encontre seu curso ideal'),
              ],
            ),
          ),
          divisorBarra(48),
          IconButton(
            onPressed: () {
              AuthService().logout();
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: AppColors.colors.outFocus,
            child: Text(
              estudante.nome[0],
              style: TextStyle(color: AppColors.colors.textPrimary),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildSummaryCards(minhasInscricoes),
                      const SizedBox(height: 40),
                      if (isMobile)
                        Column(
                          children: [
                            _buildInscricoesList(minhasInscricoes),
                            const SizedBox(height: 32),
                            _buildRecomendacoes(),
                          ],
                        )
                      else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildInscricoesList(minhasInscricoes),
                            ),
                            const SizedBox(width: 32),
                            Expanded(child: _buildRecomendacoes()),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [buildFooter()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Olá, ${estudante.nome.split(' ')[0]}!',
          style: AppTextStyles.titleLarge().copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.colors.textInBackGround,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Acompanhe suas inscrições e veja novas oportunidades.',
          style: AppTextStyles.titleSmall().copyWith(
            color: AppColors.colors.textInBackGround,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(List<Inscricao> inscricoes) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        _summaryCard(
          label: 'Total de Inscrições',
          value: inscricoes.length.toString(),
          icon: Icons.assignment_outlined,
          color: AppColors.colors.textPrimary,
        ),
        _summaryCard(
          label: 'Em Análise',
          value: inscricoes
              .where((i) => i.status == StatusInscricao.emAnalise)
              .length
              .toString(),
          icon: Icons.search_outlined,
          color: AppColors.colors.middleHighlights,
        ),
        _summaryCard(
          label: 'Aprovado',
          value: inscricoes
              .where((i) => i.status == StatusInscricao.aprovado)
              .length
              .toString(),
          icon: Icons.check_circle_outline,
          color: AppColors.colors.positiveHighlights,
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                style: AppTextStyles.titleSmall().copyWith(
                  color: AppColors.colors.outFocus,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInscricoesList(List<Inscricao> inscricoes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minhas Inscrições',
          style: AppTextStyles.titleMedium().copyWith(
            color: AppColors.colors.textInBackGround,
          ),
        ),
        const SizedBox(height: 20),
        if (inscricoes.isEmpty)
          Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'Você ainda não possui inscrições.',
                  style: AppTextStyles.titleMedium().copyWith(
                    color: AppColors.colors.textInBackGround,
                  ),
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: inscricoes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final inscricao = inscricoes[index];
              final oportunidade = oportunidadesMock.firstWhere(
                (o) => o.id == inscricao.oportunidadeId,
              );

              return _inscricaoCard(inscricao, oportunidade);
            },
          ),
      ],
    );
  }

  Widget _inscricaoCard(Inscricao inscricao, Oportunidade oportunidade) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.colors.outFocus),
      ),
      child: Row(
        children: [
          if (oportunidade.imagemUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/carousel_images/${oportunidade.imagemUrl}',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  oportunidade.titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Inscrito em: ${dateFormat.format(inscricao.dataInscricao)}',
                  style: AppTextStyles.titleSmall().copyWith(
                    color: AppColors.colors.outFocus,
                  ),
                ),
              ],
            ),
          ),
          _statusBadge(inscricao.status),
          const SizedBox(width: 12),
          IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right)),
        ],
      ),
    );
  }

  Widget _statusBadge(StatusInscricao status) {
    Color color;
    switch (status) {
      case StatusInscricao.emAnalise:
        color = AppColors.colors.middleHighlights;
        break;
      case StatusInscricao.aprovado:
        color = AppColors.colors.positiveHighlights;
        break;
      case StatusInscricao.inscrita:
        color = AppColors.colors.outFocus;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRecomendacoes() {
    final recomendacoes = oportunidadesMock
        .where((o) => o.destaque)
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recomendados',
          style: AppTextStyles.titleMedium().copyWith(
            color: AppColors.colors.textInBackGround,
          ),
        ),
        const SizedBox(height: 20),
        Column(
          children: recomendacoes.map((o) => _recomendacaoCard(o)).toList(),
        ),
      ],
    );
  }

  Widget _recomendacaoCard(Oportunidade oportunidade) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (oportunidade.imagemUrl != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),

                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/carousel_images/${oportunidade.imagemUrl}',
                    ),
                  ),
                ),
              ),
            ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  oportunidade.titulo,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  oportunidade.tipo.name,
                  style: TextStyle(
                    color: AppColors.colors.textPrimary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.oportunidadeDetalhe,
                      arguments: oportunidade,
                    );
                  },
                  child: const Text('Ver detalhes'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
