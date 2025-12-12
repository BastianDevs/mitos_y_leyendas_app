import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const cantidad = 10;
    return Scaffold(
      appBar: AppBar(
        title: Text('TCG - MYL Comunidad Camelot'),
        backgroundColor: Colors.blue,
      ),
      body: GridView.builder(
        itemCount: cantidad,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Container(height: 50, width: 50, color: Colors.amber),
          );
        },
      ),
    );
  }
}
