import 'package:mitos_y_leyendas_app/domain/entities/edition.dart';

abstract class EditionRepository {
  List<EditionEntity> getEditions();
}
