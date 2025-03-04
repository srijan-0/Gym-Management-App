import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Color? titleColor; // ✅ Store title color
  final List<Widget>? actions;

  const HeaderWidget({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.titleColor, // ✅ Accept it here
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            color: titleColor ?? Colors.white), // ✅ Default to white if null
      ),
      backgroundColor: Colors.deepPurple.shade900,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
