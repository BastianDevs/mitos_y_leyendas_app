import 'package:flutter/material.dart';
import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';

/// Grid personalizado que muestra una colección de cartas.
/// Cada ítem es interactivo y abre el detalle en un dialog.
class CustomGridview extends StatelessWidget {
  /// Lista de cartas a renderizar en el grid
  final List<CardEntity> cards;

  const CustomGridview({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      /// Espaciado externo del grid
      padding: const EdgeInsets.all(8),

      /// Configuración del layout del grid
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        // Número de columnas
        crossAxisCount: 2,

        // Relación ancho / alto de cada item
        childAspectRatio: 0.7,

        // Espaciado horizontal entre items
        crossAxisSpacing: 8,

        // Espaciado vertical entre items
        mainAxisSpacing: 8,
      ),

      /// Cantidad total de items
      itemCount: cards.length,

      /// Builder de cada item del grid
      itemBuilder: (context, index) {
        // Carta actual
        final card = cards[index];

        return InkWell(
          /// Acción al tocar una carta
          onTap: () => CustomShowCardDialog.show(context, card),

          child: ClipRRect(
            /// Bordes redondeados de la carta
            borderRadius: BorderRadius.circular(12),

            child: Stack(
              // Ocupa todo el espacio disponible del grid cell
              fit: StackFit.expand,
              children: [
                /// IMAGEN DE LA CARTA
                /// Incluye fade-in y placeholder interno
                CardImage(card: card),

                /// OVERLAY CON GRADIENTE Y NOMBRE
                /// Mejora la legibilidad del texto sobre la imagen
                CardNameOverlay(name: card.name),
              ],
            ),
          ),
        );
      },
    );
  }
}
