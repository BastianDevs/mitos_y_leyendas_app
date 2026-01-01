import 'package:mitos_y_leyendas_app/domain/entities/card.dart';

abstract class CardRepository {
  Future<List<CardEntity>> getCardsByEdition(String editionSlug);
}
