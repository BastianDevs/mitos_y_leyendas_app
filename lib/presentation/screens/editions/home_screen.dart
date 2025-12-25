import 'package:flutter/material.dart';
import 'package:mitos_y_leyendas_app/presentation/widgets/shared/custom_appbar.dart';

class HomeScreen extends StatelessWidget {
  // Nombre de la ruta
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const cantidad = 10;
    return Scaffold(
      appBar: CustomAppbar(title: "TCG - MYL: Ediciones Imperio"),
      body: GridView.builder(
        itemCount: cantidad,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Container(height: 50, width: 10, color: Colors.amber),
          );
        },
      ),
    );
  }
}
