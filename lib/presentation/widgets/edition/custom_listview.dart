import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mitos_y_leyendas_app/domain/entities/edition.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/edition/edition_provider.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';

/// Listado scrolleable de ediciones disponibles en la app.
///
/// Responsabilidades:
/// - Escuchar el provider de ediciones con Riverpod
/// - Renderizar una lista optimizada de tarjetas de edición
/// - Envolver cada tarjeta en [AnimatedEditionCard] para la animación de entrada
/// - Delegar el diseño visual de cada ítem a [EditionCard]
class EditionListView extends ConsumerWidget {
  const EditionListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Lista de ediciones disponibles, obtenida de forma síncrona.
    /// Al ser un provider síncrono, no hay estado de carga ni error:
    /// las ediciones se definen localmente, no desde la API.
    final editions = ref.watch(editionProvider);

    return ListView.builder(
      padding: const EdgeInsets.all(12),

      itemCount: editions.length,

      /// [ListView.builder] renderiza solo los elementos visibles en pantalla,
      /// lo que lo hace eficiente independientemente del tamaño de la lista.
      itemBuilder: (context, index) {
        final edition = editions[index];

        /// Cada tarjeta se envuelve en [AnimatedEditionCard] para aplicar
        /// una animación de entrada escalonada según su posición en la lista.
        /// El [index] determina el delay de la animación de cada ítem.
        return AnimatedEditionCard(
          index: index,
          child: EditionCard(edition: edition),
        );
      },
    );
  }
}

/// Tarjeta visual de una edición del juego.
///
/// Al tocarla navega a [CardsScreen] pasando el [EditionEntity.slug]
/// como parámetro de ruta para que la pantalla de cartas sepa
/// qué edición debe cargar.
///
/// Estructura visual (Stack de tres capas):
/// - Imagen de fondo local desde assets
/// - Overlay con gradiente para mejorar contraste del texto
/// - Título de la edición posicionado en la parte inferior
class EditionCard extends StatelessWidget {
  final EditionEntity edition;

  const EditionCard({super.key, required this.edition});

  @override
  Widget build(BuildContext context) {
    /// Imagen local usada como fondo de todas las tarjetas.
    /// Al no depender de la API, siempre está disponible sin carga ni errores.
    /// En el futuro puede reemplazarse por una imagen específica por edición.
    const fallbackImage = 'assets/images/edicion.jpg';

    return InkWell(
      /// Navega a la pantalla de cartas de la edición seleccionada.
      /// Usa [pushNamed] para mantener la pantalla de ediciones en el stack
      /// y permitir que el usuario vuelva atrás con el botón de retorno.
      onTap: () {
        context.pushNamed(
          'cards-screen',
          pathParameters: {'editionSlug': edition.slug},
        );
      },

      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 10,

        /// [Clip.antiAlias] es necesario para que la imagen respete
        /// los bordes redondeados del [Card] sin desbordarse.
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,

        child: Stack(
          children: [
            /// IMAGEN DE FONDO
            ///
            /// [AspectRatio] fija las proporciones de la tarjeta (2:1)
            /// para que todas las ediciones tengan el mismo alto
            /// independientemente del tamaño de pantalla.
            AspectRatio(
              aspectRatio: 10 / 5,
              child: Image.asset(fallbackImage, fit: BoxFit.cover),
            ),

            /// OVERLAY DE GRADIENTE
            ///
            /// Capa semitransparente que oscurece la parte inferior de la imagen,
            /// asegurando que el texto blanco sea legible sobre cualquier imagen.
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

            /// TÍTULO DE LA EDICIÓN
            ///
            /// Posicionado en la esquina inferior izquierda sobre el gradiente.
            /// [maxLines: 2] con ellipsis cubre ediciones con nombres largos.
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(
                edition.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
