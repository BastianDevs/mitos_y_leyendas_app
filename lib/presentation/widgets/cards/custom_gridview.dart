import 'package:flutter/material.dart';
import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

/// Grid personalizado que muestra una colección de cartas.
///
/// Cada carta es interactiva y al tocarla abre [CustomShowCardDialog]
/// con una animación Hero que conecta visualmente la carta del grid
/// con su versión ampliada en el dialog.
class CustomGridview extends StatelessWidget {
  /// Lista de cartas a renderizar en el grid.
  /// Si está vacía, el widget padre debe manejar el empty state.
  final List<CardEntity> cards;

  const CustomGridview({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        /// Número de columnas del grid
        crossAxisCount: 2,

        /// Relación ancho/alto de cada celda.
        /// El valor 0.7 replica las proporciones reales de una carta de MyL.
        /// Debe coincidir con el [AspectRatio] usado en [_CardContainer]
        /// para que la animación Hero no deforme la imagen durante el vuelo.
        childAspectRatio: 0.7,

        /// Espaciado horizontal entre celdas
        crossAxisSpacing: 8,

        /// Espaciado vertical entre celdas
        mainAxisSpacing: 8,
      ),

      itemCount: cards.length,

      itemBuilder: (context, index) {
        final card = cards[index];

        /// [Hero] marca esta carta como el origen de la animación.
        /// Flutter busca un [Hero] con el mismo [tag] en la pantalla
        /// destino ([CustomShowCardDialog]) y anima la transición entre ambos.
        /// [card.slug] garantiza unicidad entre todas las cartas del grid.
        return Hero(
          tag: card.slug,

          /// [InkWell] dentro de [Hero] requiere un [Material] ancestro
          /// para renderizar el efecto ripple correctamente durante
          /// la animación. El [Material] transparente está en [_CardDetailDialog].
          child: InkWell(
            onTap: () => CustomShowCardDialog.show(context, card),

            child: ClipRRect(
              /// Bordes redondeados de la carta.
              /// Se usa 12 en el grid y 20 en el dialog intencionalmente:
              /// el dialog es más grande y visualmente necesita un radio mayor.
              borderRadius: BorderRadius.circular(12),

              child: Stack(
                /// Expande imagen y overlay para ocupar toda la celda del grid
                fit: StackFit.expand,
                children: [
                  /// Imagen de la carta con caché, fade-in y shimmer interno
                  CardImage(card: card),

                  /// Gradiente con el nombre de la carta superpuesto
                  CardNameOverlay(name: card.name),
                ],
              ),
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
/// incluyendo los bordes redondeados de [CustomGridview].
class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      /// Mismo borderRadius que las cartas reales en el grid
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
