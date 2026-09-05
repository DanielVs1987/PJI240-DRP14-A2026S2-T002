import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_cursos/shared/widgets/build_footer.dart';
import '../../../core/theme/theme.dart';
import '../../../data/mock/cursos_mock.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/widgets/divisor_barra.dart';
import '../../../shared/widgets/nome_app.dart';
import '../models/oportunidade.dart';

class OportunidadeFormPage extends StatefulWidget {
  final Oportunidade? oportunidade;

  const OportunidadeFormPage({super.key, this.oportunidade});

  @override
  State<OportunidadeFormPage> createState() => _OportunidadeFormPageState();
}

class _OportunidadeFormPageState extends State<OportunidadeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  late final TextEditingController _tituloController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _vagasController;
  late final TextEditingController _percentualBolsaController;
  late final TextEditingController _requisitosController;
  late final TextEditingController _observacoesController;
  late final TextEditingController _imagemUrlController;

  String? _cursoId;
  TipoOportunidade? _tipo;
  DateTime? _dataInicioInscricao;
  DateTime? _dataFimInscricao;
  DateTime? _dataInicioCurso;
  bool _destaque = false;
  bool _possuiProcessoSeletivo = false;
  bool _historicoEscolarObrigatorio = true;
  bool _comprovanteRendaObrigatorio = false;

  @override
  void initState() {
    super.initState();
    final op = widget.oportunidade;

    _tituloController = TextEditingController(text: op?.titulo);
    _descricaoController = TextEditingController(text: op?.descricao);
    _vagasController = TextEditingController(text: op?.vagas.toString());
    _percentualBolsaController = TextEditingController(
      text: op?.percentualBolsa?.toString(),
    );
    _requisitosController = TextEditingController(text: op?.requisitos);
    _observacoesController = TextEditingController(text: op?.observacoes);
    _imagemUrlController = TextEditingController(text: op?.imagemUrl);

    if (op != null) {
      _cursoId = op.cursoId;
      _tipo = op.tipo;
      _dataInicioInscricao = op.dataInicioInscricao;
      _dataFimInscricao = op.dataFimInscricao;
      _dataInicioCurso = op.dataInicioCurso;
      _destaque = op.destaque;
      _possuiProcessoSeletivo = op.possuiProcessoSeletivo;
      _historicoEscolarObrigatorio = op.historicoEscolarObrigatorio;
      _comprovanteRendaObrigatorio = op.comprovanteRendaObrigatorio;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _vagasController.dispose();
    _percentualBolsaController.dispose();
    _requisitosController.dispose();
    _observacoesController.dispose();
    _imagemUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, String field) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (field == 'inicioInscricao') _dataInicioInscricao = picked;
        if (field == 'fimInscricao') _dataFimInscricao = picked;
        if (field == 'inicioCurso') _dataInicioCurso = picked;
      });
    }
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      if (_dataInicioInscricao == null || _dataFimInscricao == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selecione as datas de inscrição'),
            backgroundColor: AppColors.colors.negativeHighlights,
          ),
        );
        return;
      }

      // Mock de salvamento
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.oportunidade == null
                ? 'Oportunidade cadastrada com sucesso!'
                : 'Oportunidade atualizada com sucesso!',
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
                ? Text(
                    widget.oportunidade == null
                        ? 'Nova Oportunidade'
                        : 'Editar Oportunidade',
                  )
                : Text(
                    widget.oportunidade == null
                        ? 'Nova'
                        : 'Editar',
                  ),
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
                            _sectionTitle('Informações Básicas'),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _tituloController,
                              decoration: const InputDecoration(
                                labelText: 'Título da Oportunidade *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Campo obrigatório'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _cursoId,
                              decoration: const InputDecoration(
                                labelText: 'Curso Vinculado *',
                                border: OutlineInputBorder(),
                              ),
                              items: cursosMock
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c.id,
                                      child: Text(c.nome),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => setState(() => _cursoId = v),
                              validator: (v) =>
                                  v == null ? 'Selecione um curso' : null,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child:
                                      DropdownButtonFormField<TipoOportunidade>(
                                        value: _tipo,
                                        decoration: const InputDecoration(
                                          labelText: 'Tipo *',
                                          border: OutlineInputBorder(),
                                        ),
                                        items: TipoOportunidade.values
                                            .map(
                                              (t) => DropdownMenuItem(
                                                value: t,
                                                child: Text(t.name),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (v) =>
                                            setState(() => _tipo = v),
                                        validator: (v) => v == null
                                            ? 'Selecione o tipo'
                                            : null,
                                      ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _vagasController,
                                    decoration: const InputDecoration(
                                      labelText: 'Vagas *',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (v) => v == null || v.isEmpty
                                        ? 'Obrigatório'
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        _containerSection(
                          child: [
                            _sectionTitle('Cronograma'),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _datePickerField(
                                    label: 'Início Inscrições *',
                                    date: _dataInicioInscricao,
                                    onTap: () =>
                                        _selectDate(context, 'inicioInscricao'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _datePickerField(
                                    label: 'Fim Inscrições *',
                                    date: _dataFimInscricao,
                                    onTap: () =>
                                        _selectDate(context, 'fimInscricao'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _datePickerField(
                              label: 'Previsão Início do Curso',
                              date: _dataInicioCurso,
                              onTap: () => _selectDate(context, 'inicioCurso'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        _containerSection(
                          child: [
                            _sectionTitle('Configurações e Requisitos'),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _descricaoController,
                              decoration: const InputDecoration(
                                labelText: 'Descrição Completa *',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 4,
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Campo obrigatório'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _requisitosController,
                              decoration: const InputDecoration(
                                labelText: 'Requisitos',
                                border: OutlineInputBorder(),
                                hintText: 'Ex: Ensino médio completo...',
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _imagemUrlController,
                              decoration: const InputDecoration(
                                labelText: 'Caminho da Imagem (Ex: 1.jpeg)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            CheckboxListTile(
                              title: const Text('Possui Processo Seletivo?'),
                              value: _possuiProcessoSeletivo,
                              onChanged: (v) => setState(
                                () => _possuiProcessoSeletivo = v ?? false,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                            CheckboxListTile(
                              title: const Text(
                                'Histórico Escolar Obrigatório?',
                              ),
                              value: _historicoEscolarObrigatorio,
                              onChanged: (v) => setState(
                                () => _historicoEscolarObrigatorio = v ?? false,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                            CheckboxListTile(
                              title: const Text(
                                'Comprovante de Renda Obrigatório?',
                              ),
                              value: _comprovanteRendaObrigatorio,
                              onChanged: (v) => setState(
                                () => _comprovanteRendaObrigatorio = v ?? false,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                            SwitchListTile(
                              title: const Text(
                                'Colocar em destaque na página inicial',
                              ),
                              value: _destaque,
                              onChanged: (v) => setState(() => _destaque = v),
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
                              widget.oportunidade == null
                                  ? 'CADASTRAR OPORTUNIDADE'
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
        Text(
          title,
          style: AppTextStyles.titleLarge().copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _datePickerField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date == null ? 'Selecionar data' : _dateFormat.format(date)),
            const Icon(Icons.calendar_today, size: 18),
          ],
        ),
      ),
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
