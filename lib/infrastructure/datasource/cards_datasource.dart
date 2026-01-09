import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:mitos_y_leyendas_app/infrastructure/mappers/card_entity_mapper.dart';

/// Contrato que define las operaciones de acceso a datos de cartas
///
/// - Define qué datos se pueden obtener
/// - No conoce implementaciones concretas
/// - Permite desacoplar dominio e infraestructura
abstract class CardsDatasource {
  /// Obtiene las cartas asociadas a una edición específica
  ///
  /// - Recibe el slug de la edición
  /// - Retorna una lista de entidades de dominio
  /// - Puede lanzar excepciones ante errores de datos o red
  Future<List<CardEntity>> getCardsByEdition(String editionSlug);
}

/// Implementación concreta del datasource de cartas
///
/// - Consume una API REST mediante Dio
/// - Maneja distintos formatos de respuesta (String o JSON)
/// - Convierte datos crudos en entidades de dominio
class CardsDatasourceImpl implements CardsDatasource {
  /// Cliente HTTP inyectado
  ///
  /// - Permite reutilización
  /// - Facilita testing y mocks
  final Dio dio;

  /// Constructor con inyección de dependencias
  CardsDatasourceImpl(this.dio);

  @override
  Future<List<CardEntity>> getCardsByEdition(String editionSlug) async {
    /// Realiza la petición a la API para obtener las cartas de una edición
    final response = await dio.get('/cards/edition/$editionSlug');

    /// Datos crudos retornados por la API
    final raw = response.data;

    /// Mapa final que contendrá el JSON parseado
    Map<String, dynamic> data;

    /// Caso 1: la API retorna un String con JSON embebido
    ///
    /// - Se extrae manualmente el objeto JSON válido
    /// - Se decodifica a Map<String, dynamic>
    if (raw is String) {
      final firstBrace = raw.indexOf('{');
      final lastBrace = raw.lastIndexOf('}');

      if (firstBrace == -1 || lastBrace == -1) {
        throw Exception('No se encontró JSON válido en la respuesta');
      }

      final jsonString = raw.substring(firstBrace, lastBrace + 1);
      data = jsonDecode(jsonString) as Map<String, dynamic>;

      /// Caso 2: la API retorna directamente un JSON válido
    } else if (raw is Map<String, dynamic>) {
      data = raw;

      /// Caso 3: formato inesperado
    } else {
      throw Exception('Formato de respuesta desconocido');
    }

    /// Obtiene la lista de cartas desde el JSON
    final cardsRaw = data['cards'];

    /// Validación básica del formato esperado
    if (cardsRaw is! List) {
      throw Exception('cards no es una lista');
    }

    /// Mapea cada elemento JSON a una entidad de dominio
    ///
    /// - Usa un mapper para aislar la lógica de transformación
    /// - Mantiene el dominio libre de dependencias externas
    return cardsRaw
        .map<CardEntity>((json) => CardEntityMapper.fromJson(json, data))
        .toList();
  }
}
