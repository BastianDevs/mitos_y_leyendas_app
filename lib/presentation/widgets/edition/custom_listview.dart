import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mitos_y_leyendas_app/domain/entities/edition.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/edition/edition_provider.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';

/// Listado de ediciones.
///
/// Responsabilidades:
/// - Escuchar el provider de ediciones con Riverpod
/// - Renderizar una lista optimizada de tarjetas de edición
/// - Delegar el diseño visual a [EditionCard]
class EditionListView extends ConsumerWidget {
  const EditionListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Obtiene la lista de ediciones desde Riverpod.
    /// Si el provider cambia, la lista se reconstruye automáticamente.
    final editions = ref.watch(editionProvider);

    return ListView.builder(
      /// Espaciado general del listado
      padding: const EdgeInsets.all(12),

      /// Cantidad total de elementos
      itemCount: editions.length,

      /// Renderiza solo los elementos visibles (mejor performance)
      itemBuilder: (context, index) {
        final edition = editions[index];

        /// Animación de las card de edition
        return AnimatedEditionCard(
          index: index,
          child: EditionCard(edition: edition),
        );
      },
    );
  }
}

/// Tarjeta visual de una edición.
///
/// - Usa solo imagen local (assets)
/// - Diseño limpio y consistente
/// - Texto legible con overlay
class EditionCard extends StatelessWidget {
  final EditionEntity edition;

  const EditionCard({super.key, required this.edition});

  @override
  Widget build(BuildContext context) {
    const fallbackImage = 'assets/images/edicion.jpg';

    return InkWell(
      onTap: () {
        context.pushNamed(
          'cards-screen',
          pathParameters: {'editionSlug': edition.slug},
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            /// Imagen local fija (no depende de la API)
            AspectRatio(
              aspectRatio: 10 / 5,
              child: Image.asset(fallbackImage, fit: BoxFit.cover),
            ),

            /// Overlay para mejorar legibilidad del texto
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
              ),
            ),

            /// Título de la edición
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(
                edition.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
