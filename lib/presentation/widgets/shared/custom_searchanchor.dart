import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/card/filteredcards_provider.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/card/searchcard_provider.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

/// Widget de búsqueda personalizado basado en [SearchAnchor].
///
/// Responsabilidades:
/// - Gestionar el ciclo de vida del [SearchController]
/// - Capturar el texto ingresado por el usuario y enviarlo a Riverpod
/// - Delegar la lógica de filtrado a [filteredCardsProvider]
/// - Renderizar sugerencias con estados de carga, error y datos
///
/// Notas de arquitectura:
/// - La UI solo emite eventos (onChanged) y observa estado (ref.watch)
/// - El filtrado vive en Riverpod, no en este widget
/// - No existe lógica de negocio aquí
class CustomSearchAnchor extends ConsumerStatefulWidget {
  /// Slug de la edición actual.
  /// Se pasa a [filteredCardsProvider] para obtener las cartas
  /// de la edición correcta al mostrar sugerencias.
  final String editionSlug;

  const CustomSearchAnchor(this.editionSlug, {super.key});

  @override
  ConsumerState<CustomSearchAnchor> createState() => _CustomSearchAnchorState();
}

class _CustomSearchAnchorState extends ConsumerState<CustomSearchAnchor> {
  /// Controlador del [SearchAnchor].
  ///
  /// Se declara como `late final` para crear una única instancia
  /// durante todo el ciclo de vida del widget. Si se creara dentro
  /// de [build], se perdería el texto y el foco en cada rebuild.
  late final SearchController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SearchController();
  }

  @override
  void dispose() {
    /// Libera los recursos del controlador para evitar memory leaks
    /// cuando el widget es destruido al salir de la pantalla.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),

      child: SearchAnchor.bar(
        searchController: _controller,

        barHintText: 'Busca una carta...',

        barElevation: const WidgetStatePropertyAll(8),

        barLeading: const Icon(Icons.search, color: Colors.green),

        barPadding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 10),
        ),

        /// Se ejecuta cada vez que el usuario escribe en el buscador.
        ///
        /// Solo comunica el nuevo valor a Riverpod — no filtra ni
        /// transforma datos. El flujo completo es:
        /// usuario escribe →
        /// [searchCardQueryProvider] se actualiza →
        /// [filteredCardsProvider] se recalcula →
        /// [suggestionsBuilder] se reconstruye automáticamente.
        onChanged: (value) {
          ref.read(searchCardQueryProvider.notifier).updateQuery(value);
        },

        /// Construye la lista de sugerencias en respuesta al texto ingresado.
        ///
        /// IMPORTANTE: este callback puede ejecutarse múltiples veces
        /// por frame. Por eso solo se permite leer estado con [ref.watch],
        /// nunca modificarlo con [ref.read] o notifiers — hacerlo causaría
        /// rebuilds infinitos y excepciones en tiempo de ejecución.
        suggestionsBuilder: (context, controller) {
          final cardsAsync = ref.watch(
            filteredCardsProvider(widget.editionSlug),
          );

          return cardsAsync.when(
            /// ESTADO: carga en progreso.
            ///
            /// Muestra 4 ítems skeleton con shimmer que replican
            /// el alto y estructura de [CustomListviewCardFiltered],
            /// evitando saltos de layout cuando llegan los datos.
            loading: () => List.generate(4, (_) => const _SuggestionSkeleton()),

            /// ESTADO: error al cargar las cartas.
            ///
            /// Muestra un mensaje amigable sin exponer el error técnico
            /// al usuario, igual que el manejo de errores en [CardsScreen].
            error:
                (error, _) => [
                  const ListTile(
                    leading: Icon(Icons.cloud_off_outlined, color: Colors.grey),
                    title: Text('No se pudieron cargar las cartas'),
                  ),
                ],

            /// ESTADO: datos recibidos correctamente.
            ///
            /// Si no hay resultados, muestra un empty state.
            /// Si hay resultados, limita las sugerencias a 10 ítems
            /// para no sobrecargar visualmente el panel de búsqueda.
            data: (cards) {
              if (cards.isEmpty) {
                return const [
                  ListTile(
                    leading: Icon(Icons.style_outlined, color: Colors.grey),
                    title: Text('No se encontraron cartas'),
                  ),
                ];
              }

              return cards.take(10).map((card) {
                return CustomListviewCardFiltered(card: card);
              }).toList();
            },
          );
        },
      ),
    );
  }
}

/// Ítem skeleton para el panel de sugerencias del buscador.
///
/// Replica la estructura visual de [CustomListviewCardFiltered]
/// con animación shimmer, evitando saltos de layout al cargar.
class _SuggestionSkeleton extends StatelessWidget {
  const _SuggestionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,

      child: ListTile(
        /// Simula la miniatura de la carta (mismo tamaño que [CustomListviewCardFiltered])
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(width: 40, height: 40, color: Colors.grey),
        ),

        /// Simula el nombre de la carta con un ancho aproximado
        title: Container(
          height: 14,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
