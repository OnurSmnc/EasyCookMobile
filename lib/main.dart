import 'package:easycook/core/utils/bottomNavigationBar.dart';
import 'package:easycook/views/favorite/favorite_page.dart';
import 'package:easycook/views/history/history_page.dart';
import 'package:easycook/views/home/screens/home_page.dart';
import 'package:easycook/views/home/screens/home_recipe_page.dart';
import 'package:easycook/views/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Malzeme Tespit ve Tarif Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}
