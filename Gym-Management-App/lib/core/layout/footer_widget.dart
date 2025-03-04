import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/features/cart/presentation/pages/cart_page.dart';
import 'package:login/features/category/presentation/bloc/category_bloc.dart';
import 'package:login/features/category/presentation/pages/category_page.dart';
import 'package:login/features/home/presentation/view/home_screen.dart';
import 'package:login/features/product/prsentation/pages/product_page.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FooterWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const FooterWidget(
      {super.key, required this.currentIndex, required this.onItemTapped});

  void _navigateToPage(BuildContext context, int index) {
    if (index == currentIndex) return;
    Widget page = _getPage(context, index);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }

  Widget _getPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return BlocProvider.value(
            value: BlocProvider.of<CategoryBloc>(context),
            child: const CategoryPage());
      case 2:
        return const ProductPage();
      case 3:
        return const CartPage();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black, // ✅ Full solid black background
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, -2)), // ✅ Adds shadow effect
        ],
      ),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(currentIndex == 0 ? LucideIcons.home : LucideIcons.home,
                size: 28,
                color: currentIndex == 0 ? Colors.white : Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                currentIndex == 1 ? LucideIcons.layers : LucideIcons.layoutGrid,
                size: 28,
                color: currentIndex == 1 ? Colors.white : Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                currentIndex == 2 ? LucideIcons.package : LucideIcons.box,
                size: 28,
                color: currentIndex == 2 ? Colors.white : Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                currentIndex == 3
                    ? LucideIcons.shoppingCart
                    : LucideIcons.shoppingCart,
                size: 28,
                color: currentIndex == 3 ? Colors.white : Colors.grey),
            label: '',
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black, // ✅ Ensure full black background
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: (index) => _navigateToPage(context, index),
      ),
    );
  }
}
