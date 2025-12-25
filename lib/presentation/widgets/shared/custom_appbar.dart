import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title), backgroundColor: Colors.blue);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
