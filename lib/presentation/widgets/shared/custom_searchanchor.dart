import 'package:flutter/material.dart';

class CustomSearchAnchor extends StatelessWidget {
  const CustomSearchAnchor({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SearchAnchor.bar(
        barHintText: 'Busca una carta...',
        barElevation: WidgetStatePropertyAll(8),
        barLeading: Icon(Icons.search, color: Colors.green),
        barPadding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        ),
        suggestionsBuilder: (
          BuildContext context,
          SearchController controller,
        ) {
          return [];
        },
      ),
    );
  }
}
