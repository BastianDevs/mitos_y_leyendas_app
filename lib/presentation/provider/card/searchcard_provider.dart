import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider público que expone el estado del buscador de cartas.
///
/// - Tipo de estado: String (texto ingresado por el usuario)
/// - Es reactivo y se actualiza en tiempo real
/// - No contiene lógica de filtrado, solo el query
final searchCardQueryProvider =
    NotifierProvider<SearchCardQueryNotifier, String>(
      SearchCardQueryNotifier.new,
    );

/// Notifier que mantiene el texto ingresado en el buscador.
///
/// Responsabilidades:
/// - Mantener el estado del texto actual
/// - Exponer métodos para actualizar y limpiar el query
class SearchCardQueryNotifier extends Notifier<String> {
  @override
  String build() {
    /// Estado inicial del buscador (sin texto)
    return '';
  }

  /// Actualiza el texto de búsqueda
  /// Se llama en cada cambio del SearchBar
  void updateQuery(String value) {
    state = value;
  }

  /// Limpia completamente el texto del buscador
  void clear() {
    state = '';
  }
}
