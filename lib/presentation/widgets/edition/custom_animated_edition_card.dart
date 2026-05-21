import 'package:flutter/material.dart';

/// Widget que aplica una animación de entrada a cada tarjeta de edición.
///
/// Características:
/// - Animación de aparición progresiva (fade + slide).
/// - Delay incremental basado en el índice del elemento.
/// - Ideal para listas donde los elementos aparecen uno a uno.
///
/// Uso:
/// AnimatedEditionCard(
///   index: index,
///   child: EditionCard(...),
/// )
class AnimatedEditionCard extends StatefulWidget {
  /// Widget hijo que será animado (por ejemplo, una tarjeta de edición)
  final Widget child;

  /// Índice del elemento dentro de la lista.
  /// Se utiliza para calcular el delay de la animación.
  final int index;

  const AnimatedEditionCard({
    super.key,
    required this.child,
    required this.index,
  });

  @override
  State<AnimatedEditionCard> createState() => _AnimatedEditionCardState();
}

class _AnimatedEditionCardState extends State<AnimatedEditionCard>
    with SingleTickerProviderStateMixin {
  /// Controlador principal de la animación.
  /// Permite iniciar, detener y controlar el progreso de la animación.
  late final AnimationController _controller;

  /// Animación con curva aplicada para suavizar el movimiento.
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    /// Inicializa el controlador de animación.
    ///
    /// - vsync: optimiza el rendimiento sincronizando la animación con el frame rate.
    /// - duration: duración total de la animación.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    /// Define la curva de animación.
    ///
    /// Curves.easeOutExpo genera un efecto moderno:
    /// muy rápido al inicio y extremadamente suave al final,
    /// dando una sensación de ligereza a la entrada de cada tarjeta.
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo,
    );

    /// Calcula un delay progresivo según la posición del elemento en la lista.
    /// Se limita al índice 5 para que en listas largas la animación
    /// no se sienta excesivamente lenta — todos los elementos
    /// posteriores al quinto comparten el mismo delay máximo de 500ms.
    ///
    /// Ejemplo:
    /// - index 0 → 0 ms
    /// - index 1 → 100 ms
    /// - index 2 → 200 ms
    /// - index 5+ → 500 ms (tope máximo)
    final delay = Duration(milliseconds: 100 * widget.index.clamp(0, 5));

    /// Ejecuta la animación después del delay calculado.
    ///
    /// Se verifica [mounted] para evitar llamar a [_controller.forward]
    /// si el widget fue destruido antes de que termine el Future,
    /// lo que causaría una excepción en tiempo de ejecución.
    Future.delayed(delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    /// Libera los recursos del controlador de animación.
    /// Es obligatorio para evitar memory leaks.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      /// Animación de opacidad: la tarjeta aparece gradualmente desde
      /// transparente hasta completamente visible.
      opacity: _animation,

      child: SlideTransition(
        /// Animación de desplazamiento vertical: la tarjeta sube
        /// ligeramente desde su posición inicial hasta su lugar final.
        ///
        /// begin: desplazada un 20% hacia abajo de su posición final.
        /// end: posición natural en el layout (sin desplazamiento).
        position: Tween<Offset>(
          begin: const Offset(0.1, 0), // desde la derecha, sutil
          end: Offset.zero,
        ).animate(_animation),

        child: widget.child,
      ),
    );
  }
}
