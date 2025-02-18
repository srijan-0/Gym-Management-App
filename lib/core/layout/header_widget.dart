import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const HeaderWidget(
      {super.key, required this.title, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton, // ✅ Hide Back Button if needed
      title: Text(title),
      backgroundColor: Colors.deepPurple,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
