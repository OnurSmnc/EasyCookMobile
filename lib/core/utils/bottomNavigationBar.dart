// lib/main.dart
import 'package:easycook/views/home/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:easycook/views/favorite/favorite_page.dart';
import 'package:easycook/views/history/history_page.dart';
import 'package:easycook/views/home/screens/home_page.dart';

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({Key? key}) : super(key: key);

  @override
  _MainNavigationWrapperState createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  // Page list
  final List<Widget> _pages = [
    const HomePage(),
    const FavoritePage(),
    TestButtonPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Show selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
            backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoriler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'TestBuuton',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Required for more than 3 items
        onTap: _onItemTapped, // Tab change
      ),
    );
  }
}
