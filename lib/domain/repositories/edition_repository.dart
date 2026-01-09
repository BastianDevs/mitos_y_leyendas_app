import 'package:mitos_y_leyendas_app/domain/entities/edition.dart';

/// Contrato del dominio para el acceso a ediciones.
///
/// Define las operaciones disponibles para obtener ediciones,
/// sin exponer la fuente de datos ni su implementación concreta
/// (local, remota, mock, etc).
abstract class EditionRepository {
  /// Obtiene la lista completa de ediciones disponibles.
  ///
  /// Retorna una lista de [EditionEntity] listas para ser
  /// consumidas por la capa de presentación.
  List<EditionEntity> getEditions();
}
