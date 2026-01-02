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

        return Stack(
          fit: StackFit.expand,
          children: [
            Image(
              image: NetworkImage(
                'https://api.myl.cl/static/cards/161/192.png',
              ),
            ),
            Card(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    card.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Coste: ${card.cost}'),
                  Text('Daño: ${card.damage ?? '-'}'),
                  Text(card.rarity),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
