import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:next_cursos/core/theme/theme.dart';

Widget buildFooter() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
    color: AppColors.colors.primary,
    child: Center(
      child: Text(
        '© 2026 Next Cursos • Projeto Integrador UNIVESP',
        style: TextStyle(color: AppColors.colors.textPrimary),
      ),
    ),
  );
}