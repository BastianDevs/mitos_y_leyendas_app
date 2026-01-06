import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mitos_y_leyendas_app/domain/entities/card.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';

class CustomShowCardDialog {
  static void show(BuildContext context, CardEntity card) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'card-detail',
      barrierColor: Colors.black.withValues(alpha: 0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return _CardDetailDialog(card: card);
      },
    );
  }
}

class _CardDetailDialog extends StatelessWidget {
  final CardEntity card;

  const _CardDetailDialog({required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          /// BLUR BACKGROUND
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.black.withValues(alpha: 0.2)),
          ),

          /// CARD CONTENT
          Center(
            child: Hero(
              tag: card.slug,
              flightShuttleBuilder: (context, animation, _, __, toHeroContext) {
                return FadeTransition(
                  opacity: animation,
                  child: toHeroContext.widget,
                );
              },
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

class _CardContainer extends StatelessWidget {
  final CardEntity card;

  const _CardContainer({required this.card});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// CONTENIDO DE LA CARD
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// IMAGE
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: CardImage(card: card),
              ),

              /// DETAILS
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

        /// BOTÓN CERRAR
        Positioned(
          top: 6,
          right: 6,
          child: IconButton(
            icon: const Icon(Icons.close),
            color: Colors.white,
            splashRadius: 20,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
