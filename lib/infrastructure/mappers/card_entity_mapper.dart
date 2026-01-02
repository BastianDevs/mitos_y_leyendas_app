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
    final list = root['rarities'] as List;

    for (final rarity in list) {
      if (rarity['id'] == id) {
        return rarity['name'];
      }
    }

    return 'Desconocida';
  }

  static String _mapRace(String id, Map<String, dynamic> root) {
    final list = root['races'] as List;

    for (final race in list) {
      if (race['id'] == id) {
        return race['name'];
      }
    }

    return 'Sin raza';
  }

  static String _mapType(String id, Map<String, dynamic> root) {
    final list = root['types'] as List;

    for (final type in list) {
      if (type['id'] == id) {
        return type['name'];
      }
    }

    return 'Desconocido';
  }

  static List<String> _mapKeywords(dynamic flags, Map<String, dynamic> root) {
    if (flags == null) return [];

    final int keywordFlags = int.parse(flags.toString());
    final List keywords = root['keywords'];

    final List<String> result = [];

    for (final keyword in keywords) {
      final int flag = int.parse(keyword['flag']);
      if ((keywordFlags & flag) != 0) {
        result.add(keyword['title']);
      }
    }

    return result;
  }
}
