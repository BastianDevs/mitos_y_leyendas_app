import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitos_y_leyendas_app/config/router/app_router.dart';
import 'package:mitos_y_leyendas_app/config/theme/app_theme.dart';

/// Controla el modo de tema activo en toda la aplicación.
///
/// - [ThemeMode.system]: sigue la preferencia del sistema operativo
/// - [ThemeMode.light]: fuerza el modo claro
/// - [ThemeMode.dark]: fuerza el modo oscuro
///
/// Se declara global para ser accesible desde cualquier widget,
/// incluido [CustomAppbar] donde vive el botón de cambio de tema.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

/// Notifier que mantiene y expone el modo de tema activo.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  /// Alterna entre modo claro y oscuro
  void toggle(ThemeMode mode) => state = mode;
}

/// Punto de entrada principal de la aplicación.
///
/// Responsabilidades:
/// - Inicializar el binding de Flutter.
/// - Mantener el splash screen nativo mientras la app se prepara.
/// - Inyectar Riverpod mediante [ProviderScope].
void main() {
  /// Garantiza que Flutter esté completamente inicializado
  /// antes de ejecutar cualquier lógica adicional.
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// Mantiene visible el splash screen nativo
  /// hasta que la app esté lista.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// Ejecuta la aplicación dentro del scope de Riverpod,
  /// habilitando el sistema de providers en todo el árbol de widgets.
  runApp(const ProviderScope(child: MainApp()));
}

/// Widget raíz de la aplicación.
///
/// Responsabilidades:
/// - Configurar la navegación con GoRouter.
/// - Definir el tema global.
/// - Observar [themeModeProvider] para reaccionar al cambio de tema.
/// - Controlar la eliminación del splash screen.
/// - Deshabilitar el banner de debug.
class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();

    /// Ejecuta la inicialización de la aplicación.
    _initializeApp();
  }

  /// Simula un proceso de inicialización de la app.
  ///
  /// Aquí podrías agregar en el futuro:
  /// - Precarga de datos
  /// - Inicialización de servicios
  /// - Validación de sesión del usuario
  /// - Configuración de dependencias
  ///
  /// Una vez finalizado el proceso, se elimina el splash screen.
  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));

    /// Oculta el splash screen nativo
    /// cuando la app está lista para mostrarse.
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    /// Este widget se reconstruye y aplica el nuevo tema globalmente.
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      /// Oculta la etiqueta "DEBUG" en modo desarrollo.
      debugShowCheckedModeBanner: false,

      /// Configuración de rutas usando GoRouter.
      routerConfig: appRouter,

      /// Tema global de la aplicación. (Tema Claro)
      theme: AppTheme().getTheme(),

      /// Tema oscuro — misma semilla de color, paleta adaptada por Flutter
      darkTheme: AppTheme().getDarkTheme(),

      /// Modo activo controlado por [themeModeProvider]
      themeMode: themeMode,
    );
  }
}
