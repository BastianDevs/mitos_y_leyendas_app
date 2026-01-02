import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:mitos_y_leyendas_app/domain/repositories/card_repository.dart';
import 'package:mitos_y_leyendas_app/infrastructure/datasource/cards_datasource.dart';
import 'package:mitos_y_leyendas_app/infrastructure/repositories/cards_repository_impl.dart';
import 'package:mitos_y_leyendas_app/infrastructure/services/card_dio_service.dart';

final dioProvider = Provider<Dio>((ref) {
  return CardDioService.create();
});

final cardsDatasourceProvider = Provider<CardsDatasource>((ref) {
  final dio = ref.read(dioProvider);
  return CardsDatasourceImpl(dio);
});

final cardsRepositoryProvider = Provider<CardRepository>((ref) {
  final datasource = ref.read(cardsDatasourceProvider);
  return CardsRepositoryImpl(datasource);
});

final cardsByEditionProvider = FutureProvider.family<List<CardEntity>, String>((
  ref,
  editionSlug,
) {
  final repository = ref.read(cardsRepositoryProvider);
  return repository.getCardsByEdition(editionSlug);
});
