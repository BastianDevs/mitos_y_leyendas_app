import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mitos_y_leyendas_app/domain/entities/edition.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/edition/edition_provider.dart';

/// Listado de ediciones.
///
/// - Consume el estado desde Riverpod usando [ConsumerWidget]
/// - Escucha el provider de ediciones
/// - Renderiza una lista scrollable de [EditionCard]
class EditionListView extends ConsumerWidget {
  const EditionListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Obtiene la lista de ediciones desde el provider.
    /// El widget se reconstruirá automáticamente si este estado cambia.
    final editions = ref.watch(editionProvider);

    return ListView.builder(
      /// Padding general del listado
      padding: const EdgeInsets.all(12),

      /// Cantidad total de elementos a renderizar
      itemCount: editions.length,

      /// Builder que se ejecuta solo para los ítems visibles
      itemBuilder: (context, index) {
        /// Edición actual según el índice
        final edition = editions[index];

        /// Cada edición se representa con una tarjeta independiente
        return EditionCard(edition: edition);
      },
    );
  }
}

/// Tarjeta visual que representa una edición.
///
/// - Muestra el título y la imagen de la edición
/// - Permite navegación a la pantalla de cartas asociadas
class EditionCard extends StatelessWidget {
  /// Entidad que contiene la información de la edición
  final EditionEntity edition;

  const EditionCard({super.key, required this.edition});

  @override
  Widget build(BuildContext context) {
    /// URL de la imagen de la edición construida dinámicamente
    final imageUrl = 'https://api.myl.cl/static/${edition.slug}.png';

    return InkWell(
      /// Navega a la pantalla de cartas al hacer tap en la tarjeta
      onTap: () {
        context.pushNamed(
          'cards-screen',
          pathParameters: {
            /// Se pasa el slug para cargar las cartas de la edición
            'editionSlug': edition.slug,
          },
        );
      },

      /// Card de Material Design que da elevación y bordes redondeados
      child: Card(
        /// Separación entre tarjetas
        margin: const EdgeInsets.only(bottom: 12),

        /// Profundidad de sombra
        elevation: 8,
        shadowColor: Colors.black26,

        /// Forma de la tarjeta
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        /// Recorta el contenido respetando el borderRadius
        clipBehavior: Clip.antiAlias,

        /// Color de fondo de la tarjeta
        color: Colors.white,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================
            // TÍTULO DE LA EDICIÓN
            // =====================
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                edition.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 5),

            // =====================
            // IMAGEN DE LA EDICIÓN
            // =====================
            SizedBox(
              /// Altura fija para evitar saltos de layout
              height: 100,
              child: Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,

                  /// Indicador de carga mientras la imagen se descarga
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        color: Colors.grey,
                      ),
                    );
                  },

                  /// Imagen de respaldo si ocurre un error de carga
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/no_image.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
