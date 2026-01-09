import 'package:flutter/material.dart';
import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:shimmer/shimmer.dart';

/// Widget encargado de mostrar la imagen de una carta.
/// Incluye fade-in, skeleton de carga y manejo de error.
class CardImage extends StatelessWidget {
  /// Entidad que contiene la información de la carta
  final CardEntity card;

  const CardImage({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      /// URL dinámica de la imagen según la edición y el id de la carta
      'https://api.myl.cl/static/cards/${card.edEdid}/${card.edid}.png',

      /// Ajusta la imagen para cubrir completamente el contenedor
      fit: BoxFit.cover,

      /// Se ejecuta cuando el frame de la imagen cambia
      /// Permite animar la aparición cuando la imagen termina de cargar
      frameBuilder: (context, child, frame, _) {
        return AnimatedOpacity(
          /// Si el frame es null, la imagen aún no está cargada
          opacity: frame == null ? 0 : 1,

          /// Duración de la animación de aparición
          duration: const Duration(milliseconds: 400),

          /// Curva suave para el fade-in
          curve: Curves.easeOut,

          /// Imagen renderizada
          child: child,
        );
      },

      /// Se ejecuta mientras la imagen se está descargando
      loadingBuilder: (context, child, loadingProgress) {
        /// Si aún hay progreso de carga, mostramos un shimmer
        if (loadingProgress != null) {
          return const _ImagePlaceholder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          );
        }

        /// Cuando termina de cargar, se muestra la imagen real
        return child;
      },

      /// Se ejecuta si ocurre un error al cargar la imagen
      errorBuilder: (_, __, ___) {
        return const Center(child: Icon(Icons.broken_image, size: 40));
      },
    );
  }
}

/// Widget de placeholder animado para imágenes que aún no han terminado de cargar.
///
/// - Simula visualmente el espacio que ocupará la imagen final
/// - Evita saltos de layout mientras se descarga la imagen
/// - Mejora la percepción de rendimiento usando una animación tipo shimmer
/// - No requiere una imagen real (asset o network)
class _ImagePlaceholder extends StatelessWidget {
  /// Permite aplicar bordes redondeados al placeholder.
  ///
  /// Se usa para que el placeholder respete la misma forma
  /// que tendrá la imagen final (por ejemplo, cards con esquinas redondeadas).
  final BorderRadius borderRadius;

  /// Constructor del placeholder.
  ///
  /// [borderRadius] es requerido;
  /// el widget se renderiza sin bordes redondeados.
  const _ImagePlaceholder({required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      /// Recorta el widget hijo según el [borderRadius] recibido.
      /// Si es null, se usa BorderRadius.zero (sin recorte).
      borderRadius: borderRadius ?? BorderRadius.zero,

      /// Shimmer.fromColors crea una animación de brillo
      /// que se desplaza sobre el widget hijo.
      child: Shimmer.fromColors(
        /// Color base del efecto shimmer (zona más oscura).
        baseColor: Colors.grey.shade300,

        /// Color del brillo animado (zona más clara).
        highlightColor: Colors.grey.shade100,

        /// Contenedor que simula el área de la imagen final.
        /// Su tamaño será definido por el widget padre.
        child: Container(color: Colors.grey),
      ),
    );
  }
}

/// Overlay que muestra el nombre de la carta sobre la imagen.
/// Incluye gradiente para mejorar la legibilidad del texto.
class CardNameOverlay extends StatelessWidget {
  /// Nombre de la carta
  final String name;

  const CardNameOverlay({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Align(
      /// Alinea el overlay en la parte inferior de la carta
      alignment: Alignment.bottomCenter,

      child: Container(
        /// Espaciado interno del texto
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),

        /// Gradiente que oscurece la parte inferior de la imagen
        /// para mejorar el contraste del texto
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black87],
          ),
        ),

        child: Text(
          /// Texto en mayúsculas para uniformidad visual
          name.toUpperCase(),

          /// Centra el texto horizontalmente
          textAlign: TextAlign.center,

          /// Máximo de líneas permitidas
          maxLines: 2,

          /// Manejo de desbordamiento con puntos suspensivos
          overflow: TextOverflow.ellipsis,

          /// Estilo del texto
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,

            /// Sombra para mejorar la legibilidad sobre la imagen
            shadows: [Shadow(blurRadius: 4, color: Colors.black)],
          ),
        ),
      ),
    );
  }
}
