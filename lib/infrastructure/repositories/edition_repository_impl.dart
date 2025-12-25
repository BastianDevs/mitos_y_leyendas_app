import 'package:mitos_y_leyendas_app/domain/entities/edition.dart';
import 'package:mitos_y_leyendas_app/domain/repositories/edition_repository.dart';
import 'package:mitos_y_leyendas_app/infrastructure/datasource/local_editions_datasouce.dart';

class EditionRepositoryImpl implements EditionRepository {
  final LocalEditionsDatasouce datasouce;

  EditionRepositoryImpl(this.datasouce);

  @override
  List<EditionEntity> getEditions() {
    return datasouce.getEditions();
  }
}
