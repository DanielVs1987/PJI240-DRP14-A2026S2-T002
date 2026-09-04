import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_cursos/shared/widgets/build_footer.dart';
import '../../../core/theme/theme.dart';
import '../../../data/mock/estudantes_mock.dart';
import '../../../data/mock/inscricoes_mock.dart';
import '../../../data/mock/resultados_mock.dart';
import '../../../shared/models/enums.dart';
import '../../inscricoes/models/inscricao.dart';
import '../models/oportunidade.dart';

class OportunidadeInscritosPage extends StatefulWidget {
  final Oportunidade oportunidade;

  const OportunidadeInscritosPage({super.key, required this.oportunidade});

  @override
  State<OportunidadeInscritosPage> createState() =>
      _OportunidadeInscritosPageState();
}

class _OportunidadeInscritosPageState extends State<OportunidadeInscritosPage> {
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 700;

    // Filtra as inscrições para esta oportunidade específica
    final inscritos = inscricoesMock
        .where((i) => i.oportunidadeId == widget.oportunidade.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Gestão de Inscritos'), elevation: 0),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHeader(inscritos.length),
                Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (inscritos.isEmpty)
                          _buildEmptyState()
                        else
                          _buildInscritosList(inscritos, isMobile),
                      ],
                    ),
                  ),
                ),
              ],
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

  Widget _buildHeader(int totalInscritos) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.colors.primary,
            AppColors.colors.primary.withValues(alpha: 0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.oportunidade.titulo,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _infoBadge(Icons.people_outline, '$totalInscritos candidatos'),
              const SizedBox(width: 16),
              _infoBadge(
                Icons.event_available_outlined,
                'Vagas: ${widget.oportunidade.vagas}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.colors.textPrimary),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: AppColors.colors.textPrimary)),
      ],
    );
  }

  Widget _buildInscritosList(List<Inscricao> inscritos, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lista de Candidatos',
          style: AppTextStyles.titleLarge().copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.colors.textInBackGround,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: inscritos.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final inscricao = inscritos[index];
            final estudante = estudantesMock.firstWhere(
              (e) => e.id == inscricao.estudanteId,
            );
            final resultado = resultadosMock.cast<dynamic>().firstWhere(
              (r) => r.inscricaoId == inscricao.id,
              orElse: () => null,
            );

            return _candidateCard(inscricao, estudante, resultado, isMobile);
          },
        ),
      ],
    );
  }

  Widget _candidateCard(
    Inscricao ins,
    dynamic est,
    dynamic res,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: isMobile
          ? _buildMobileCard(ins, est, res)
          : _buildDesktopCard(ins, est, res),
    );
  }

  Widget _buildDesktopCard(Inscricao ins, dynamic est, dynamic res) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.colors.outFocus,
          child: Text(
            est.nome[0],
            style: AppTextStyles.titleLarge().copyWith(
              color: AppColors.colors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                est.nome,
                style: AppTextStyles.titleLarge().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                est.email,
                style: AppTextStyles.titleMedium().copyWith(
                  color: AppColors.colors.outFocus,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nota',
                style: AppTextStyles.titleLarge().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                res != null ? res.notaFinal.toString() : 'N/A',
                style: AppTextStyles.titleMedium().copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.colors.outFocus,
                ),
              ),
            ],
          ),
        ),
        _statusDropdown(ins),
        const SizedBox(width: 20),
        _buildActionMenu(ins),
      ],
    );
  }

  Widget _buildMobileCard(Inscricao ins, dynamic est, dynamic res) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              child: Text(
                est.nome[0],
                style: TextStyle(color: AppColors.colors.textPrimary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    est.nome,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.colors.textPrimary,
                    ),
                  ),
                  Text(
                    est.email,
                    style: TextStyle(
                      color: AppColors.colors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            _buildActionMenu(ins),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nota Seleção', style: TextStyle(fontSize: 11)),
                Text(
                  res != null ? res.notaFinal.toString() : '--',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.colors.textPrimary,
                  ),
                ),
              ],
            ),
            _statusDropdown(ins),
          ],
        ),
      ],
    );
  }

  Widget _statusDropdown(Inscricao ins) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _getStatusColor(ins.status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<StatusInscricao>(
        value: ins.status,
        underline: const SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: _getStatusColor(ins.status)),
        items: StatusInscricao.values.map((s) {
          return DropdownMenuItem(
            value: s,
            child: Text(
              s.name.toUpperCase(),
              style: TextStyle(
                color: _getStatusColor(s),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
        onChanged: (newStatus) {
          if (newStatus != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Status de ${estudantesMock.firstWhere((e) => e.id == ins.estudanteId).nome} alterado para ${newStatus.name}',
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildActionMenu(Inscricao ins) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert, color: AppColors.colors.outFocus),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(
              Icons.description_outlined,
              color: AppColors.colors.textPrimary,
            ),
            title: Text(
              'Ver Documentos',
              style: TextStyle(color: AppColors.colors.textPrimary),
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(
              Icons.person_outline,
              color: AppColors.colors.textPrimary,
            ),
            title: Text(
              'Perfil Completo',
              style: TextStyle(color: AppColors.colors.textPrimary),
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(
              Icons.email_outlined,
              color: AppColors.colors.textPrimary,
            ),
            title: Text(
              'Enviar E-mail',
              style: TextStyle(color: AppColors.colors.textPrimary),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(StatusInscricao status) {
    switch (status) {
      case StatusInscricao.aprovado:
        return Colors.green;
      case StatusInscricao.reprovado:
        return Colors.red;
      case StatusInscricao.emAnalise:
        return Colors.orange;
      case StatusInscricao.inscrita:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 64),
        child: Column(
          children: [
            Icon(
              Icons.person_search_outlined,
              size: 64,
              color: AppColors.colors.textPrimary,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum candidato inscrito ainda.',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
