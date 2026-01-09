import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AutoSizeText(
        title,
        maxLines: 1,
        maxFontSize: 25, // 🔥 tamaño máximo
        minFontSize: 14, // tamaño mínimo aceptable
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
