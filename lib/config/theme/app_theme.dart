import 'package:flutter/material.dart';

/// Tema principal de la aplicación.
/// Centraliza colores, tipografías y estilos visuales globales.
class AppTheme {
  /// Retorna la configuración de [ThemeData] usada por MaterialApp
  ThemeData getTheme() => ThemeData(
    /// Habilita Material Design 3 (Material You)
    /// Mejora animaciones, colores dinámicos y consistencia visual
    useMaterial3: true,

    /// Color base desde el cual Flutter genera automáticamente
    /// la paleta de colores (primario, secundario, etc.)
    colorSchemeSeed: const Color.fromARGB(255, 18, 185, 85),

    /// Configuración global para todos los AppBar de la app
    appBarTheme: const AppBarTheme(
      /// Centra el título horizontalmente
      centerTitle: true,

      /// Elimina la sombra inferior del AppBar
      elevation: 0,

      /// Color de fondo del AppBar
      backgroundColor: Colors.green,

      /// Estilo de texto base para los títulos del AppBar
      /// El tamaño puede ser ajustado dinámicamente en el widget
      /// (por ejemplo usando AutoSizeText)
      titleTextStyle: TextStyle(
        color: Colors.white, // Color del texto
        fontWeight: FontWeight.bold, // Texto en negrita
        fontSize: 25, // Tamaño base del título
      ),
    ),
  );
}
