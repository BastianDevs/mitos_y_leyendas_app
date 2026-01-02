import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:mitos_y_leyendas_app/domain/repositories/card_repository.dart';
import 'package:mitos_y_leyendas_app/infrastructure/datasource/cards_datasource.dart';

class CardsRepositoryImpl implements CardRepository {
  final CardsDatasource datasource;

  CardsRepositoryImpl(this.datasource);

  @override
  Future<List<CardEntity>> getCardsByEdition(String editionSlug) {
    return datasource.getCardsByEdition(editionSlug);
  }
}
