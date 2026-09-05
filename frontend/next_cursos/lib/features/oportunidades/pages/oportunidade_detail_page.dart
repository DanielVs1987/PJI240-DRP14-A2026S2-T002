import 'package:flutter/material.dart';
import 'package:next_cursos/shared/widgets/build_app_bar.dart';
import 'package:next_cursos/shared/widgets/build_footer.dart';
import '../../../core/auth/auth_service.dart';
import '../../../app/app_routes.dart';
import '../../../shared/dialogs/login_estudante_dialog.dart';
import '../../../core/theme/theme.dart';
import '../models/oportunidade.dart';
import 'package:intl/intl.dart';



class OportunidadeDetailPage extends StatelessWidget {
  final Oportunidade oportunidade;

  const OportunidadeDetailPage({
    super.key,
    required this.oportunidade,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final isMobile = MediaQuery.sizeOf(context).width < 700;


    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem de Destaque
            if (oportunidade.imagemUrl != null)
              Container(
                width: double.infinity,
                height: isMobile ? 250 : 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/carousel_images/${oportunidade.imagemUrl}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 40,
                vertical: 30,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tipo e Status
                    Row(
                      children: [
                        _buildBadge(
                          label: oportunidade.tipo.name.toUpperCase(),
                          color: AppColors.colors.textInBackGround,
                        ),
                        const SizedBox(width: 10),
                        _buildBadge(
                          label: oportunidade.status.name.toUpperCase(),
                          color: AppColors.colors.positiveHighlights,
                          isOutline: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Título
                    Text(
                      oportunidade.titulo,
                      style: AppTextStyles.titleLarge().copyWith(
                        fontSize: isMobile ? 28 : 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.colors.textInBackGround,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Descrição
                    Text(
                      oportunidade.descricao,
                      style: AppTextStyles.titleMedium().copyWith(
                        color: AppColors.colors.textInBackGround,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Grid de Informações
                    Wrap(
                      spacing: 40,
                      runSpacing: 30,
                      children: [
                        _buildInfoItem(
                          icon: Icons.calendar_today_outlined,
                          label: 'Inscrições até',
                          value: dateFormat.format(oportunidade.dataFimInscricao),
                          context: context
                        ),
                        _buildInfoItem(
                          icon: Icons.people_outline,
                          label: 'Vagas disponíveis',
                          value: '${oportunidade.vagas} vagas',
                          context: context
                        ),
                        if (oportunidade.percentualBolsa != null)
                          _buildInfoItem(
                            icon: Icons.confirmation_number_outlined,
                            label: 'Percentual da Bolsa',
                            value: '${oportunidade.percentualBolsa!.toInt()}%',
                            context: context
                          ),
                        if (oportunidade.dataInicioCurso != null)
                          _buildInfoItem(
                            icon: Icons.play_circle_outline,
                            label: 'Início das aulas',
                            value: dateFormat.format(oportunidade.dataInicioCurso!),
                            context: context
                          ),
                      ],
                    ),

                    const SizedBox(height: 40),
                    const Divider(),
                    const SizedBox(height: 30),

                    // Requisitos
                    if (oportunidade.requisitos != null) ...[
                      _sectionTitle('Requisitos', context),
                      const SizedBox(height: 10),
                      Text(
                        oportunidade.requisitos!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.colors.textInBackGround,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],

                    // Observações
                    if (oportunidade.observacoes != null) ...[
                      _sectionTitle('Observações Importantes', context),
                      const SizedBox(height: 10),
                      Text(
                        oportunidade.observacoes!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 30),
                    ],

                    const SizedBox(height: 20),

                    // Ações
                    SizedBox(
                      width: isMobile ? double.infinity : 300,
                      child: ElevatedButton(
                        onPressed: () {
                          final auth = AuthService();
                          if (!auth.isAuthenticated) {
                            showDialog(
                              context: context,
                              builder: (_) => const LoginEstudanteDialog(),
                            );
                            return;
                          }

                          if (auth.isEstudante) {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.inscricaoFormulario,
                              arguments: oportunidade,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Apenas estudantes podem se inscrever.',
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 22),
                        ),
                        child: const Text('Quero me inscrever'),
                      ),
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
            buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color color,
    bool isOutline = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: isOutline
            ? Border.all(color: color.withValues(alpha: 0.5))
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.colors.textInBackGround,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.colors.textPrimary, size: 24),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.colors.textInBackGround,
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.colors.textInBackGround,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: AppColors.colors.textInBackGround,
      ),
    );
  }
}
