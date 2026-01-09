import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/card/card_provider.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/edition/edition_provider.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';

/// Pantalla que muestra las cartas pertenecientes a una edición.
///
/// - Recibe el `editionSlug` desde la navegación
/// - Consulta la información de la edición y sus cartas usando Riverpod
/// - Renderiza un grid de cartas o estados de carga/error
class CardsScreen extends ConsumerWidget {
  /// Slug de la edición seleccionada (ej: "samurai", "sombra", etc.)
  /// Se utiliza para obtener los datos desde los providers.
  final String editionSlug;

  const CardsScreen({super.key, required this.editionSlug});

  /// Nombre de la ruta utilizada por GoRouter
  static const name = 'cards-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Obtiene la edición según el slug.
    /// Puede ser null si aún no se ha cargado o no existe.
    final edition = ref.watch(editionBySlugProvider(editionSlug));

    /// Obtiene de forma asíncrona las cartas asociadas a la edición.
    /// Devuelve un AsyncValue<List<CardEntity>>
    final cardsAsync = ref.watch(cardsByEditionProvider(editionSlug));

    return Scaffold(
      /// AppBar personalizada.
      /// Muestra el título de la edición si está disponible,
      /// o un texto genérico mientras se carga.
      appBar: CustomAppbar(title: edition?.title ?? 'Cartas'),

      /// Cuerpo de la pantalla controlado por el estado asíncrono
      body: Column(
        children: [
          CustomSearchAnchor(),
          Expanded(
            child: cardsAsync.when(
              /// Estado exitoso: se reciben las cartas
              data: (cards) {
                /// Renderiza el grid de cartas
                return CustomGridview(cards: cards);
              },

              /// Estado de error: muestra el mensaje de error
              error: (error, _) {
                return Center(child: Text(error.toString()));
              },

              /// Estado de carga: indicador visual mientras se obtienen los datos
              loading: () {
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
