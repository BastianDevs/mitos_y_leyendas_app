import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mitos_y_leyendas_app/domain/entities/card.dart';

class CustomGridview extends StatelessWidget {
  final List<CardEntity> cards;

  const CustomGridview({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return InkWell(
          onTap: () {
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: 'card-detail',
              barrierColor: Colors.black.withValues(alpha: 0.3),
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) {
                return _CardDetailDialog(card: card);
              },
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                /// IMAGEN CON FADE + PLACEHOLDER
                _CardImage(card: card),

                /// OVERLAY GRADIENTE + NOMBRE
                _CardNameOverlay(name: card.name),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CardImage extends StatelessWidget {
  final CardEntity card;

  const _CardImage({required this.card});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://api.myl.cl/static/cards/${card.edEdid}/${card.edid}.png',
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, _) {
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          child: child,
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress != null) {
          return const _ImageSkeleton();
        }
        return child;
      },
      errorBuilder: (_, __, ___) {
        return const Center(child: Icon(Icons.broken_image, size: 40));
      },
    );
  }
}

class _ImageSkeleton extends StatelessWidget {
  const _ImageSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: const Center(child: CircularProgressIndicator(strokeWidth: 4)),
    );
  }
}

class _CardNameOverlay extends StatelessWidget {
  final String name;

  const _CardNameOverlay({required this.name});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black87],
          ),
        ),
        child: Text(
          name.toUpperCase(),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            shadows: [Shadow(blurRadius: 4, color: Colors.black)],
          ),
        ),
      ),
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
              child: Material(
                color: Colors.transparent,
                child: Container(
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
                        child: _CardImage(card: card),
                      ),

                      /// DETAILS
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          card.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
