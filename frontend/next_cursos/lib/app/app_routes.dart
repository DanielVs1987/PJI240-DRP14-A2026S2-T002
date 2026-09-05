import 'package:flutter/material.dart';
import '../core/auth/auth_service.dart';
import '../features/home/home_page.dart';
import '../features/oportunidades/models/oportunidade.dart';
import '../features/oportunidades/pages/oportunidade_detail_page.dart';
import '../features/estudante/pages/estudante_dashboard_page.dart';
import '../features/instituicao/pages/instituicao_dashboard_page.dart';
import '../features/oportunidades/pages/oportunidade_form_page.dart';
import '../features/oportunidades/pages/oportunidades_list_page.dart';
import '../features/oportunidades/pages/oportunidade_inscritos_page.dart';
import '../features/inscricoes/pages/inscricao_form_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String oportunidadeDetalhe = '/oportunidade-detalhe';
  static const String estudanteDashboard = '/estudante-dashboard';
  static const String instituicaoDashboard = '/instituicao-dashboard';
  static const String oportunidadesLista = '/oportunidades-lista';
  static const String oportunidadeFormulario = '/oportunidade-formulario';
  static const String oportunidadeInscritos = '/oportunidade-inscritos';
  static const String inscricaoFormulario = '/inscricao-formulario';

  static Map<String, WidgetBuilder> routes() {
    return {
      home: (context) => const HomePage(),
      oportunidadeDetalhe: (context) {
        final arguments = ModalRoute.of(context)!.settings.arguments;

        if (arguments is Oportunidade) {
          return OportunidadeDetailPage(oportunidade: arguments);
        }

        return const Scaffold(
          body: Center(child: Text('Oportunidade não encontrada.')),
        );
      },

      oportunidadeFormulario: (context) {
        final oportunidade =
            ModalRoute.of(context)!.settings.arguments as Oportunidade?;
        return OportunidadeFormPage(oportunidade: oportunidade);
      },

      oportunidadeInscritos: (context) {
        final oportunidade =
            ModalRoute.of(context)!.settings.arguments as Oportunidade;
        return OportunidadeInscritosPage(oportunidade: oportunidade);
      },

      inscricaoFormulario: (context) {
        final oportunidade =
            ModalRoute.of(context)!.settings.arguments as Oportunidade;
        return InscricaoFormPage(oportunidade: oportunidade);
      },

      estudanteDashboard: (context) => const EstudanteDashboardPage(),
      instituicaoDashboard: (context) => const InstituicaoDashboardPage(),
      oportunidadesLista: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as OportunidadesListArgs;
        return OportunidadesListPage(args: args);
      },
    };
  }
}
