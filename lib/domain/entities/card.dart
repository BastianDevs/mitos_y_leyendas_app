/// Entidad de dominio que representa una carta del juego.
///
/// Contiene tanto datos directos del backend como valores ya
/// interpretados y listos para ser usados por la UI.
class CardEntity {
  /// Identificador único de la carta
  final int id;

  /// ID interno de la carta dentro de la edición
  final String edid;

  /// Slug único de la carta
  final String slug;

  /// Nombre visible de la carta
  final String name;

  /// Rareza de la carta (ya mapeada desde el backend)
  final String rarity;

  /// Raza de la carta (ya interpretada)
  final String race;

  /// Tipo de carta (ej: Aliado, Tótem, Oro, etc.)
  final String type;

  /// Lista de palabras clave obtenidas desde flags binarios
  final List<String> keywords;

  /// Costo de la carta
  final int cost;

  /// Daño de la carta (puede ser null si no aplica)
  final int? damage;

  /// Habilidad o texto de efecto de la carta
  /// Puede ser null si la carta no posee habilidad
  final String? ability;

  /// Identificador interno de la edición
  /// Usado para construir la URL de la imagen
  final String edEdid;

  /// Slug de la edición a la que pertenece la carta
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
