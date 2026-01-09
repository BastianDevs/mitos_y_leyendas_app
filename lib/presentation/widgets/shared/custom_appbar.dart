import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

/// AppBar reutilizable de la aplicación.
/// - Usa el theme global definido en AppTheme
/// - Ajusta automáticamente el tamaño del título si es muy largo
class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  /// Texto que se mostrará como título del AppBar
  final String title;

  const CustomAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      /// Título con tamaño dinámico
      /// AutoSizeText reduce el tamaño si el texto no cabe en una sola línea
      title: AutoSizeText(
        title,

        /// Máximo de líneas permitidas
        maxLines: 1,

        /// Tamaño máximo del texto (coincide con el definido en el theme)
        maxFontSize: 25,

        /// Tamaño mínimo al que puede reducirse
        minFontSize: 14,

        /// Si aún no cabe, se muestra con puntos suspensivos
        overflow: TextOverflow.ellipsis,

        /// Usa el estilo definido en AppTheme.appBarTheme
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),

      /// Centra el título horizontalmente
      centerTitle: true,
    );
  }

  /// Altura estándar del AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
