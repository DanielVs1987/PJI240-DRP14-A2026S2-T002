import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/theme/theme.dart';

Widget nomeApp(BuildContext context) {
  return Row(
    children: [
      InkWell(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        },
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.colors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.school_rounded,
            color: AppColors.colors.textPrimary,
            size: 26,
          ),
        ),
      ),

      const SizedBox(width: 12),

      Text(
        'Next Cursos',
        style: AppTextStyles.titleLarge().copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.colors.textPrimary,
        ),
      ),
    ],
  );
}