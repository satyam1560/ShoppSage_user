import 'package:ecommerce_user/src/core/features/display_products/presentation/pages/home_page_screen.dart';
import 'package:ecommerce_user/src/core/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:ecommerce_user/src/core/features/favorite/presentation/pages/favorite_screen.dart';
import 'package:ecommerce_user/src/core/features/profile/presentation/pages/profile_screen.dart';
import 'package:ecommerce_user/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/pages/cart_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 60,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: TColors.buttonPrimary,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          const NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
              color: TColors.white,
            ),
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: const Icon(
              Icons.shopping_cart,
              color: TColors.white,
            ),
            icon: Badge(
              label: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  return Text('${state.cartProducts?.length}');
                },
              ),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            label: 'Cart',
          ),
          NavigationDestination(
            selectedIcon: const Icon(
              Icons.favorite,
              color: TColors.white,
            ),
            icon: Badge(
              label: BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, state) {
                  return Text('${state.products?.length}');
                },
              ),
              child: const Icon(Icons.favorite_border_outlined),
            ),
            label: 'Favorites',
          ),
          const NavigationDestination(
            selectedIcon: Icon(
              Icons.person,
              color: TColors.white,
            ),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),

      body: <Widget>[
        ///Home page
        const HomePageScreen(),

        /// Cart page
        const CartScreen(),

        /// Favorite
        const FavoriteScreen(),

        /// Profile
        const ProfileScreen()
      ][currentPageIndex],
      //
    ));
  }
}
