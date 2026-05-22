import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitos_y_leyendas_app/main.dart';

/// AppBar reutilizable de la aplicación.
/// - Usa el theme global definido en AppTheme
/// - Ajusta automáticamente el tamaño del título si es muy largo
/// - Incluye botón para alternar entre modo claro y oscuro
class CustomAppbar extends ConsumerWidget implements PreferredSizeWidget {
  /// Texto que se mostrará como título del AppBar
  final String title;

  const CustomAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Modo de tema activo, usado para determinar qué ícono mostrar
    final themeMode = ref.watch(themeModeProvider);

    /// Determina si el tema oscuro está activo considerando tanto
    /// la selección manual como la preferencia del sistema operativo.
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

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

      /// Botón de alternancia de tema posicionado a la derecha del AppBar.
      ///
      /// Alterna entre [ThemeMode.dark] y [ThemeMode.light] al presionar.
      /// El ícono refleja el modo activo:
      /// - Sol → actualmente en modo oscuro, presionar activa modo claro
      /// - Luna → actualmente en modo claro, presionar activa modo oscuro
      actions: [
        IconButton(
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          color: Colors.white,
          tooltip: isDark ? 'Activar modo claro' : 'Activar modo oscuro',
          onPressed: () {
            ref
                .read(themeModeProvider.notifier)
                .toggle(isDark ? ThemeMode.light : ThemeMode.dark);
          },
        ),
      ],
    );
  }

  /// Altura estándar del AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
