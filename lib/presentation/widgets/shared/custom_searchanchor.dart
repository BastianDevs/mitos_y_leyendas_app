import 'package:flutter/material.dart';

class CustomSearchAnchor extends StatelessWidget {
  const CustomSearchAnchor({super.key});
  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: 'Busca una carta...',
      elevation: WidgetStatePropertyAll(8),
      shadowColor: WidgetStatePropertyAll(Colors.green),
      leading: Icon(Icons.search, color: Colors.green),

      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      ),
    );
  }
}
