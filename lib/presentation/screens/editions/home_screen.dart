import 'package:flutter/material.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  // Nombre de la ruta
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "TCG - MYL: Ediciones Imperio"),
      body: EditionListView(),
    );
  }
}
