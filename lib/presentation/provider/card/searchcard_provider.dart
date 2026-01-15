import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier que mantiene el texto ingresado en el buscador.
///
/// - Estado: String (query actual)
/// - Se actualiza en tiempo real mientras el usuario escribe
/// - No contiene lógica de filtrado
class SearchCardQueryNotifier extends Notifier<String> {
  @override
  String build() {
    // Estado inicial del buscador
    return '';
  }

  /// Actualiza el texto de búsqueda
  void updateQuery(String value) {
    state = value;
  }

  /// Limpia el texto del buscador
  void clear() {
    state = '';
  }
}

/// Provider público que expone el estado del buscador
final searchCardQueryProvider =
    NotifierProvider<SearchCardQueryNotifier, String>(
      SearchCardQueryNotifier.new,
    );
