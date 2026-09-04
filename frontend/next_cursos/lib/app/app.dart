import 'package:flutter/material.dart';
import 'package:next_cursos/app/app_routes.dart';
import 'package:next_cursos/core/auth/auth_service.dart';
import 'package:next_cursos/core/theme/theme.dart';

class NextCursos extends StatelessWidget {
  const NextCursos({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    
    String initialRoute = AppRoutes.home;
    
    if (auth.isAuthenticated) {
      initialRoute = auth.isEstudante 
          ? AppRoutes.estudanteDashboard 
          : AppRoutes.instituicaoDashboard;
    }

    return MaterialApp(
      title: "Next Cursos",
      initialRoute: initialRoute,
      theme: AppTheme.fromColors(),
      routes: AppRoutes.routes(),
      debugShowCheckedModeBanner: false,
    );
  }
}
