import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';

/// Clase utilitaria que expone el dialog de detalle de carta.
///
/// Se implementa como clase con método estático para poder llamarse
/// desde cualquier widget sin necesidad de instanciarla:
/// `CustomShowCardDialog.show(context, card)`
class CustomShowCardDialog {
  /// Muestra el dialog de detalle de la carta seleccionada.
  ///
  /// Usa [showGeneralDialog] en lugar de [showDialog] para tener
  /// control total sobre la animación de entrada, el blur del fondo
  /// y la integración con la animación Hero desde el grid.
  ///
  /// [context] contexto de navegación actual.
  /// [card] entidad de la carta cuyo detalle se mostrará.
  static void show(BuildContext context, CardEntity card) {
    showGeneralDialog(
      context: context,

      /// Permite cerrar el dialog tocando fuera del contenido.
      /// Al combinarse con Hero, también dispara la animación de retorno.
      barrierDismissible: true,

      /// Etiqueta requerida cuando [barrierDismissible] es true.
      /// También es usada por lectores de pantalla para accesibilidad.
      barrierLabel: 'card-detail',

      /// Fondo semitransparente que oscurece la pantalla detrás del dialog.
      /// El blur adicional se aplica dentro del dialog con [BackdropFilter].
      barrierColor: Colors.black.withValues(alpha: 0.3),

      /// Duración de la animación de entrada y salida del dialog.
      /// Debe coincidir con la duración del Hero para una transición coherente.
      transitionDuration: const Duration(milliseconds: 300),

      /// Construye el contenido del dialog.
      /// Los parámetros de animación están disponibles pero no se usan aquí
      /// porque la animación se delega completamente al Hero interno.
      pageBuilder: (_, __, ___) {
        return _CardDetailDialog(card: card);
      },
    );
  }
}

/// Dialog que muestra el detalle de una carta seleccionada.
///
/// Estructura visual:
/// - Fondo con efecto blur capturado del contenido detrás del dialog
/// - Animación Hero que conecta la carta del grid con este dialog
/// - Contenedor centrado con imagen, nombre y botón de cierre
class _CardDetailDialog extends StatelessWidget {
  final CardEntity card;

  const _CardDetailDialog({required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Transparente para que el [BackdropFilter] pueda capturar
      /// y difuminar el contenido que hay detrás del dialog.
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [
          /// FONDO DIFUMINADO
          ///
          /// [BackdropFilter] captura los píxeles detrás del widget
          /// y les aplica un desenfoque gaussiano.
          /// El [Container] hijo agrega una capa oscura para mejorar
          /// el contraste del contenido de la carta sobre el fondo.
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.black.withValues(alpha: 0.2)),
          ),

          /// CONTENIDO PRINCIPAL
          ///
          /// [Hero] conecta esta vista con la carta de origen en el grid.
          /// El tag debe ser idéntico al usado en [CustomGridview]
          /// para que Flutter identifique el par origen-destino.
          Center(
            child: Hero(
              tag: card.slug,

              /// Personaliza la apariencia de la carta durante el vuelo Hero.
              /// Se usa un [FadeTransition] para que la carta aparezca
              /// gradualmente mientras se desplaza desde el grid al centro.
              /// Sin esto, Flutter usaría una interpolación visual abrupta.
              flightShuttleBuilder: (context, animation, _, __, toHeroContext) {
                return FadeTransition(
                  opacity: animation,
                  child: toHeroContext.widget,
                );
              },

              /// [Material] transparente es necesario cuando el Hero
              /// contiene widgets que usan Ink (como InkWell o botones),
              /// para que las sombras y efectos de tinta se rendericen
              /// correctamente durante la animación.
              child: Material(
                color: Colors.transparent,
                child: _CardContainer(card: card),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Contenedor visual del detalle de la carta.
///
/// Compuesto por tres capas en un [Stack]:
/// - El contenedor principal con imagen y nombre
/// - Un botón de cierre posicionado en la esquina superior derecha
class _CardContainer extends StatelessWidget {
  final CardEntity card;

  const _CardContainer({required this.card});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// TARJETA PRINCIPAL
        Container(
          /// Ancho relativo al 85% de la pantalla para adaptarse
          /// a cualquier tamaño de dispositivo sin desbordar.
          width: MediaQuery.of(context).size.width * 0.85,

          decoration: BoxDecoration(
            /// Color de fondo tomado del theme activo.
            /// Se adapta automáticamente a modo claro y oscuro.
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// IMAGEN DE LA CARTA
              ///
              /// [ClipRRect] recorta solo las esquinas superiores
              /// para que coincidan con el borde del contenedor.
              /// [AspectRatio] fija las proporciones en 0.7 (mismo valor
              /// que [CustomGridview]) para que la animación Hero no
              /// deforme la imagen durante el vuelo entre pantallas.
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: AspectRatio(
                  aspectRatio: 0.7,
                  child: CardImage(card: card),
                ),
              ),

              /// NOMBRE DE LA CARTA
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  card.name.toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),

        /// BOTÓN DE CIERRE
        ///
        /// [Positioned] lo ubica en la esquina superior derecha,
        /// ligeramente fuera del borde del contenedor para un
        /// efecto visual flotante sobre la carta.
        Positioned(
          top: -3,
          right: -3,

          child: IconButton(
            icon: const Icon(Icons.close),
            color: Colors.white,
            style: IconButton.styleFrom(
              /// Fondo semitransparente para que el ícono sea legible
              /// independientemente del color de la imagen de la carta.
              backgroundColor: Colors.black.withValues(alpha: 0.4),
            ),

            /// [Navigator.pop] cierra el dialog y dispara la animación
            /// Hero de retorno hacia la carta de origen en el grid.
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
