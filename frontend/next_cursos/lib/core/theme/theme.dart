import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color textOnPrimary;
  final Color textInBackGround;
  final Color outFocus;
  final Color menusBackground;
  final Color shadow;
  final Color positiveHighlights;
  final Color negativeHighlights;
  final Color middleHighlights;

  const AppColors({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textOnPrimary,
    required this.textInBackGround,
    required this.outFocus,
    required this.menusBackground,
    required this.shadow,
    required this.positiveHighlights,
    required this.negativeHighlights,
    required this.middleHighlights,
  });

  static const AppColors colors = AppColors(
    primary: Color.fromARGB(255, 15, 32, 80),
    secondary: Colors.white,
    background: Color.fromARGB(255, 225, 230, 255),
    surface: Color.fromARGB(255, 25, 70, 170),
    accent: Color.fromARGB(255, 120, 200, 255),
    textPrimary: Colors.white,
    textSecondary: Color.fromARGB(255, 0, 159, 255),
    textOnPrimary: Colors.white,
    textInBackGround: Color.fromARGB(255, 15, 32, 80),
    outFocus: Color.fromARGB(255, 110, 160, 255),
    menusBackground: Color.fromARGB(255, 20, 60, 140),
    shadow: Color.fromARGB(255, 30, 45, 70),
    positiveHighlights: Color.fromARGB(255, 46, 184, 92),
    negativeHighlights: Color.fromARGB(255, 229, 72, 77),
    middleHighlights: Color.fromARGB(255, 255, 193, 7),
  );
}

abstract class AppTextStyles {
  static String? fontFamily = GoogleFonts.poppins().fontFamily;
  static String? fontFamilyDois = GoogleFonts.phudu().fontFamily;

  static TextStyle titleLarge() => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.colors.textPrimary,
    fontFamily: fontFamilyDois,
  );

  static TextStyle titleMedium() => TextStyle(
    fontSize: 16,
    color: AppColors.colors.textPrimary,
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
  );

  static TextStyle titleSmall() => TextStyle(
    fontSize: 14,
    color: AppColors.colors.textPrimary,
    fontFamily: fontFamily,
  );

  static TextStyle inputStyle() =>
      TextStyle(color: AppColors.colors.textPrimary, fontFamily: fontFamily);

  static TextStyle appBarTitle() => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.colors.textOnPrimary,
    fontFamily: fontFamilyDois,
  );

  static TextStyle textModal() => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.colors.textOnPrimary,
    fontFamily: fontFamily,
  );

  static TextStyle titleModal() => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.colors.textOnPrimary,
    fontFamily: fontFamily,
  );
  static TextStyle popupMenu() => TextStyle(
    fontSize: 30,
    color: AppColors.colors.textPrimary,
    fontFamily: fontFamilyDois,
  );
}

/// Tema principal do app
class AppTheme {
  static ThemeData fromColors() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.colors.primary,
      brightness: Brightness.light,
      primary: AppColors.colors.primary,
      secondary: AppColors.colors.surface,
      surface: AppColors.colors.surface,
      background: AppColors.colors.background,
      onPrimary: AppColors.colors.textOnPrimary,
      onSecondary: AppColors.colors.textPrimary,
      onSurface: AppColors.colors.textPrimary,
      onBackground: AppColors.colors.textInBackGround,
      error: Colors.red,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      primaryColor: AppColors.colors.primary,
      scaffoldBackgroundColor: AppColors.colors.background,

      fontFamily: AppTextStyles.fontFamily,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.colors.surface,
        foregroundColor: AppColors.colors.textOnPrimary,
        centerTitle: false,
        elevation: 0,
        shadowColor: AppColors.colors.shadow,
        titleTextStyle: AppTextStyles.appBarTitle(),
        iconTheme: IconThemeData(
          color: AppColors.colors.textOnPrimary,
          size: 28,
        ),
        actionsIconTheme: IconThemeData(
          color: AppColors.colors.textOnPrimary,
          size: 28,
        ),
      ),

      textTheme: TextTheme(
        titleLarge: AppTextStyles.titleLarge(),
        titleMedium: AppTextStyles.titleMedium(),
        titleSmall: AppTextStyles.titleSmall(),
        bodyLarge: AppTextStyles.inputStyle(),
        bodyMedium: AppTextStyles.inputStyle(),
        bodySmall: AppTextStyles.inputStyle(),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 7,
          backgroundColor: AppColors.colors.primary,
          foregroundColor: AppColors.colors.textPrimary,
          disabledBackgroundColor: AppColors.colors.outFocus,
          disabledForegroundColor: AppColors.colors.textSecondary,
          textStyle: AppTextStyles.titleModal(),
          iconColor: AppColors.colors.textPrimary,
          disabledIconColor: AppColors.colors.textSecondary,
          shadowColor: AppColors.colors.shadow,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.colors.textPrimary,
          disabledForegroundColor: AppColors.colors.outFocus,
          textStyle: AppTextStyles.titleMedium(),
          iconColor: AppColors.colors.textPrimary,
          disabledIconColor: AppColors.colors.outFocus,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.colors.secondary,
          disabledForegroundColor: AppColors.colors.outFocus,
          textStyle: AppTextStyles.titleMedium(),
          iconColor: AppColors.colors.secondary,
          disabledIconColor: AppColors.colors.outFocus,
          side: BorderSide(color: AppColors.colors.secondary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.colors.primary,
        foregroundColor: AppColors.colors.textOnPrimary,
        hoverElevation: 10,
        elevation: 5,
        iconSize: 30,
        extendedTextStyle: AppTextStyles.textModal(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),

      iconTheme: IconThemeData(color: AppColors.colors.primary, size: 24),

      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconSize: const WidgetStatePropertyAll(28),
          foregroundColor: WidgetStatePropertyAll(
            AppColors.colors.textOnPrimary,
          ),
          iconColor: WidgetStatePropertyAll(AppColors.colors.textOnPrimary),
          overlayColor: WidgetStatePropertyAll(
            AppColors.colors.accent.withOpacity(0.25),
          ),
        ),
      ),

      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          maximumSize: WidgetStatePropertyAll(Size.fromHeight(300)),
          minimumSize: WidgetStatePropertyAll(Size.fromHeight(300)),
          backgroundColor: WidgetStatePropertyAll(
            AppColors.colors.menusBackground,
          ),
          elevation: const WidgetStatePropertyAll(5),
          shadowColor: WidgetStatePropertyAll(AppColors.colors.shadow),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),

        textStyle: AppTextStyles.titleMedium(),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.colors.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.colors.textPrimary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.colors.outFocus, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          hintStyle: AppTextStyles.inputStyle().copyWith(
            color: AppColors.colors.outFocus,
          ),
          labelStyle: AppTextStyles.inputStyle().copyWith(
            color: AppColors.colors.outFocus,
          ),
          helperStyle: AppTextStyles.inputStyle().copyWith(
            color: AppColors.colors.textPrimary,
          ),
          floatingLabelStyle: AppTextStyles.inputStyle(),
          suffixIconColor: AppColors.colors.outFocus,
          prefixIconColor: AppColors.colors.outFocus,
        ),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.colors.menusBackground,
        textStyle: AppTextStyles.popupMenu(),
        elevation: 5,
        shadowColor: AppColors.colors.shadow,
        iconColor: AppColors.colors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        linearMinHeight: 12,
        linearTrackColor: AppColors.colors.shadow,
        color: AppColors.colors.accent,
        borderRadius: BorderRadius.circular(20),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.colors.surface,
        disabledColor: AppColors.colors.outFocus,
        selectedColor: AppColors.colors.accent,
        secondarySelectedColor: AppColors.colors.accent,
        labelStyle: AppTextStyles.titleSmall(),
        secondaryLabelStyle: AppTextStyles.titleSmall().copyWith(
          color: AppColors.colors.textOnPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: AppColors.colors.outFocus, width: 2),
      ),

      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.colors.menusBackground,
        scrimColor: AppColors.colors.background.withOpacity(0.5),
        elevation: 5,
        shadowColor: AppColors.colors.shadow,
      ),

      cardTheme: CardThemeData(
        color: AppColors.colors.menusBackground,
        elevation: 5,
        shadowColor: AppColors.colors.shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      dividerTheme: DividerThemeData(
        color: AppColors.colors.outFocus,
        thickness: 1,
        space: 10,
        indent: 10,
        endIndent: 10,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.colors.menusBackground,
        contentTextStyle: AppTextStyles.titleSmall(),
        actionTextColor: AppColors.colors.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.colors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.colors.textPrimary, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.colors.outFocus, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        hintStyle: AppTextStyles.inputStyle().copyWith(
          color: AppColors.colors.outFocus,
        ),
        labelStyle: AppTextStyles.inputStyle().copyWith(
          color: AppColors.colors.outFocus,
        ),
        floatingLabelStyle: AppTextStyles.inputStyle(),
        errorStyle: AppTextStyles.inputStyle().copyWith(color: Colors.red),
        helperStyle: AppTextStyles.inputStyle().copyWith(
          color: AppColors.colors.textPrimary.withOpacity(0.75),
        ),
        suffixIconColor: AppColors.colors.outFocus,
        prefixIconColor: AppColors.colors.outFocus,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.colors.menusBackground,
        titleTextStyle: AppTextStyles.titleMedium(),
        contentTextStyle: AppTextStyles.titleMedium().copyWith(
          color: AppColors.colors.outFocus,
        ),
        elevation: 5,
        shadowColor: AppColors.colors.shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.colors.primary;
          }
          return AppColors.colors.outFocus;
        }),
        checkColor: WidgetStatePropertyAll(AppColors.colors.textOnPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.colors.textOnPrimary;
          }
          return AppColors.colors.outFocus;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.colors.primary;
          }
          return AppColors.colors.shadow;
        }),
        trackOutlineColor: WidgetStatePropertyAll(AppColors.colors.primary),
        trackOutlineWidth: const WidgetStatePropertyAll(2),
        overlayColor: WidgetStatePropertyAll(
          AppColors.colors.accent.withOpacity(0.25),
        ),
      ),
    );
  }
}
