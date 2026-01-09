import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:mitos_y_leyendas_app/domain/repositories/card_repository.dart';
import 'package:mitos_y_leyendas_app/infrastructure/datasource/cards_datasource.dart';
import 'package:mitos_y_leyendas_app/infrastructure/repositories/cards_repository_impl.dart';
import 'package:mitos_y_leyendas_app/infrastructure/services/card_dio_service.dart';

/// Provee la instancia de Dio configurada para las cartas
///
/// - Centraliza la configuración HTTP
/// - Permite cambiar interceptores o baseUrl fácilmente
/// - Facilita testing y mocks
final dioProvider = Provider<Dio>((ref) {
  return CardDioService.create();
});

/// Provee la fuente de datos de las cartas
///
/// - Depende de Dio para realizar llamadas HTTP
/// - Encapsula el acceso a la API
/// - Puede ser reemplazada por otra implementación
final cardsDatasourceProvider = Provider<CardsDatasource>((ref) {
  final dio = ref.read(dioProvider);
  return CardsDatasourceImpl(dio);
});

/// Provee el repositorio de cartas
///
/// - Expone solo la abstracción [CardRepository]
/// - Oculta la implementación concreta
/// - Aplica inversión de dependencias
/// - La UI no conoce la capa de datos
final cardsRepositoryProvider = Provider<CardRepository>((ref) {
  final datasource = ref.read(cardsDatasourceProvider);
  return CardsRepositoryImpl(datasource);
});

/// Obtiene las cartas asociadas a una edición
///
/// - Recibe el slug de la edición
/// - Ejecuta una operación asíncrona
/// - Maneja estados loading / error / data
/// - Se recalcula automáticamente al cambiar la edición
final cardsByEditionProvider = FutureProvider.family<List<CardEntity>, String>((
  ref,
  editionSlug,
) {
  final repository = ref.read(cardsRepositoryProvider);
  return repository.getCardsByEdition(editionSlug);
});
