import 'package:mitos_y_leyendas_app/domain/entities/edition.dart';
import 'package:mitos_y_leyendas_app/domain/repositories/edition_repository.dart';
import 'package:mitos_y_leyendas_app/infrastructure/datasource/local_editions_datasouce.dart';

class EditionRepositoryImpl implements EditionRepository {
  final LocalEditionsDatasource datasource;

  EditionRepositoryImpl(this.datasource);

  @override
  List<EditionEntity> getEditions() {
    return datasource.getEditions();
  }
}
