import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';

class CustomShowCardDialog {
  /// Método estático para mostrar el dialog de detalle de carta
  /// Se llama desde cualquier parte sin instanciar la clase
  static void show(BuildContext context, CardEntity card) {
    showGeneralDialog(
      /// Contexto de navegación actual
      /// Necesario para insertar el dialog en el árbol de widgets
      context: context,

      /// Permite cerrar el dialog tocando fuera de él
      barrierDismissible: true,

      /// Etiqueta semántica del fondo (accesibilidad)
      /// Útil para lectores de pantalla
      barrierLabel: 'card-detail',

      /// Color del fondo que cubre la pantalla detrás del dialog
      /// Se usa un negro semitransparente para oscurecer el contenido
      barrierColor: Colors.black.withValues(alpha: 0.3),

      /// Duración de la animación de entrada y salida del dialog
      transitionDuration: const Duration(milliseconds: 300),

      /// Widget que se renderiza como contenido del dialog
      /// Recibe las animaciones (no usadas aquí, pero disponibles)
      pageBuilder: (_, __, ___) {
        return _CardDetailDialog(card: card);
      },
    );
  }
}

/// Dialog que muestra el detalle de una carta seleccionada.
/// Se presenta como un overlay con fondo difuminado (blur),
/// animación Hero desde la grilla y contenido centrado.
class _CardDetailDialog extends StatelessWidget {
  /// Carta seleccionada que se mostrará en el dialog
  final CardEntity card;

  const _CardDetailDialog({required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold transparente para permitir ver el blur del fondo
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [
          /// FONDO DIFUMINADO (BLUR)
          /// Captura lo que hay detrás del dialog y le aplica desenfoque
          BackdropFilter(
            // Intensidad del blur en los ejes X e Y
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

            // Capa oscura semitransparente para mejorar contraste
            child: Container(color: Colors.black.withValues(alpha: 0.2)),
          ),

          /// CONTENIDO PRINCIPAL DE LA CARTA
          Center(
            child: Hero(
              /// Tag único que conecta la animación Hero
              /// con la imagen de la carta en la grilla
              tag: card.slug,

              /// Personaliza la animación Hero
              /// En este caso, se usa un fade suave
              flightShuttleBuilder: (context, animation, _, __, toHeroContext) {
                return FadeTransition(
                  // La opacidad sigue la animación Hero
                  opacity: animation,

                  // Widget destino de la animación
                  child: toHeroContext.widget,
                );
              },

              /// Material transparente requerido para Hero + Ink + sombras
              child: Material(
                color: Colors.transparent,

                /// Contenedor visual de la carta (imagen + detalles)
                child: _CardContainer(card: card),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Contenedor visual principal del detalle de la carta.
/// Incluye la imagen, el nombre y el botón de cierre superpuesto.
class _CardContainer extends StatelessWidget {
  /// Carta que se mostrará en el dialog
  final CardEntity card;

  const _CardContainer({required this.card});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// CONTENIDO PRINCIPAL DE LA CARTA
        /// (imagen + detalles)
        Container(
          /// Ancho relativo a la pantalla para verse bien en cualquier dispositivo
          width: MediaQuery.of(context).size.width * 0.85,

          /// Estilos visuales del contenedor
          decoration: BoxDecoration(
            // Color de fondo según el theme actual (light / dark)
            color: Theme.of(context).colorScheme.surface,

            // Bordes redondeados tipo "card"
            borderRadius: BorderRadius.circular(20),
          ),

          child: Column(
            // Ajusta la altura al contenido
            mainAxisSize: MainAxisSize.min,
            children: [
              /// IMAGEN DE LA CARTA
              /// Se recorta solo en la parte superior
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: CardImage(card: card),
              ),

              /// DETALLES DE LA CARTA
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  // Se muestra el nombre en mayúsculas
                  card.name.toUpperCase(),

                  // Estilo tipográfico del theme
                  style: Theme.of(context).textTheme.titleLarge,

                  // Texto centrado horizontalmente
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),

        /// BOTÓN DE CIERRE
        /// Se posiciona por encima del contenedor principal
        Positioned(
          // Se desplaza levemente hacia afuera del borde
          top: -3,
          right: -3,

          child: IconButton(
            // Ícono de cierre
            icon: const Icon(Icons.close),

            // Color del ícono
            color: Colors.white,

            // Estilo visual del botón
            style: IconButton.styleFrom(
              // Fondo semitransparente para contraste
              backgroundColor: Colors.black.withValues(alpha: 0.4),
            ),

            /// Cierra el dialog al presionar
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
