import 'package:dio/dio.dart';
import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:mitos_y_leyendas_app/infrastructure/mappers/card_entity_mapper.dart';

abstract class CardsDatasource {
  Future<List<CardEntity>> getCardsByEdition(String editionSlug);
}

class CardsDatasourceImpl implements CardsDatasource {
  final Dio dio;

  CardsDatasourceImpl(this.dio);

  @override
  Future<List<CardEntity>> getCardsByEdition(String editionSlug) async {
    final response = await dio.get('/cards/edition/${editionSlug}');
    final data = response.data;

    final List cardsJson = data['cards'];

    return cardsJson
        .map((json) => CardEntityMapper.fromJson(json, data))
        .toList();
  }
}
