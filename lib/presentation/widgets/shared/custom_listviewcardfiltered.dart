import 'package:flutter/material.dart';

class CustomListviewCardFiltered extends StatelessWidget {
  /// Nombre de la carta
  final String name;

  /// URL de la imagen de la carta
  final String imageUrl;

  const CustomListviewCardFiltered({
    super.key,
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          imageUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(name.toUpperCase()),
      onTap: () {
        /// Aquí luego puedes:
        /// - cerrar el search
        /// - navegar al detalle
      },
    );
  }
}
