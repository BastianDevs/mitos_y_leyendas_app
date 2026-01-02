import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mitos_y_leyendas_app/domain/entities/edition.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/edition/edition_provider.dart';

class EditionListView extends ConsumerWidget {
  const EditionListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editions = ref.watch(editionProvider);

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: editions.length,
      itemBuilder: (context, index) {
        final edition = editions[index];

        return EditionCard(edition: edition);
      },
    );
  }
}

class EditionCard extends StatelessWidget {
  final EditionEntity edition;

  const EditionCard({super.key, required this.edition});

  @override
  Widget build(BuildContext context) {
    final imageUrl = 'https://api.myl.cl/static/${edition.slug}.png';

    return InkWell(
      onTap: () {
        context.pushNamed(
          'cards-screen',
          pathParameters: {'editionSlug': edition.slug},
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                edition.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5),
            // Imagen
            SizedBox(
              height: 100,
              child: Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,

                  // Loader mientras carga
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        color: Colors.grey,
                      ),
                    );
                  },

                  // Imagen por defecto
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/no_image.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
