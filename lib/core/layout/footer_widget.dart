import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/features/cart/presentation/pages/cart_page.dart';
import 'package:login/features/category/presentation/bloc/category_bloc.dart';
import 'package:login/features/category/presentation/pages/category_page.dart';
import 'package:login/features/home/presentation/view/home_screen.dart';
import 'package:login/features/product/prsentation/pages/product_page.dart';

class FooterWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const FooterWidget(
      {super.key, required this.currentIndex, required this.onItemTapped});

  void _navigateToPage(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget page = _getPage(context, index); // ✅ Correctly gets the page widget

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget _getPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return BlocProvider.value(
          value: BlocProvider.of<CategoryBloc>(context),
          child: const CategoryPage(),
        );
      case 2:
        return const ProductPage();
      case 3:
        return const CartPage(); // ✅ FIX: Return CartPage instead of using Navigator.push()
      default:
        return const HomeScreen();
    }
  }

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
          label: 'Cart',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      onTap: (index) => _navigateToPage(context, index),
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    );
  }
}
