import 'package:go_router/go_router.dart';
import 'package:mitos_y_leyendas_app/presentation/screens/screens.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
