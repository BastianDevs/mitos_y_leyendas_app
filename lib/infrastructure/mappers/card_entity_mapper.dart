import 'package:mitos_y_leyendas_app/domain/entities/card.dart';

class CardEntityMapper {
  static CardEntity fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> rootData,
  ) {
    return CardEntity(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,

      cost: int.tryParse(json['cost']?.toString() ?? '') ?? 0,

      slug: json['slug']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Sin nombre',

      damage:
          json['damage'] != null ? int.parse(json['damage'].toString()) : null,

      ability: json['ability']?.toString(),

      rarity: _mapRarity(json['rarity']?.toString() ?? '', rootData),
      race: _mapRace(json['race']?.toString() ?? '', rootData),
      type: _mapType(json['type']?.toString() ?? '', rootData),

      keywords: _mapKeywords(json['keywords'], rootData),

      editionSlug: json['ed_slug']?.toString() ?? '',
    );
  }

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
      if ((keywordFlags & flag) != 0) {
        result.add(keyword['title'].toString());
      }
    }

    return result;
  }
}
