import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mitos_y_leyendas_app/presentation/provider/edition/edition_provider.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';

class CardsScreen extends ConsumerWidget {
  final String editionSlug;

  const CardsScreen({super.key, required this.editionSlug});

  // Nombre de la ruta
  static const name = 'cards-screen';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edition = ref.watch(editionBySlugProvider(editionSlug));
    return Scaffold(
      appBar: CustomAppbar(title: edition?.title ?? 'Cartas'),
      drawer: context.widget,
    );
  }
}
