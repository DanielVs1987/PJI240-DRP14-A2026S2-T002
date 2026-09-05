import 'package:flutter/material.dart';
import 'package:next_cursos/shared/widgets/divisor_barra.dart';
import 'package:next_cursos/shared/widgets/nome_app.dart';
import '../../../app/app_routes.dart';
import '../../../core/auth/auth_service.dart';
import '../../../core/theme/theme.dart';
import '../../../data/mock/estudantes_mock.dart';
import '../../../domain/models/estudante.dart';
import '../../../shared/widgets/build_footer.dart';
import '../../oportunidades/models/oportunidade.dart';

class InscricaoFormPage extends StatefulWidget {
  final Oportunidade oportunidade;

  const InscricaoFormPage({super.key, required this.oportunidade});

  @override
  State<InscricaoFormPage> createState() => _InscricaoFormPageState();
}

class _InscricaoFormPageState extends State<InscricaoFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final Estudante _estudante;
  final _comprovanteRendaController = TextEditingController();
  final _historicoEscolarController = TextEditingController();
  bool _aceitouTermos = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authUser = AuthService().currentUser;
    _estudante = estudantesMock.firstWhere((e) => e.id == authUser?.userId);
  }

  @override
  void dispose() {
    _comprovanteRendaController.dispose();
    _historicoEscolarController.dispose();
    super.dispose();
  }

  void _enviarInscricao() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_aceitouTermos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você deve aceitar os termos para continuar.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simula envio para o servidor
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Inscrição enviada com sucesso!'),
        backgroundColor: AppColors.colors.positiveHighlights,
      ),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.estudanteDashboard,
      (route) => route.isFirst,
    );
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
            const Text('Inscrição'),
          ],
        ),
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 16 : 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoCard([
                          _buildStepHeader('1', 'Confirme seus dados'),
                          const SizedBox(height: 16),
                          _infoRow('Nome: ', _estudante.nome),
                          _infoRow('E-mail: ', _estudante.email),
                          _infoRow(
                            'CPF/Telefone: ',
                            _estudante.telefone ?? 'Não informado',
                          ),
                        ]),

                        const SizedBox(height: 32),

                        _buildInfoCard([
                          _buildStepHeader('2', 'Detalhes da Vaga'),
                          const SizedBox(height: 16),
                          _infoRow(
                            'Oportunidade: ',
                            widget.oportunidade.titulo,
                          ),
                          _infoRow(
                            'Tipo: ',
                            widget.oportunidade.tipo.name.toUpperCase(),
                          ),
                        ]),

                        const SizedBox(height: 32),
                        _buildInfoCard([
                          _buildStepHeader('3', 'Documentação (URLs)'),
                          const SizedBox(height: 16),

                          widget.oportunidade.historicoEscolarObrigatorio ==
                                      true ||
                                  widget
                                          .oportunidade
                                          .comprovanteRendaObrigatorio ==
                                      true
                              ? Text(
                                  'Por favor, insira os links para seus documentos hospedados (ex: Google Drive, Dropbox).',
                                  style: AppTextStyles.titleSmall().copyWith(
                                    color: AppColors.colors.outFocus,
                                  ),
                                )
                              : Text(
                                  'Não é necessário enviar documentos para esta oportunidade.',
                                  style: AppTextStyles.titleSmall().copyWith(
                                    color: AppColors.colors.outFocus,
                                  ),
                                ),
                          const SizedBox(height: 20),

                          if (widget.oportunidade.historicoEscolarObrigatorio ==
                              true)
                            TextFormField(
                              controller: _historicoEscolarController,
                              decoration: const InputDecoration(
                                labelText: 'Link do Histórico Escolar *',
                                prefixIcon: Icon(Icons.link),
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Campo obrigatório'
                                  : null,
                            ),

                          const SizedBox(height: 16),

                          if (widget.oportunidade.comprovanteRendaObrigatorio ==
                              true)
                            TextFormField(
                              controller: _comprovanteRendaController,
                              decoration: const InputDecoration(
                                labelText: 'Link do Comprovante de Renda *',
                                prefixIcon: Icon(Icons.attach_money),
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Obrigatório para bolsas'
                                  : null,
                            ),

                          const SizedBox(height: 32),

                          CheckboxListTile(
                            value: _aceitouTermos,
                            onChanged: (v) =>
                                setState(() => _aceitouTermos = v ?? false),
                            title: const Text(
                              'Declaro que todas as informações prestadas são verdadeiras e estou ciente das regras do edital.',
                              style: TextStyle(fontSize: 14),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ]),

                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _enviarInscricao,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text('CONFIRMAR MINHA INSCRIÇÃO'),
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

  Widget _buildStepHeader(String number, String title) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.colors.primary,
          child: Text(
            number,
            style: AppTextStyles.titleLarge().copyWith(
              color: AppColors.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(title, style: AppTextStyles.titleLarge()),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(child: Text(label, style: AppTextStyles.titleMedium())),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.titleSmall().copyWith(
                color: AppColors.colors.outFocus,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
