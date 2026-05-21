import 'package:flutter/material.dart';
import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

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

/// Grid de esqueletos animados que simula el layout real de cartas.
///
/// Se muestra mientras las cartas se están cargando desde la API.
/// Replica exactamente la estructura visual de [CustomGridview]
/// para evitar saltos de layout cuando llegan los datos reales.
class CustomGridviewSkeleton extends StatelessWidget {
  /// Número de tarjetas skeleton a mostrar.
  /// 10 es suficiente para llenar la pantalla en cualquier dispositivo.
  final int itemCount;

  const CustomGridviewSkeleton({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      /// Mismo padding que [CustomGridview]
      padding: const EdgeInsets.all(8),

      /// Misma configuración de layout que [CustomGridview]
      /// para que el skeleton sea visualmente idéntico al grid real
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),

      itemCount: itemCount,

      itemBuilder: (context, index) => const _CardSkeleton(),
    );
  }
}

/// Tarjeta skeleton individual con animación shimmer.
///
/// Replica la forma y proporciones de una carta real,
/// incluyendo los bordes redondeados del [CustomGridview].
class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      /// Mismo borderRadius que las cartas reales
      borderRadius: BorderRadius.circular(12),

      child: Shimmer.fromColors(
        /// Color base del efecto shimmer (zona más oscura)
        baseColor: Colors.grey.shade300,

        /// Color del brillo animado (zona más clara)
        highlightColor: Colors.grey.shade100,

        /// Contenedor que simula el área completa de la carta
        child: Container(color: Colors.grey),
      ),
    );
  }
}
