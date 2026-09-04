import 'package:flutter/material.dart';
import 'package:next_cursos/shared/widgets/divisor_barra.dart';
import 'package:next_cursos/shared/widgets/nome_app.dart';

import '../../app/app_routes.dart';
import '../../core/auth/auth_service.dart';
import '../../core/theme/theme.dart';

import '../dialogs/login_estudante_dialog.dart';
import '../dialogs/login_instituicao_dialog.dart';

PreferredSizeWidget buildAppBar(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  final auth = AuthService();
  final isDesktop = width >= 1000;

  return AppBar(
    toolbarHeight: 72,
    elevation: 0,
    titleSpacing: 32,

    title: nomeApp(context),

    actions: auth.isAuthenticated
        ? [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    auth.isEstudante ? AppRoutes.estudanteDashboard : AppRoutes.instituicaoDashboard
                  );
                },
                icon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_outline, size: 20),
                    Text(
                      '${auth.credencialId.substring(0, 1).toUpperCase() + auth.credencialId.substring(1, 3)}...',
                      style: TextStyle(color: AppColors.colors.textPrimary),
                    ),
                  ],
                ),
              ),
            ),

            divisorBarra(30),

            const SizedBox(width: 8),

            IconButton(
              onPressed: () {
                AuthService().logout();
                Navigator.of(context).pushReplacementNamed(AppRoutes.home);
              },
              icon: const Icon(Icons.logout),
            ),
            const SizedBox(width: 12),

            const SizedBox(width: 20),
          ]
        : [
            if (isDesktop) ...[
              _menuButton(text: 'Explorar', onPressed: () {}),
              _menuButton(text: 'Parcerias', onPressed: () {}),
              _menuButton(text: 'Sobre', onPressed: () {}),
              _menuButton(text: 'Ajuda', onPressed: () {}),

              const SizedBox(width: 16),

              divisorBarra(32),

              const SizedBox(width: 16),

              const Text('Entrar:'),

              const SizedBox(width: 8),

              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const LoginEstudanteDialog(),
                  );
                },
                icon: const Icon(Icons.person_outline),
                label: const Text('Estudante'),
              ),

              const SizedBox(width: 8),

              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const LoginInstituicaoDialog(),
                  );
                },
                icon: const Icon(Icons.apartment_outlined),
                label: const Text('Instituição'),
              ),

              const SizedBox(width: 32),
            ] else ...[
              PopupMenuButton<String>(
                icon: const Icon(Icons.menu_rounded),
                onSelected: (value) {
                  switch (value) {
                    case 'Estudante':
                      showDialog(
                        context: context,
                        builder: (_) => const LoginEstudanteDialog(),
                      );
                      break;

                    case 'Instituição':
                      showDialog(
                        context: context,
                        builder: (_) => const LoginInstituicaoDialog(),
                      );
                      break;

                    case 'explorar':
                      break;

                    case 'parcerias':
                      break;

                    case 'sobre':
                      break;

                    case 'ajuda':
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'Estudante',
                    child: Row(
                      children: [
                        Icon(Icons.person_outline),
                        SizedBox(width: 8),
                        Text("Estudante"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: "Instituição",
                    child: Row(
                      children: [
                        Icon(Icons.apartment_rounded),
                        SizedBox(width: 8),
                        Text("Instituição"),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'explorar',
                    child: Text('Explorar'),
                  ),
                  const PopupMenuItem(
                    value: 'parcerias',
                    child: Text('Parcerias'),
                  ),
                  const PopupMenuItem(value: 'sobre', child: Text('Sobre')),
                  const PopupMenuItem(value: 'ajuda', child: Text('Ajuda')),
                ],
              ),

              const SizedBox(width: 8),
            ],
          ],
  );
}

Widget _menuButton({required String text, required VoidCallback onPressed}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(
        color: AppColors.colors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
