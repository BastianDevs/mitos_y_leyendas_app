import 'package:flutter/material.dart';

class AnimatedEditionCard extends StatefulWidget {
  final Widget child;
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
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    /// Controlador de la animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    /// Curva de animación (suave y moderna)
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    /// Delay progresivo según el índice
    final delay = Duration(milliseconds: 100 * widget.index);

    Future.delayed(delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(5, 0.2), // desde abajo
          end: Offset.zero,
        ).animate(_animation),
        child: widget.child,
      ),
    );
  }
}
