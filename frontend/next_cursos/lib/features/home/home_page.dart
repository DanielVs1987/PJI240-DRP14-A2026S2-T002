import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:next_cursos/shared/dialogs/cadastro_instituicao_dialog.dart';

import '../../app/app_routes.dart';
import '../../core/auth/auth_service.dart';
import '../../core/theme/theme.dart';
import '../../data/mock/auth_mock.dart';
import '../../data/mock/oportunidades_mock.dart';
import '../../shared/widgets/build_app_bar.dart';
import '../../shared/widgets/build_footer.dart';
import '../oportunidades/models/oportunidade.dart';
import '../oportunidades/pages/oportunidades_list_page.dart';
import '../../shared/models/enums.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  AuthCredentialMock? authUser;

  final TextEditingController _searchController = TextEditingController();

  final List<Oportunidade> _destaques = oportunidadesMock
      .where((o) => o.destaque)
      .toList();

  @override
  void initState() {
   authUser = AuthService().currentUser;
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeroSection()),

          SliverToBoxAdapter(child: _buildDestaquesSection()),

          SliverToBoxAdapter(child: _buildCategoriasSection()),

          SliverToBoxAdapter(child: _buildInstituicaoSection(context)),

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

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 72),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.colors.primary,
            AppColors.colors.primary.withValues(alpha: 0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              Text(
                'Encontre sua próxima  oportunidade',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleLarge().copyWith(
                  fontSize: 42,
                  height: 1.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                'Cursos gratuitos, bolsas de estudo e processos seletivos '
                'de instituições de ensino em um só lugar.',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleMedium().copyWith(
                  fontSize: 18,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.90),
                ),
              ),

              const SizedBox(height: 36),

              _buildSearchBox(),

              const SizedBox(height: 20),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _quickFilter(
                    icon: Icons.school_outlined,
                    text: 'Cursos gratuitos',
                  ),
                  _quickFilter(
                    icon: Icons.workspace_premium_outlined,
                    text: 'Bolsas',
                  ),
                  _quickFilter(icon: Icons.laptop_outlined, text: 'Online'),
                  _quickFilter(
                    icon: Icons.location_on_outlined,
                    text: 'Presencial',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 760),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),

          Icon(Icons.search, color: AppColors.colors.textInBackGround),

          const SizedBox(width: 8),

          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Busque por curso, área ou instituição...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _realizarBusca(),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: _realizarBusca,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Buscar'),
          ),
        ],
      ),
    );
  }

  Widget _quickFilter({required IconData icon, required String text}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildDestaquesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(
                titulo: 'Oportunidades em destaque',
                subtitulo:
                    'Confira algumas oportunidades que podem ajudar você '
                    'a dar o próximo passo.',
              ),

              const SizedBox(height: 30),

              _buildCarousel(),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_destaques.length, (index) {
                  final selected = index == _currentIndex;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: selected ? 28 : 8,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.colors.primary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    final width = MediaQuery.sizeOf(context).width;

    final isMobile = width < 700;

    return CarouselSlider.builder(
      itemCount: _destaques.length,
      itemBuilder: (context, index, realIndex) {
        final oportunidade = _destaques[index];
        return _CarrosselItem(
          oportunidade: oportunidade,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.oportunidadeDetalhe,
              arguments: oportunidade,
            );
          },
          isMobile: isMobile,
        );
      },
      options: CarouselOptions(
        height: isMobile ? 550 : 400,
        viewportFraction: 0.78,
        enlargeCenterPage: true,
        enlargeFactor: 0.16,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 700),
        autoPlayCurve: Curves.easeOutCubic,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildCategoriasSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              _sectionHeader(
                titulo: 'Encontre o que você procura',
                subtitulo:
                    'Explore as principais oportunidades disponíveis na plataforma.',
                center: true,
              ),

              const SizedBox(height: 40),

              Wrap(
                spacing: 22,
                runSpacing: 22,
                alignment: WrapAlignment.center,
                children: [
                  _categoriaCard(
                    icon: Icons.school_outlined,
                    titulo: 'Cursos gratuitos',
                    descricao:
                        'Cursos sem mensalidade em diversas áreas do conhecimento.',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.oportunidadesLista,
                        arguments: OportunidadesListArgs(
                          titulo: 'Cursos Gratuitos',
                          tipos: [TipoOportunidade.cursoGratuito],
                          authUser: authUser
                        ),
                      );
                    },
                  ),
                  _categoriaCard(
                    icon: Icons.workspace_premium_outlined,
                    titulo: 'Bolsas de estudo',
                    descricao:
                        'Encontre bolsas parciais e integrais disponíveis.',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.oportunidadesLista,
                        arguments: OportunidadesListArgs(
                          titulo: 'Bolsas de Estudo',
                          authUser: authUser,
                          tipos: [
                            TipoOportunidade.bolsaParcial,
                            TipoOportunidade.bolsaIntegral
                          ],
                        ),
                      );
                    },
                  ),
                  _categoriaCard(
                    icon: Icons.assignment_outlined,
                    titulo: 'Processos seletivos',
                    descricao: 'Encontre processos seletivos em andamento.',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.oportunidadesLista,
                        arguments: OportunidadesListArgs(
                          authUser: authUser,
                          titulo: 'Processos Seletivos',
                          tipos: [TipoOportunidade.processoSeletivo],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoriaCard({
    required IconData icon,
    required String titulo,
    required String descricao,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 330,
      child: Card(
        elevation: 0,
        color: const Color(0xFFF9FAFC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.colors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: AppColors.colors.primary, size: 32),
                ),

                const SizedBox(height: 20),

                Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.titleMedium().copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.colors.textInBackGround,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  descricao,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, height: 1.5),
                ),

                const SizedBox(height: 20),

                TextButton.icon(
                  onPressed: onTap,
                  label: Text(
                    'Explorar',
                    style: TextStyle(color: AppColors.colors.textInBackGround),
                  ),
                  icon: Icon(
                    Icons.arrow_forward,
                    color: AppColors.colors.textInBackGround,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstituicaoSection(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final isMobile = width < 700;
    final isTablet = width >= 700 && width < 1100;

    final horizontalPadding = isMobile ? 16.0 : 32.0;
    final verticalPadding = isMobile ? 40.0 : 72.0;

    final containerPadding = isMobile
        ? 24.0
        : isTablet
        ? 32.0
        : 44.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(containerPadding),
            decoration: BoxDecoration(
              color: AppColors.colors.primary,
              borderRadius: BorderRadius.circular(isMobile ? 20 : 28),
            ),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInstituicaoConteudo(isMobile: true),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        child: _buildInstituicaoButton(),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _buildInstituicaoConteudo(isMobile: false),
                      ),

                      const SizedBox(width: 40),

                      _buildInstituicaoButton(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstituicaoConteudo({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.apartment_rounded,
          color: Colors.white,
          size: isMobile ? 36 : 42,
        ),

        SizedBox(height: isMobile ? 18 : 22),

        Text(
          'Sua instituição também pode fazer parte',
          style: AppTextStyles.titleLarge().copyWith(
            fontSize: isMobile ? 23 : 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 14),

        Text(
          'Publique cursos, bolsas de estudo, receba inscrições '
          'e gerencie seus processos seletivos pela plataforma.',
          style: AppTextStyles.titleMedium().copyWith(
            fontSize: isMobile ? 15 : null,
            color: Colors.white.withValues(alpha: 0.88),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInstituicaoButton() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => const CadastroInstituicaoDialog(),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.colors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
      ),
      child: const Text('Cadastrar instituição', textAlign: TextAlign.center),
    );
  }

  Widget _sectionHeader({
    required String titulo,
    required String subtitulo,
    bool center = false,
  }) {
    return Column(
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: AppTextStyles.titleLarge().copyWith(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.colors.textInBackGround,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          subtitulo,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: AppTextStyles.titleMedium().copyWith(
            color: AppColors.colors.textInBackGround,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  void _realizarBusca() {
    final termo = _searchController.text.trim();

    if (termo.isEmpty) {
      return;
    }

    debugPrint('Buscar por: $termo');

    // Posteriormente:
    //
    // Navigator.pushNamed(
    //   context,
    //   AppRoutes.oportunidades,
    //   arguments: termo,
    // );
  }
}

class _CarrosselItem extends StatelessWidget {
  final Oportunidade oportunidade;
  final VoidCallback onTap;
  final bool isMobile;

  const _CarrosselItem({
    required this.oportunidade,
    required this.onTap,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.colors.surface,
        borderRadius: BorderRadius.circular(isMobile ? 20 : 26),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 220,
                  child: Image.asset(
                    'assets/carousel_images/${oportunidade.imagemUrl}',
                    fit: BoxFit.cover,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: _buildConteudo(isMobile: true),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(36),
                    child: _buildConteudo(isMobile: false),
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: SizedBox.expand(
                    child: Image.asset(
                      'assets/carousel_images/${oportunidade.imagemUrl}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildConteudo({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.colors.positiveHighlights.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            oportunidade.tipo.name.toUpperCase(),
            style: AppTextStyles.titleSmall(),
          ),
        ),

        SizedBox(height: isMobile ? 12 : 18),

        Text(
          oportunidade.titulo,
          style: AppTextStyles.titleLarge().copyWith(
            fontSize: isMobile ? 22 : 28,
            color: AppColors.colors.textPrimary,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),

        SizedBox(height: isMobile ? 10 : 14),

        Text(
          oportunidade.descricao,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleMedium().copyWith(
            fontSize: isMobile ? 15 : null,
            color: AppColors.colors.textPrimary,
            height: 1.5,
          ),
        ),

        SizedBox(height: isMobile ? 18 : 22),

        SizedBox(
          width: isMobile ? double.infinity : null,
          child: ElevatedButton.icon(
            onPressed: onTap,
            label: const Text('Ver detalhes'),
            icon: const Icon(Icons.arrow_forward),
          ),
        ),
      ],
    );
  }
}
