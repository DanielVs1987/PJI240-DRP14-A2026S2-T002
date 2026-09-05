import 'package:flutter/material.dart';
import 'package:next_cursos/shared/widgets/build_app_bar.dart';
import 'package:next_cursos/shared/widgets/build_footer.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../data/mock/auth_mock.dart';
import '../../../data/mock/oportunidades_mock.dart';
import '../../../data/mock/cursos_mock.dart';
import '../../../shared/models/enums.dart';
import '../models/oportunidade.dart';

class OportunidadesListArgs {
  final String titulo;
  final List<TipoOportunidade> tipos;
  final AuthCredentialMock? authUser;
  final bool filtrarPorProcessoSeletivo;
  final String? termoBuscaInicial;
  final List<ModalidadeCurso>? modalidades;

  OportunidadesListArgs({
    required this.titulo,
    required this.tipos,
    required this.authUser,
    this.filtrarPorProcessoSeletivo = false,
    this.termoBuscaInicial,
    this.modalidades,
  });
}

class OportunidadesListPage extends StatefulWidget {
  final OportunidadesListArgs args;

  const OportunidadesListPage({super.key, required this.args});

  @override
  State<OportunidadesListPage> createState() => _OportunidadesListPageState();
}

class _OportunidadesListPageState extends State<OportunidadesListPage> {
  late final TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.args.termoBuscaInicial ?? '';
    _searchController = TextEditingController(text: _searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 700;

    final filteredList = oportunidadesMock.where((op) {
      // Filtro por Tipo
      final matchesType = widget.args.tipos.contains(op.tipo);

      // Filtro por Termo de Busca (Título ou Descrição)
      final matchesSearch =
          op.titulo.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          op.descricao.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Filtro por Processo Seletivo
      bool matchesProcesso = true;
      if (widget.args.filtrarPorProcessoSeletivo) {
        matchesProcesso = op.possuiProcessoSeletivo;
      }

      // Filtro por Modalidade (Busca no curso vinculado)
      bool matchesModalidade = true;
      if (widget.args.modalidades != null && widget.args.modalidades!.isNotEmpty) {
        final curso = cursosMock.firstWhere((c) => c.id == op.cursoId);
        matchesModalidade = widget.args.modalidades!.contains(curso.modalidade);
      }

      return matchesType && matchesSearch && matchesProcesso && matchesModalidade;
    }).toList();

    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          _buildSearchBar(isMobile),
          Expanded(
            child: filteredList.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 40,
                      vertical: 24,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return _buildOportunidadeCard(
                        filteredList[index],
                        isMobile,
                      );
                    },
                  ),
          ),
          buildFooter()
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isMobile) {
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
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: 16,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Buscar nesta categoria...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: const Color(0xFFF5F7FA),
        ),
      ),
    );
  }

  Widget _buildOportunidadeCard(Oportunidade op, bool isMobile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.oportunidadeDetalhe,
            arguments: op,
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (op.imagemUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/carousel_images/${op.imagemUrl}',
                    width: isMobile ? 80 : 120,
                    height: isMobile ? 80 : 120,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      op.tipo.name.toUpperCase(),
                      style: TextStyle(
                        color: AppColors.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      op.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      op.descricao,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSmall().copyWith(
                        color: AppColors.colors.outFocus,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 16,
                          color: AppColors.colors.outFocus,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${op.vagas} vagas',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(width: 20),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: AppColors.colors.outFocus,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Até ${op.dataFimInscricao.day}/${op.dataFimInscricao.month}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: AppColors.colors.outFocus,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Nenhuma oportunidade encontrada',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Tente ajustar os termos da sua busca.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
