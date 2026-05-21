import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

/// Ítem de sugerencia del buscador que muestra una carta filtrada.
///
/// Se usa dentro del [CustomSearchAnchor] para renderizar cada resultado
/// de búsqueda con una miniatura de la carta y su nombre.
/// Al tocarla abre el dialog de detalle con animación Hero.
class CustomListviewCardFiltered extends StatelessWidget {
  /// Carta a mostrar en la sugerencia.
  ///
  /// Se recibe completa para:
  /// - Evitar duplicar o transformar datos en este widget
  /// - Tener todo lo necesario para mostrar imagen, nombre y abrir el dialog
  /// - Mantener el widget simple y sin lógica propia
  final CardEntity card;

  const CustomListviewCardFiltered({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      /// Miniatura de la carta con caché, shimmer de carga y fallback de error.
      /// Usa la misma URL que [CardImage] para aprovechar el caché existente:
      /// si la imagen ya fue descargada en el grid, aparece instantáneamente.
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: CachedNetworkImage(
          imageUrl:
              'https://api.myl.cl/static/cards/${card.edEdid}/${card.edid}.png',
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          placeholder:
              (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(width: 40, height: 40, color: Colors.grey),
              ),
          errorWidget:
              (context, url, error) => const Icon(Icons.broken_image, size: 40),
        ),
      ),

      /// Nombre de la carta en mayúsculas para consistencia visual
      /// con el resto de la app ([CardNameOverlay], [_CardContainer])
      title: Text(card.name.toUpperCase()),

      /// Abre el dialog de detalle de la carta seleccionada.
      /// El tag Hero de [CustomShowCardDialog] conecta con el
      /// [CustomGridview] si la carta también está visible en el grid,
      /// produciendo la animación de vuelo entre ambas vistas.
      onTap: () => CustomShowCardDialog.show(context, card),
    );
  }
}
