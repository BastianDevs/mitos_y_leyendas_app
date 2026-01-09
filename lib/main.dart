import 'package:flutter/material.dart';
import 'package:mitos_y_leyendas_app/config/router/app_router.dart';
import 'package:mitos_y_leyendas_app/config/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Punto de entrada de la aplicación.
///
/// Envuelve la app en [ProviderScope] para habilitar Riverpod
/// en todo el árbol de widgets.
void main() {
  runApp(const ProviderScope(child: MainApp()));
}

/// Widget raíz de la aplicación.
///
/// Configura:
/// - Navegación declarativa con GoRouter
/// - Tema global de la aplicación
/// - Eliminación del banner de debug
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
    );
  }
}
