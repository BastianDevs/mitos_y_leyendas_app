class CardEntity {
  final int id;
  final String edid;
  final String slug;
  final String name;

  final String rarity;
  final String race;
  final String type;
  final List<String> keywords;

  final int cost;
  final int? damage;
  final String? ability;

  final String edEdid;
  final String editionSlug;

  CardEntity({
    required this.id,
    required this.edid,
    required this.slug,
    required this.name,
    required this.rarity,
    required this.race,
    required this.type,
    required this.keywords,
    required this.cost,
    required this.damage,
    required this.ability,
    required this.edEdid,
    required this.editionSlug,
  });
}
