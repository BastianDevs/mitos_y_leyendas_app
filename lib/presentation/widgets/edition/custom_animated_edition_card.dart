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
    /// Curves.easeOutCubic genera un efecto moderno:
    /// rápido al inicio y suave al final.
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutExpo,
    );

    /// Calcula un delay progresivo según la posición del elemento en la lista.
    ///
    /// Ejemplo:
    /// - index 0 → 0 ms
    /// - index 1 → 100 ms
    /// - index 2 → 200 ms
    final delay = Duration(milliseconds: 100 * widget.index);

    /// Ejecuta la animación después del delay.
    ///
    /// Se verifica `mounted` para evitar errores si el widget fue destruido
    /// antes de que termine el Future.
    Future.delayed(delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    /// Libera los recursos del controlador de animación.
    ///
    /// Es obligatorio para evitar memory leaks.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      /// Animación de opacidad (fade-in)
      opacity: _animation,

      child: SlideTransition(
        /// Animación de desplazamiento vertical (slide-up)
        ///
        /// begin: posición inicial desplazada hacia abajo.
        /// end: posición final normal.
        position: Tween<Offset>(
          begin: const Offset(0, 0.2), // desde abajo
          end: Offset.zero,
        ).animate(_animation),

        /// Widget hijo que recibe la animación
        child: widget.child,
      ),
    );
  }
}
