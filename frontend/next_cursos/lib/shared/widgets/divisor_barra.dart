import 'package:flutter/cupertino.dart';

import '../../core/theme/theme.dart';

Widget divisorBarra(double altura) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(color: AppColors.colors.secondary, width: 2, height: altura),
  );
}
