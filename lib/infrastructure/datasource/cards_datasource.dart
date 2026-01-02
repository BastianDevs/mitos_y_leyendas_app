import 'dart:convert';

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
    final response = await dio.get('/cards/edition/$editionSlug');
    final raw = response.data;

    Map<String, dynamic> data;

    if (raw is String) {
      final firstBrace = raw.indexOf('{');
      final lastBrace = raw.lastIndexOf('}');

      if (firstBrace == -1 || lastBrace == -1) {
        throw Exception('No se encontró JSON válido en la respuesta');
      }

      final jsonString = raw.substring(firstBrace, lastBrace + 1);

      data = jsonDecode(jsonString) as Map<String, dynamic>;
    } else if (raw is Map<String, dynamic>) {
      data = raw;
    } else {
      throw Exception('Formato de respuesta desconocido');
    }

    final cardsRaw = data['cards'];

    if (cardsRaw is! List) {
      throw Exception('cards no es una lista');
    }

    return cardsRaw
        .map<CardEntity>((json) => CardEntityMapper.fromJson(json, data))
        .toList();
  }
}
