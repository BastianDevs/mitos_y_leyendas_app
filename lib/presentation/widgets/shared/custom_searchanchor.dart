import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/card/filteredcards_provider.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/card/searchcard_provider.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';

/// Widget de búsqueda personalizado basado en [SearchAnchor]
///
/// Responsabilidades:
/// - Gestionar el ciclo de vida del [SearchController]
/// - Capturar el texto ingresado por el usuario
/// - Delegar la lógica de búsqueda a Riverpod (NO filtra aquí)
///
/// Notas de arquitectura:
/// - La UI solo emite eventos
/// - El estado vive en Riverpod
/// - No existe lógica de negocio en el widget
class CustomSearchAnchor extends ConsumerStatefulWidget {
  /// Slug de la edición actual
  ///
  /// Se utiliza para obtener las cartas filtradas
  /// desde los providers correspondientes
  final String editionSlug;

  const CustomSearchAnchor(this.editionSlug, {super.key});

  @override
  ConsumerState<CustomSearchAnchor> createState() => _CustomSearchAnchorState();
}

class _CustomSearchAnchorState extends ConsumerState<CustomSearchAnchor> {
  /// Controlador del SearchAnchor
  ///
  /// Se declara como `late final` para:
  /// - Crear una única instancia
  /// - Evitar recreaciones en cada build
  /// - Mantener el texto y el foco correctamente
  late final SearchController _controller;

  @override
  void initState() {
    super.initState();

    /// Inicialización del controlador
    ///
    /// Debe hacerse en `initState` para que:
    /// - Viva durante todo el ciclo del widget
    /// - No se pierda el texto al hacer rebuild
    _controller = SearchController();
  }

  @override
  void dispose() {
    /// Liberación de recursos
    ///
    /// Importante para evitar memory leaks,
    /// especialmente cuando el widget se destruye
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),

      /// SearchAnchor en modo barra
      ///
      /// Se encarga únicamente de:
      /// - Mostrar el campo de búsqueda
      /// - Capturar interacciones del usuario
      child: SearchAnchor.bar(
        /// Controlador persistente del SearchAnchor
        searchController: _controller,

        /// Texto placeholder del buscador
        barHintText: 'Busca una carta...',

        /// Elevación visual del SearchBar
        barElevation: const WidgetStatePropertyAll(8),

        /// Ícono principal de la barra de búsqueda
        barLeading: const Icon(Icons.search, color: Colors.green),

        /// Padding interno de la barra
        barPadding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 10),
        ),

        /// Callback ejecutado cada vez que el usuario escribe
        ///
        /// Flujo:
        /// Usuario escribe →
        /// searchCardQueryProvider se actualiza →
        /// filteredCardsProvider se recalcula →
        /// UI se reconstruye automáticamente
        ///
        /// Importante:
        /// - El widget NO filtra datos
        /// - Solo comunica eventos a Riverpod
        onChanged: (value) {
          ref.read(searchCardQueryProvider.notifier).updateQuery(value);
        },

        /// Constructor de sugerencias del SearchAnchor
        ///
        /// En este punto:
        /// - Solo se deben leer providers
        /// - NO se debe modificar estado
        ///
        /// Aquí:
        /// - Se muestran sugerencias (nombre + imagen)
        /// - Se maneja loading / error / data
        suggestionsBuilder: (context, controller) {
          final cardsAsync = ref.watch(
            filteredCardsProvider(widget.editionSlug),
          );

          return cardsAsync.when(
            /// Estado de carga
            loading:
                () => const [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],

            /// Estado de error
            error:
                (error, _) => [
                  ListTile(
                    title: Text('Error al cargar cartas'),
                    subtitle: Text(error.toString()),
                  ),
                ],

            /// Estado exitoso
            data: (cards) {
              if (cards.isEmpty) {
                return const [
                  ListTile(title: Text('No se encontraron cartas')),
                ];
              }

              /// Limita la cantidad de sugerencias visibles
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
