import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_cursos/shared/widgets/divisor_barra.dart';

import '../../../app/app_routes.dart';
import '../../../core/auth/auth_service.dart';
import '../../../core/theme/theme.dart';
import '../../../data/mock/cursos_mock.dart';
import '../../../data/mock/estudantes_mock.dart';
import '../../../data/mock/inscricoes_mock.dart';
import '../../../data/mock/instituicoes_mock.dart';
import '../../../data/mock/oportunidades_mock.dart';
import '../../../domain/models/instituicao.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/widgets/build_footer.dart';
import '../../../shared/widgets/nome_app.dart';
import '../../inscricoes/models/inscricao.dart';
import '../../oportunidades/models/oportunidade.dart';
import '../../cursos/models/curso.dart';

class InstituicaoDashboardPage extends StatefulWidget {
  const InstituicaoDashboardPage({super.key});

  @override
  State<InstituicaoDashboardPage> createState() =>
      _InstituicaoDashboardPageState();
}

class _InstituicaoDashboardPageState extends State<InstituicaoDashboardPage> {
  late final Instituicao instituicao;

  @override
  void initState() {
    super.initState();

    final authUser = AuthService().currentUser;

    instituicao = instituicoesMock.firstWhere((i) => i.id == authUser?.userId);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 800;

    // Oportunidades pertencentes à instituição logada (através do Curso).
    final meusCursos =
        cursosMock.where((c) => c.instituicaoId == instituicao.id).toList();

    final meusCursosIds = meusCursos.map((c) => c.id).toSet();

    final minhasOportunidades = oportunidadesMock
        .where((o) => meusCursosIds.contains(o.cursoId))
        .toList();

    // IDs das oportunidades da instituição.
    final idsMinhasOportunidades = minhasOportunidades.map((o) => o.id).toSet();

    // Inscrições recebidas nessas oportunidades.
    final inscricoesRecebidas = inscricoesMock
        .where((i) => idsMinhasOportunidades.contains(i.oportunidadeId))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: nomeApp(context),
        elevation: 1,
        actions: [
          !isMobile
              ? Row(
                  children: [
                    TextButton.icon(
                      onPressed: _novoCurso,
                      icon: const Icon(Icons.book_outlined),
                      label: const Text('Cadastrar curso'),
                    ),
                    TextButton.icon(
                      onPressed: _novaOportunidade,
                      icon: const Icon(Icons.add),
                      label: const Text('Nova oportunidade'),
                    ),
                  ],
                )
              : PopupMenuButton(
                  icon: const Icon(Icons.menu_rounded),

                  onSelected: (value) {
                    switch (value) {
                      case 'novoCurso':
                        _novoCurso();
                        break;

                      case 'novaOportunidade':
                        _novaOportunidade();
                        break;

                      case 'logout':
                        AuthService().logout();
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.home);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'novoCurso',
                      child: Row(
                        children: [
                          Icon(
                            Icons.book_outlined,
                            color: AppColors.colors.textPrimary,
                          ),
                          SizedBox(width: 12),
                          Text('Cadastrar curso'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'novaOportunidade',
                      child: Row(
                        children: [
                          Icon(Icons.add, color: AppColors.colors.textPrimary),
                          SizedBox(width: 12),
                          Text('Nova oportunidade'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: AppColors.colors.textPrimary,
                          ),
                          SizedBox(width: 12),
                          Text('Sair'),
                        ],
                      ),
                    ),
                  ],
                ),

          if (!isMobile) const SizedBox(width: 12),
          if (!isMobile)
            IconButton(
              tooltip: 'Sair',
              onPressed: () {
                AuthService().logout();

                Navigator.of(context).pushReplacementNamed(AppRoutes.home);
              },
              icon: const Icon(Icons.logout),
            ),

          divisorBarra(40),
          SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: AppColors.colors.outFocus,
            child: Icon(
              Icons.business_outlined,
              color: AppColors.colors.textPrimary,
            ),
          ),

          const SizedBox(width: 20),
        ],
      ),

      floatingActionButton: isMobile
          ? FloatingActionButton.extended(
              onPressed: _novaOportunidade,
              icon: const Icon(Icons.add),
              label: const Text('Nova oportunidade'),
            )
          : null,

      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 8 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),

                      const SizedBox(height: 32),

                      _buildSummaryCards(
                        minhasOportunidades,
                        inscricoesRecebidas,
                      ),

                      const SizedBox(height: 40),

                      if (isMobile)
                        Column(
                          children: [
                            _buildCursosList(meusCursos),
                            const SizedBox(height: 32),
                            _buildOportunidadesList(
                              minhasOportunidades,
                              inscricoesRecebidas,
                            ),
                            const SizedBox(height: 32),
                            _buildRecentInscricoes(inscricoesRecebidas),
                          ],
                        )
                      else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  _buildCursosList(meusCursos),
                                  const SizedBox(height: 32),
                                  _buildOportunidadesList(
                                    minhasOportunidades,
                                    inscricoesRecebidas,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              child: _buildRecentInscricoes(
                                inscricoesRecebidas,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 32),
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

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                instituicao.nome,
                style: AppTextStyles.titleLarge().copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.colors.textInBackGround,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.colors.primary.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'INSTITUIÇÃO',
                style: TextStyle(
                  color: AppColors.colors.textPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          'Gerencie suas oportunidades e acompanhe as inscrições recebidas.',
          style: AppTextStyles.titleSmall().copyWith(
            color: AppColors.colors.textInBackGround,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Cards resumo
  // ---------------------------------------------------------------------------

  Widget _buildSummaryCards(
    List<Oportunidade> oportunidades,
    List<Inscricao> inscricoes,
  ) {
    final aguardandoAnalise = inscricoes
        .where(
          (i) =>
              i.status == StatusInscricao.pendente ||
              i.status == StatusInscricao.emAnalise,
        )
        .length;

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        _summaryCard(
          label: 'Oportunidades',
          value: oportunidades.length.toString(),
          icon: Icons.campaign_outlined,
          color: AppColors.colors.textPrimary,
        ),

        _summaryCard(
          label: 'Total de Inscritos',
          value: inscricoes.length.toString(),
          icon: Icons.people_outline,
          color: AppColors.colors.positiveHighlights,
        ),

        _summaryCard(
          label: 'Aguardando Análise',
          value: aguardandoAnalise.toString(),
          icon: Icons.search_outlined,
          color: AppColors.colors.middleHighlights,
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
            color: AppColors.colors.shadow.withValues(alpha: 0.04),
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

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colors.textPrimary,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSmall().copyWith(
                    color: AppColors.colors.outFocus,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Gestão dos cursos
  // ---------------------------------------------------------------------------

  Widget _buildCursosList(List<Curso> cursos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Gestão de Cursos',
                style: AppTextStyles.titleMedium().copyWith(
                  color: AppColors.colors.textInBackGround,
                ),
              ),
            ),
            Text(
              '${cursos.length} cadastrados',
              style: AppTextStyles.titleSmall().copyWith(
                color: AppColors.colors.textInBackGround,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (cursos.isEmpty)
          _buildEmptyCursos()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cursos.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final curso = cursos[index];
              return _cursoCard(curso);
            },
          ),
      ],
    );
  }

  Widget _buildEmptyCursos() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.colors.outFocus),
      ),
      child: Column(
        children: [
          Icon(
            Icons.book_outlined,
            size: 42,
            color: AppColors.colors.outFocus,
          ),
          const SizedBox(height: 12),
          Text(
            'Nenhum curso cadastrado.',
            textAlign: TextAlign.center,
            style: AppTextStyles.titleMedium().copyWith(
              color: AppColors.colors.textInBackGround,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cadastre seus cursos para poder criar oportunidades vinculadas a eles.',
            textAlign: TextAlign.center,
            style: AppTextStyles.titleSmall(),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: _novoCurso,
            icon: const Icon(Icons.add),
            label: const Text('Cadastrar curso'),
          ),
        ],
      ),
    );
  }

  Widget _cursoCard(Curso curso) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.colors.outFocus),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.colors.textPrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Icon(Icons.book_outlined, color: AppColors.colors.textPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  curso.nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${curso.areaConhecimento} • ${_formatarModalidade(curso.modalidade.name)}',
                  style: AppTextStyles.titleSmall()
                      .copyWith(color: AppColors.colors.outFocus),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          _statusAtivoBadge(curso.ativo),
          const SizedBox(width: 8),
          _menuCurso(curso),
        ],
      ),
    );
  }

  Widget _statusAtivoBadge(bool ativo) {
    final color = ativo ? Colors.green : Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        ativo ? 'ATIVO' : 'INATIVO',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _menuCurso(Curso curso) {
    return PopupMenuButton<String>(
      tooltip: 'Opções',
      icon: Icon(Icons.more_vert, color: AppColors.colors.textInBackGround),
      onSelected: (value) {
        switch (value) {
          case 'editar':
            Navigator.pushNamed(
              context,
              AppRoutes.cursoFormulario,
              arguments: curso,
            );
            break;
          case 'deletar':
            // Mock de exclusão/desativação
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'editar',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, color: AppColors.colors.textPrimary),
              const SizedBox(width: 12),
              const Text('Editar'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'deletar',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              const SizedBox(width: 12),
              const Text('Deletar', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  String _formatarModalidade(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  // ---------------------------------------------------------------------------
  // Gestão das oportunidades
  // ---------------------------------------------------------------------------

  Widget _buildOportunidadesList(
    List<Oportunidade> oportunidades,
    List<Inscricao> inscricoes,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Gestão de Oportunidades',
                style: AppTextStyles.titleMedium().copyWith(
                  color: AppColors.colors.textInBackGround,
                ),
              ),
            ),

            Text(
              '${oportunidades.length} publicadas',
              style: AppTextStyles.titleSmall().copyWith(
                color: AppColors.colors.textInBackGround,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        if (oportunidades.isEmpty)
          _buildEmptyOportunidades()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: oportunidades.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final oportunidade = oportunidades[index];

              final totalInscritos = inscricoes
                  .where((i) => i.oportunidadeId == oportunidade.id)
                  .length;

              return _oportunidadeCard(oportunidade, totalInscritos);
            },
          ),
      ],
    );
  }

  Widget _buildEmptyOportunidades() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.colors.outFocus),
      ),
      child: Column(
        children: [
          Icon(
            Icons.campaign_outlined,
            size: 42,
            color: AppColors.colors.outFocus,
          ),

          const SizedBox(height: 12),

          Text(
            'Nenhuma oportunidade publicada.',
            textAlign: TextAlign.center,
            style: AppTextStyles.titleMedium().copyWith(
              color: AppColors.colors.textInBackGround,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Crie sua primeira oportunidade para começar a receber inscrições.',
            textAlign: TextAlign.center,
            style: AppTextStyles.titleSmall(),
          ),

          const SizedBox(height: 20),

          OutlinedButton.icon(
            onPressed: _novaOportunidade,
            icon: const Icon(Icons.add),
            label: const Text('Criar oportunidade'),
          ),
        ],
      ),
    );
  }

  Widget _oportunidadeCard(Oportunidade oportunidade, int totalInscritos) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.colors.outFocus),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 620;

          if (compact) {
            return _buildOportunidadeCompacta(oportunidade, totalInscritos);
          }

          return _buildOportunidadeDesktop(oportunidade, totalInscritos);
        },
      ),
    );
  }

  Widget _buildOportunidadeDesktop(
    Oportunidade oportunidade,
    int totalInscritos,
  ) {
    return Row(
      children: [
        _oportunidadeIcon(),

        const SizedBox(width: 16),

        Expanded(child: _oportunidadeInfo(oportunidade)),

        const SizedBox(width: 20),

        _inscritosInfo(totalInscritos),

        const SizedBox(width: 20),

        _statusBadge(oportunidade.status),

        const SizedBox(width: 8),

        _menuOportunidade(oportunidade),
      ],
    );
  }

  Widget _buildOportunidadeCompacta(
    Oportunidade oportunidade,
    int totalInscritos,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _oportunidadeIcon(),

            const SizedBox(width: 14),

            Expanded(child: _oportunidadeInfo(oportunidade)),

            _menuOportunidade(oportunidade),
          ],
        ),

        const SizedBox(height: 16),

        Divider(height: 1, color: AppColors.colors.outFocus),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(child: _inscritosInfo(totalInscritos)),

            _statusBadge(oportunidade.status),
          ],
        ),
      ],
    );
  }

  Widget _oportunidadeIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.colors.textPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.school_outlined, color: AppColors.colors.textPrimary),
    );
  }

  Widget _oportunidadeInfo(Oportunidade oportunidade) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          oportunidade.titulo,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.colors.textPrimary,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          '${_formatarTipo(oportunidade.tipo.name)} • '
          '${oportunidade.vagas} vagas',
          style: AppTextStyles.titleSmall().copyWith(
            color: AppColors.colors.outFocus,
          ),
        ),
      ],
    );
  }

  Widget _inscritosInfo(int total) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.people_outline,
          size: 18,
          color: AppColors.colors.textPrimary,
        ),

        const SizedBox(width: 6),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              total.toString(),
              style: TextStyle(
                color: AppColors.colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Inscritos',
              style: AppTextStyles.titleSmall().copyWith(fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statusBadge(StatusOportunidade status) {
    final color = AppColors.colors.positiveHighlights;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _menuOportunidade(Oportunidade oportunidade) {
    return PopupMenuButton<String>(
      tooltip: 'Opções',
      icon: Icon(Icons.more_vert, color: AppColors.colors.textInBackGround),
      onSelected: (value) {
        switch (value) {
          case 'editar':
            Navigator.pushNamed(
              context,
              AppRoutes.oportunidadeFormulario,
              arguments: oportunidade,
            );
            break;

          case 'inscritos':
            Navigator.pushNamed(
              context,
              AppRoutes.oportunidadeInscritos,
              arguments: oportunidade,
            );
            break;

          case 'pausar':
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'editar',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, color: AppColors.colors.textPrimary),
              SizedBox(width: 12),
              Text('Editar'),
            ],
          ),
        ),

        PopupMenuItem(
          value: 'inscritos',
          child: Row(
            children: [
              Icon(Icons.people_outline, color: AppColors.colors.textPrimary),
              SizedBox(width: 12),
              Text('Ver inscritos'),
            ],
          ),
        ),

        PopupMenuItem(
          value: 'pausar',
          child: Row(
            children: [
              Icon(
                Icons.pause_circle_outline,
                color: AppColors.colors.textPrimary,
              ),
              SizedBox(width: 12),
              Text('Pausar inscrições'),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Inscrições recentes
  // ---------------------------------------------------------------------------

  Widget _buildRecentInscricoes(List<Inscricao> inscricoes) {
    final recent = [...inscricoes]
      ..sort((a, b) => b.dataInscricao.compareTo(a.dataInscricao));

    final recentes = recent.take(5).toList();

    final dateFormat = DateFormat('dd/MM/yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inscrições Recentes',
          style: AppTextStyles.titleMedium().copyWith(
            color: AppColors.colors.textInBackGround,
          ),
        ),

        const SizedBox(height: 20),

        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.colors.outFocus),
          ),
          child: recentes.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_search_outlined,
                        size: 36,
                        color: AppColors.colors.outFocus,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Nenhuma inscrição recebida.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.titleSmall(),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: List.generate(recentes.length, (index) {
                    final inscricao = recentes[index];

                    final estudante = estudantesMock.firstWhere(
                      (e) => e.id == inscricao.estudanteId,
                    );

                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 5,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.colors.outFocus,
                            child: Text(
                              estudante.nome[0].toUpperCase(),
                              style: TextStyle(
                                color: AppColors.colors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            estudante.nome,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.colors.textPrimary,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              dateFormat.format(inscricao.dataInscricao),
                              style: AppTextStyles.titleSmall().copyWith(
                                fontSize: 11,
                                color: AppColors.colors.outFocus,
                              ),
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: AppColors.colors.outFocus,
                          ),
                          onTap: () {},
                        ),

                        if (index < recentes.length - 1)
                          Divider(
                            height: 1,
                            indent: 72,
                            color: AppColors.colors.outFocus,
                          ),
                      ],
                    );
                  }),
                ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Utilidades
  // ---------------------------------------------------------------------------

  String _formatarTipo(String value) {
    if (value.isEmpty) {
      return value;
    }

    final texto = value.replaceAll('_', ' ');

    return '${texto[0].toUpperCase()}${texto.substring(1)}';
  }

  void _novaOportunidade() {
    Navigator.pushNamed(context, AppRoutes.oportunidadeFormulario);
  }

  void _novoCurso() {
    Navigator.pushNamed(context, AppRoutes.cursoFormulario);
  }
}
