import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const FooterWidget(
      {super.key, required this.currentIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      onTap: onItemTapped,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    );
  }
}
