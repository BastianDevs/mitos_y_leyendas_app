import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/card/searchcard_provider.dart';

class CustomSearchAnchor extends ConsumerWidget {
  const CustomSearchAnchor({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controler = SearchController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SearchAnchor.bar(
        searchController: controler,
        barHintText: 'Busca una carta...',
        barElevation: WidgetStatePropertyAll(8),
        barLeading: Icon(Icons.search, color: Colors.green),
        barPadding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        ),

        /// Cada vez que el texto cambia, se guarda en el provider
        onChanged: (value) {
          ref.read(searchCardQueryProvider.notifier).updateQuery(value);
        },

        suggestionsBuilder: (
          BuildContext context,
          SearchController controller,
        ) {
          /// Cada vez que el texto cambia, se guarda en el provider
          return [];
        },
      ),
    );
  }
}
