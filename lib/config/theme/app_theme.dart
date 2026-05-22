import 'package:flutter/material.dart';

/// Configuración global de temas de la aplicación.
///
/// Centraliza colores, tipografías y estilos visuales para
/// modo claro y oscuro. Ambos temas usan el mismo [colorSchemeSeed]
/// para mantener consistencia de marca — Flutter genera
/// automáticamente la paleta completa a partir de ese color.
class AppTheme {
  /// Color de marca usado como semilla para generar la paleta completa.
  /// Se define como constante para garantizar que ambos temas
  /// usen exactamente el mismo valor.
  static const _seedColor = Color.fromARGB(255, 18, 185, 85);

  /// Retorna el tema claro usado por [MaterialApp.theme].
  ///
  /// - [brightness]: declara explícitamente el modo claro
  /// - [colorSchemeSeed]: genera la paleta de colores automáticamente
  /// - [appBarTheme]: fondo verde sólido de marca con texto blanco
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: _seedColor,

    appBarTheme: const AppBarTheme(
      /// Centra el título horizontalmente
      centerTitle: true,

      /// Elimina la sombra inferior del AppBar
      elevation: 0,

      /// Verde de marca como fondo del AppBar en modo claro
      backgroundColor: Colors.green,

      /// Estilo base del título.
      /// El tamaño puede reducirse dinámicamente en el widget
      /// mediante [AutoSizeText] si el texto es muy largo.
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    ),
  );

  /// Retorna el tema oscuro usado por [MaterialApp.darkTheme].
  ///
  /// - [brightness]: declara explícitamente el modo oscuro
  /// - [colorSchemeSeed]: misma semilla que el tema claro para consistencia
  /// - [appBarTheme]: sin [backgroundColor] explícito para que Flutter
  ///   use el color de superficie oscuro generado automáticamente,
  ///   evitando que el verde sólido resulte agresivo sobre fondos oscuros.
  ThemeData getDarkTheme() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: const Color.fromARGB(127, 18, 185, 85),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(
        255,
        3,
        53,
        4,
      ), // Deja que Flutter elija el color de superficie oscur
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    ),
  );
}
