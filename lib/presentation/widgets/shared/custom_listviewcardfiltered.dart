import 'package:flutter/material.dart';
import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';

class CustomListviewCardFiltered extends StatelessWidget {
  /// Carta que se mostrará en la sugerencia
  ///
  /// Se pasa completa para:
  /// - Evitar duplicar datos
  /// - Facilitar navegación y dialogs
  /// - Mantener el widget simple
  final CardEntity card;

  const CustomListviewCardFiltered({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          'https://api.myl.cl/static/cards/${card.edEdid}/${card.edid}.png',
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),

      /// Nombre de la carta
      title: Text(card.name.toUpperCase()),

      onTap: () {
        /// Muestra el dialog con el detalle de la carta
        ///
        /// Flujo:
        /// Tap →
        /// Dialog overlay →
        /// Hero animation →
        /// Detalle completo
        CustomShowCardDialog.show(context, card);
      },
    );
  }
}
