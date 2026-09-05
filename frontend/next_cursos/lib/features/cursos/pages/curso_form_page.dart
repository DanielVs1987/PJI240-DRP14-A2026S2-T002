import 'package:flutter/material.dart';
import 'package:next_cursos/shared/widgets/divisor_barra.dart';
import 'package:next_cursos/shared/widgets/nome_app.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/widgets/build_footer.dart';
import '../models/curso.dart';

class CursoFormPage extends StatefulWidget {
  final Curso? curso;

  const CursoFormPage({super.key, this.curso});

  @override
  State<CursoFormPage> createState() => _CursoFormPageState();
}

class _CursoFormPageState extends State<CursoFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _areaConhecimentoController;
  late final TextEditingController _cargaHorariaController;
  late final TextEditingController _duracaoMesesController;
  late final TextEditingController _imagemUrlController;

  ModalidadeCurso _modalidade = ModalidadeCurso.presencial;
  bool _ativo = true;

  @override
  void initState() {
    super.initState();
    final c = widget.curso;

    _nomeController = TextEditingController(text: c?.nome);
    _descricaoController = TextEditingController(text: c?.descricao);
    _areaConhecimentoController = TextEditingController(
      text: c?.areaConhecimento,
    );
    _cargaHorariaController = TextEditingController(
      text: c?.cargaHoraria?.toString(),
    );
    _duracaoMesesController = TextEditingController(
      text: c?.duracaoMeses?.toString(),
    );
    _imagemUrlController = TextEditingController(text: c?.imagemUrl);

    if (c != null) {
      _modalidade = c.modalidade;
      _ativo = c.ativo;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _areaConhecimentoController.dispose();
    _cargaHorariaController.dispose();
    _duracaoMesesController.dispose();
    _imagemUrlController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.curso == null
                ? 'Curso cadastrado com sucesso!'
                : 'Curso atualizado com sucesso!',
          ),
          backgroundColor: AppColors.colors.positiveHighlights,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            nomeApp(context),
            divisorBarra(40),
            !isMobile
                ? Text(widget.curso == null ? 'Novo Curso' : 'Editar Curso')
                : Text(widget.curso == null ? 'Novo' : 'Editar'),
          ],
        ),

        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _containerSection(
                          child: [
                            _sectionTitle('Identificação do Curso'),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _nomeController,
                              decoration: const InputDecoration(
                                labelText: 'Nome do Curso *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Campo obrigatório'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _areaConhecimentoController,
                              decoration: const InputDecoration(
                                labelText: 'Área de Conhecimento *',
                                border: OutlineInputBorder(),
                                hintText: 'Ex: Tecnologia, Saúde, Artes...',
                              ),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Campo obrigatório'
                                  : null,
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        _containerSection(
                          child: [
                            _sectionTitle('Configurações Técnicas'),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child:
                                      DropdownButtonFormField<ModalidadeCurso>(
                                        value: _modalidade,
                                        decoration: const InputDecoration(
                                          labelText: 'Modalidade *',
                                          border: OutlineInputBorder(),
                                        ),
                                        items: ModalidadeCurso.values
                                            .map(
                                              (m) => DropdownMenuItem(
                                                value: m,
                                                child: Text(
                                                  m.name.toUpperCase(),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (v) =>
                                            setState(() => _modalidade = v!),
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _cargaHorariaController,
                                    decoration: const InputDecoration(
                                      labelText: 'Carga Horária (horas)',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _duracaoMesesController,
                                    decoration: const InputDecoration(
                                      labelText: 'Duração (meses)',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        _containerSection(
                          child: [
                            _sectionTitle('Apresentação'),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _descricaoController,
                              decoration: const InputDecoration(
                                labelText: 'Descrição Detalhada *',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 5,
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Campo obrigatório'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _imagemUrlController,
                              decoration: const InputDecoration(
                                labelText: 'URL da Imagem de Capa',
                                border: OutlineInputBorder(),
                                hintText: 'Ex: 1.jpeg ou link externo',
                              ),
                            ),
                            const SizedBox(height: 16),
                            SwitchListTile(
                              title: const Text('Curso Ativo'),
                              subtitle: Text(
                                'Se desativado, o curso não poderá ser vinculado a novas oportunidades.',
                                style: AppTextStyles.titleSmall().copyWith(
                                  color: AppColors.colors.outFocus,
                                ),
                              ),
                              value: _ativo,
                              onChanged: (v) => setState(() => _ativo = v),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _salvar,
                            child: Text(
                              widget.curso == null
                                  ? 'CADASTRAR CURSO'
                                  : 'SALVAR ALTERAÇÕES',
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
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

  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleLarge()),
        const Divider(),
      ],
    );
  }
}

Widget _containerSection({required List<Widget> child}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.colors.surface,
      border: Border.all(color: AppColors.colors.secondary),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: child,
    ),
  );
}
