import 'package:flutter/material.dart';

class CustomGridview extends StatelessWidget {
  const CustomGridview({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return Container(color: Colors.red, margin: EdgeInsets.all(10.0));
      },
      itemCount: 10,
    );
  }
}
