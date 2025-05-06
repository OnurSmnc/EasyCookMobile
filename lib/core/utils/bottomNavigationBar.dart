import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Ana Sayfa',
          backgroundColor: Colors.orange,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Arama',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favoriler',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
          backgroundColor: Colors.orange,
        ),
      ],
      currentIndex: 0, // Başlangıçta seçili olan sekme
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed, // 3'ten fazla öğe için gerekli
      onTap: (index) {
        // Burada sekme değişikliğini işleyebilirsiniz
        // Örneğin: context.go('/home') gibi navigasyon işlemleri
      },
    );
  }
}
