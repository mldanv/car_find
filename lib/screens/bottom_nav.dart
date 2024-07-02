import 'package:car_find/screens/favorite_screen.dart';
import 'package:car_find/screens/home_screen.dart';
import 'package:car_find/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: const TabBarView(
          children: [
            HomeScreen(),
            FavoriteScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: Container(
          child: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.home),
            ),
            Tab(
              icon: Icon(Icons.favorite),
            ),
            Tab(
              icon: Icon(Icons.person),
            ),
          ]),
        ),
      ),
    );
  }
}
