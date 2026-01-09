import 'package:mitos_y_leyendas_app/domain/entities/edition.dart';
import 'package:mitos_y_leyendas_app/domain/repositories/edition_repository.dart';
import 'package:mitos_y_leyendas_app/infrastructure/datasource/local_editions_datasouce.dart';

/// Implementación concreta del repositorio de ediciones
///
/// - Cumple el contrato definido por `EditionRepository`
/// - Actúa como capa intermedia entre la UI y el datasource
/// - Permite cambiar la fuente de datos sin afectar al resto de la app
class EditionRepositoryImpl implements EditionRepository {
  /// Datasource que provee los datos de ediciones
  ///
  /// - Actualmente es local (mock / hardcodeado)
  /// - Puede reemplazarse por uno remoto en el futuro
  final LocalEditionsDatasource datasource;

  /// Constructor que inyecta el datasource
  ///
  /// - Facilita testing
  /// - Permite inversión de dependencias
  EditionRepositoryImpl(this.datasource);

  /// Retorna la lista de ediciones disponibles
  ///
  /// - Delegado directamente al datasource
  /// - Lógica de negocio mínima en esta implementación
  @override
  List<EditionEntity> getEditions() {
    return datasource.getEditions();
  }
}
