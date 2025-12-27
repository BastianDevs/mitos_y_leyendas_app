import 'package:go_router/go_router.dart';
import 'package:mitos_y_leyendas_app/presentation/screens/cards/cards_screen.dart';
import 'package:mitos_y_leyendas_app/presentation/screens/screens.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/cards/:editionSlug',
      name: CardsScreen.name,
      builder: (context, state) {
        final slug = state.pathParameters['editionSlug']!;
        return CardsScreen(editionSlug: slug);
      },
    ),
  ],
);
