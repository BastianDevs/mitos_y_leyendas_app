import 'package:go_router/go_router.dart';
import 'package:mitos_y_leyendas_app/presentation/screens/screens.dart';

/// Router principal de la aplicación usando GoRouter.
///
/// Define las rutas disponibles y cómo se construyen
/// las pantallas asociadas a cada una.
final appRouter = GoRouter(
  routes: [
    /// Ruta raíz de la aplicación (`/`)
    ///
    /// - Es la primera pantalla que se muestra al iniciar la app
    /// - Generalmente corresponde al Home o pantalla principal
    GoRoute(
      path: '/',
      name:
          HomeScreen.name, // Nombre de la ruta (usado por goNamed / pushNamed)
      builder: (context, state) => const HomeScreen(),
    ),

    /// Ruta para mostrar las cartas de una edición específica
    ///
    /// - Recibe un parámetro dinámico en la URL (`editionSlug`)
    /// - Ejemplo de URL: /cards/samurai
    GoRoute(
      path: '/cards/:editionSlug',
      name: CardsScreen.name, // Nombre de la ruta
      builder: (context, state) {
        /// Obtiene el parámetro `editionSlug` desde la URL
        /// El `!` indica que asumimos que siempre viene presente
        final slug = state.pathParameters['editionSlug']!;

        /// Construye la pantalla de cartas pasando el slug
        return CardsScreen(editionSlug: slug);
      },
    ),
  ],
);
