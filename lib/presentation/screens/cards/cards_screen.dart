import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/card/card_provider.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/edition/edition_provider.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';

/// Pantalla que muestra las cartas pertenecientes a una edición.
///
/// Recibe el [editionSlug] desde GoRouter y lo usa como parámetro
/// para consultar tanto la información de la edición como su listado
/// de cartas. Maneja tres estados visuales: carga, error y datos.
class CardsScreen extends ConsumerWidget {
  /// Identificador único de la edición en la API de MyL.
  /// Ejemplos: "samurai", "sombra", "imperio-alianza".
  /// Se usa como parámetro de familia en los providers.
  final String editionSlug;

  const CardsScreen({super.key, required this.editionSlug});

  /// Nombre de la ruta usado por GoRouter para la navegación declarativa.
  static const name = 'cards-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Edición correspondiente al slug, obtenida de forma síncrona
    /// desde el provider de ediciones ya cargadas en memoria.
    /// Retorna null si la edición aún no está disponible,
    /// en cuyo caso el AppBar muestra un título genérico.
    final edition = ref.watch(editionBySlugProvider(editionSlug));

    /// Estado asíncrono de las cartas de la edición.
    /// Puede ser [AsyncLoading], [AsyncError] o [AsyncData].
    /// Se mantiene en memoria gracias a ref.keepAlive(),
    /// evitando re-fetches al navegar entre pantallas.
    final cardsAsync = ref.watch(cardsByEditionProvider(editionSlug));

    return Scaffold(
      /// Muestra el nombre real de la edición cuando está disponible.
      /// Mientras carga o si no se encuentra, muestra 'Cartas' como fallback.
      appBar: CustomAppbar(title: edition?.title ?? 'Cartas'),

      body: Column(
        children: [
          SizedBox(height: 8),

          /// Barra de búsqueda que filtra las cartas en cliente,
          /// sin realizar nuevas llamadas a la API.
          CustomSearchAnchor(editionSlug),

          SizedBox(height: 5),

          /// El grid ocupa todo el espacio vertical restante
          Expanded(
            child: cardsAsync.when(
              /// ESTADO: datos recibidos correctamente.
              ///
              /// Si la lista está vacía (edición sin cartas o búsqueda
              /// sin resultados), muestra un empty state con ícono y mensaje.
              /// Si hay cartas, renderiza el grid interactivo.
              data: (cards) {
                if (cards.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.style_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No se encontraron cartas, revisa tu conexión o intenta en otro momento',
                        ),
                      ],
                    ),
                  );
                }
                return CustomGridview(cards: cards);
              },

              /// ESTADO: error al cargar las cartas.
              ///
              /// Muestra un mensaje amigable (sin exponer el error técnico)
              /// y un botón que invalida el provider para forzar un nuevo
              /// request a la API, permitiendo al usuario recuperarse
              /// sin necesidad de reiniciar la app.
              error: (error, _) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_off_outlined,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No se pudieron cargar las cartas',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),

                      /// ref.invalidate destruye el estado actual del provider
                      /// y lo recrea, lo que dispara un nuevo request a la API.
                      TextButton.icon(
                        onPressed:
                            () => ref.invalidate(
                              cardsByEditionProvider(editionSlug),
                            ),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              },

              /// ESTADO: carga en progreso.
              ///
              /// Muestra un grid de tarjetas skeleton con animación shimmer
              /// que replica el layout real, evitando saltos visuales
              /// cuando los datos llegan y reemplazan el placeholder.
              loading: () => const CustomGridviewSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}
