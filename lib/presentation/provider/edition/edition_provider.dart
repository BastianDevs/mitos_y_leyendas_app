import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitos_y_leyendas_app/domain/entities/edition.dart';
import 'package:mitos_y_leyendas_app/domain/repositories/edition_repository.dart';
import 'package:mitos_y_leyendas_app/infrastructure/datasource/local_editions_datasouce.dart';
import 'package:mitos_y_leyendas_app/infrastructure/repositories/edition_repository_impl.dart';

/// Provee la fuente de datos local de ediciones
///
/// - Crea una única instancia
/// - Centraliza el acceso a los datos
/// - Permite cambiar la fuente en el futuro
/// - Facilita testing y mocks
final localEditionsDatasourceProvider = Provider<LocalEditionsDatasource>((
  ref,
) {
  return LocalEditionsDatasource();
});

/// Provee el repositorio de ediciones
///
/// - Expone solo la abstracción [EditionRepository]
/// - Oculta la implementación concreta
/// - Aplica inversión de dependencias
/// - La UI no conoce la capa infrastructure
final editionRepositoryProvider = Provider<EditionRepository>((ref) {
  final datasource = ref.read(localEditionsDatasourceProvider);
  return EditionRepositoryImpl(datasource);
});

/// Provee la lista de ediciones disponibles
///
/// - Obtiene los datos desde el repositorio
/// - Es síncrono
/// - Es reactivo
/// - Fuente única de verdad para las ediciones
final editionProvider = Provider<List<EditionEntity>>((ref) {
  return ref.read(editionRepositoryProvider).getEditions();
});

/// Obtiene una edición específica según su slug
///
/// - Evita lógica de búsqueda en la UI
/// - Depende del provider principal de ediciones
/// - Se recalcula automáticamente si la lista cambia
/// - Retorna null si no existe
final editionBySlugProvider = Provider.family<EditionEntity?, String>((
  ref,
  slug,
) {
  final editions = ref.watch(editionProvider);

  for (final edition in editions) {
    if (edition.slug == slug) {
      return edition;
    }
  }

  return null;
});
