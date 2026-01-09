import 'package:mitos_y_leyendas_app/domain/entities/card.dart';

/// Contrato del dominio para el acceso a cartas.
///
/// Define qué operaciones están disponibles sin exponer
/// cómo ni desde dónde se obtienen los datos (API, cache, mock, etc).
abstract class CardRepository {
  /// Obtiene todas las cartas asociadas a una edición específica.
  ///
  /// [editionSlug] identifica de forma única la edición solicitada.
  /// Retorna una lista de [CardEntity] listas para ser usadas por la UI.
  Future<List<CardEntity>> getCardsByEdition(String editionSlug);
}
