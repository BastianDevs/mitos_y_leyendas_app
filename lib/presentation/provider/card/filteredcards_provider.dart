import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/card/card_provider.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/card/searchcard_provider.dart';

/// Provider que devuelve la lista de cartas filtradas
/// según el texto ingresado por el usuario.
///
/// - Escucha las cartas de la edición actual
/// - Escucha el texto del buscador
/// - Filtra por nombre (case-insensitive)
/// - No mantiene estado propio
final filteredCardsProvider =
    Provider.family<AsyncValue<List<CardEntity>>, String>((ref, editionSlug) {
      /// Obtiene el estado asíncrono de las cartas desde la API
      final cardsAsync = ref.watch(cardsByEditionProvider(editionSlug));

      /// Obtiene el texto actual del buscador
      final query = ref.watch(searchCardQueryProvider).trim().toLowerCase();

      return cardsAsync.when(
        /// Cuando los datos están disponibles
        data: (cards) {
          /// Si el buscador está vacío, retorna todas las cartas
          if (query.isEmpty) {
            return AsyncValue.data(cards);
          }

          /// Filtra las cartas por nombre
          final filteredCards =
              cards.where((card) {
                return card.name.toLowerCase().contains(query);
              }).toList();

          return AsyncValue.data(filteredCards);
        },

        /// Propaga el estado de carga
        loading: () => const AsyncValue.loading(),

        /// Propaga el error
        error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
      );
    });
