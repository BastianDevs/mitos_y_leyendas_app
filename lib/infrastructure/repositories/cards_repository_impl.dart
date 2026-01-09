import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:mitos_y_leyendas_app/domain/repositories/card_repository.dart';
import 'package:mitos_y_leyendas_app/infrastructure/datasource/cards_datasource.dart';

/// Implementación concreta del repositorio de cartas
///
/// - Cumple el contrato definido por `CardRepository`
/// - Encapsula el acceso a los datos de cartas
/// - Aísla la capa de presentación de la infraestructura
class CardsRepositoryImpl implements CardRepository {
  /// Datasource encargado de obtener las cartas
  ///
  /// - Actualmente obtiene datos desde una API remota
  /// - Puede reemplazarse por un datasource local o mock
  final CardsDatasource datasource;

  /// Constructor con inyección del datasource
  ///
  /// - Facilita testing unitario
  /// - Permite cambiar la fuente de datos sin modificar la UI
  CardsRepositoryImpl(this.datasource);

  /// Obtiene la lista de cartas asociadas a una edición
  ///
  /// - Recibe el `slug` de la edición
  /// - Devuelve una lista de `CardEntity`
  /// - Método asíncrono porque depende de una llamada remota
  @override
  Future<List<CardEntity>> getCardsByEdition(String editionSlug) {
    return datasource.getCardsByEdition(editionSlug);
  }
}
