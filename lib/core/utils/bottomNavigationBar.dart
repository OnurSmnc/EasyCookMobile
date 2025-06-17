import 'package:easycook/views/history/used_images.dart';
import 'package:flutter/material.dart';
import 'package:easycook/views/search/search_page.dart';
import 'package:easycook/views/favorite/favorite_page.dart';
import 'package:easycook/views/history/history_page.dart';
import 'package:easycook/views/user/screens/user_profile_page.dart';
import 'package:easycook/views/home/screens/home_page.dart';

class MainNavigationWrapper extends StatefulWidget {
  final String? image;

  const MainNavigationWrapper({Key? key, this.image}) : super(key: key);

  @override
  _MainNavigationWrapperState createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // image varsa sadece ilk HomePage'e geçerken ilet
    _pages = [
      HomePage(image: widget.image), // İlk açılışta image varsa kullan
      const SearchPage(),
      const FavoritePage(),
      const HistoryPage(),
      const UserProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            // image sadece ilk sayfada kullanılmalı, diğer geçişlerde sıfırla
            if (_pages[0] is HomePage && index == 0 && widget.image != null) {
              _pages[0] = const HomePage(); // Resimsiz HomePage’e geç
            }
          });
        },
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Arama'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favoriler'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Geçmiş'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
