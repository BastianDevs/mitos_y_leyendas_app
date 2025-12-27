import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitos_y_leyendas_app/domain/entities/edition.dart';
import 'package:mitos_y_leyendas_app/domain/repositories/edition_repository.dart';
import 'package:mitos_y_leyendas_app/infrastructure/datasource/local_editions_datasouce.dart';
import 'package:mitos_y_leyendas_app/infrastructure/repositories/edition_repository_impl.dart';

/*
Qué hace:

Crea una única instancia

Permite cambiar la fuente luego

Facilita testing
*/

final localEditionsDatasourceProvider = Provider<LocalEditionsDatasource>((
  ref,
) {
  return LocalEditionsDatasource();
});

/*
Qué hace:

Expone solo la abstracción (EditionRepository)

Oculta la implementación real

UI nunca conoce infrastructure
*/

final editionRepositoryProvider = Provider<EditionRepository>((ref) {
  final datasource = ref.read(localEditionsDatasourceProvider);
  return EditionRepositoryImpl(datasource);
});

/*
Qué hace:

Obtiene la lista

Es síncrono

Reactivo
*/

final editionProvider = Provider<List<EditionEntity>>((ref) {
  return ref.read(editionRepositoryProvider).getEditions();
});

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
