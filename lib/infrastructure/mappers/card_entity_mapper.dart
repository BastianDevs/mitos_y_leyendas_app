import 'package:mitos_y_leyendas_app/domain/entities/card.dart';

class CardEntityMapper {
  static CardEntity fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> rootData,
  ) {
    return CardEntity(
      id: json['id'],
      slug: json['slug'] as String,
      name: json['name'] as String,

      cost: int.parse(json['cost']),
      damage: json['damage'] != null ? int.parse(json['damage']) : null,
      ability: json['ability'] as String?,

      rarity: _mapRarity(json['rarity'], rootData),
      race: _mapRace(json['race'], rootData),
      type: _mapType(json['type'], rootData),
      keywords: _mapKeywords(json['keywords'], rootData),
      editionSlug: json['ed_slug'],
    );
  }

  static String _mapRarity(String id, Map<String, dynamic> root) {
    final raw = root['rarities'];

    if (raw is! List) return 'Desconocida';

    for (final rarity in raw) {
      if (rarity is Map<String, dynamic> && rarity['id'] == id) {
        return rarity['name'];
      }
    }

    return 'Desconocida';
  }

  static String _mapRace(String id, Map<String, dynamic> root) {
    final raw = root['races'];

    if (raw is! List) return 'Sin raza';

    for (final race in raw) {
      if (race is Map<String, dynamic> && race['id'] == id) {
        return race['name'];
      }
    }

    return 'Sin raza';
  }

  static String _mapType(String id, Map<String, dynamic> root) {
    final raw = root['types'];

    if (raw is! List) return 'Desconocido';

    for (final type in raw) {
      if (type is Map<String, dynamic> && type['id'] == id) {
        return type['name'];
      }
    }

    return 'Desconocido';
  }

  static List<String> _mapKeywords(dynamic flags, Map<String, dynamic> root) {
    if (flags == null) return [];

    final raw = root['keywords'];
    if (raw is! List) return [];

    final int keywordFlags = int.tryParse(flags.toString()) ?? 0;

    final List<String> result = [];

    for (final keyword in raw) {
      if (keyword is! Map<String, dynamic>) continue;

      final int flag = int.tryParse(keyword['flag'].toString()) ?? 0;
      if ((keywordFlags & flag) != 0) {
        result.add(keyword['title']);
      }
    }

    return result;
  }
}
