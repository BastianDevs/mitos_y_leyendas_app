import 'package:mitos_y_leyendas_app/domain/entities/card.dart';

/// Mapper encargado de transformar la respuesta cruda de la API
/// en una entidad de dominio `CardEntity`
///
/// - Centraliza la lógica de parseo
/// - Aísla a la app de cambios en la API
/// - Convierte IDs y flags en valores legibles
class CardEntityMapper {
  /// Convierte un JSON de carta en un `CardEntity`
  ///
  /// [json] contiene los datos propios de la carta
  /// [rootData] contiene catálogos compartidos (rarities, races, types, keywords)
  static CardEntity fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> rootData,
  ) {
    return CardEntity(
      /// ID único de la carta
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,

      /// ID interno de edición
      edid: json['edid'],

      /// Costo de la carta
      cost: int.tryParse(json['cost']?.toString() ?? '') ?? 0,

      /// Slug único de la carta
      slug: json['slug']?.toString() ?? '',

      /// Nombre visible de la carta
      name: json['name']?.toString() ?? 'Sin nombre',

      /// Daño (puede ser null dependiendo del tipo de carta)
      damage:
          json['damage'] != null ? int.parse(json['damage'].toString()) : null,

      /// Texto de habilidad
      ability: json['ability']?.toString(),

      /// Rareza convertida desde ID a nombre
      rarity: _mapRarity(json['rarity']?.toString() ?? '', rootData),

      /// Raza convertida desde ID a nombre
      race: _mapRace(json['race']?.toString() ?? '', rootData),

      /// Tipo convertido desde ID a nombre
      type: _mapType(json['type']?.toString() ?? '', rootData),

      /// Lista de palabras clave activas según flags
      keywords: _mapKeywords(json['keywords'], rootData),

      /// ID de edición necesario para construir URLs de imagen
      edEdid: json['ed_edid'],

      /// Slug de la edición
      editionSlug: json['ed_slug']?.toString() ?? '',
    );
  }

  /// Convierte el ID de rareza en su nombre legible
  ///
  /// - Busca en el catálogo `rarities`
  /// - Soporta estructura List o Map
  /// - Retorna "Desconocida" si no encuentra coincidencia
  static String _mapRarity(String id, Map<String, dynamic> root) {
    final raw = root['rarities'];

    Iterable values;

    if (raw is List) {
      values = raw;
    } else if (raw is Map) {
      values = raw.values;
    } else {
      return 'Desconocida';
    }

    for (final rarity in values) {
      if (rarity is Map && rarity['id'].toString() == id) {
        return rarity['name'].toString();
      }
    }

    return 'Desconocida';
  }

  /// Convierte el ID de raza en su nombre legible
  ///
  /// - Busca en el catálogo `races`
  /// - Retorna "Sin raza" si no existe
  static String _mapRace(String id, Map<String, dynamic> root) {
    final raw = root['races'];

    Iterable values;

    if (raw is List) {
      values = raw;
    } else if (raw is Map) {
      values = raw.values;
    } else {
      return 'Sin raza';
    }

    for (final race in values) {
      if (race is Map && race['id'].toString() == id) {
        return race['name'].toString();
      }
    }

    return 'Sin raza';
  }

  /// Convierte el ID de tipo en su nombre legible
  ///
  /// - Usa el catálogo `types`
  /// - Maneja estructuras variables (List / Map)
  static String _mapType(String id, Map<String, dynamic> root) {
    final raw = root['types'];

    Iterable values;

    if (raw is List) {
      values = raw;
    } else if (raw is Map) {
      values = raw.values;
    } else {
      return 'Desconocido';
    }

    for (final type in values) {
      if (type is Map && type['id'].toString() == id) {
        return type['name'].toString();
      }
    }

    return 'Desconocido';
  }

  /// Convierte el campo de keywords basado en flags binarios
  ///
  /// - [flags] es un entero que representa bits activos
  /// - Cada keyword tiene un `flag`
  /// - Se usa operación AND (&) para detectar coincidencias
  static List<String> _mapKeywords(dynamic flags, Map<String, dynamic> root) {
    if (flags == null) return [];

    final raw = root['keywords'];
    final int keywordFlags = int.tryParse(flags.toString()) ?? 0;

    final List<String> result = [];

    Iterable values;

    if (raw is List) {
      values = raw;
    } else if (raw is Map<String, dynamic>) {
      values = raw.values;
    } else {
      return [];
    }

    for (final keyword in values) {
      if (keyword is! Map) continue;

      final int flag = int.tryParse(keyword['flag'].toString()) ?? 0;

      // Verifica si el bit está activo en los flags de la carta
      if ((keywordFlags & flag) != 0) {
        result.add(keyword['title'].toString());
      }
    }

    return result;
  }
}
