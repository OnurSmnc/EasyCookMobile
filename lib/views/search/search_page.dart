// lib/features/home/screens/home_page.dart
import 'dart:io';

import 'package:easycook/core/data/models/detect_ingredient.dart';
import 'package:easycook/core/data/models/recipes.dart';
import 'package:easycook/core/data/repositories/recipe_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:easycook/views/favorite/favorite_page.dart';
import 'package:easycook/views/history/yap%C4%B1lan_tarifler.dart';
import 'package:easycook/views/home/widgets/ingredinet_select.dart';
import 'package:easycook/views/home/widgets/recipe_modal_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EasyCook',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent, // Rengi buraya taşıyoruz
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Tarif bulmak için arama yapın',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Butona basıldığında yapılacaklar
                  print('Buton tıklandı');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, // yazı rengi
                  backgroundColor:
                      Colors.orange[100], // buton arkaplan rengi (örnek)
                  side: BorderSide(color: Colors.black, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.zero, // Burada radius'u ayarlıyorsun
                  ),
                ),
                child: const Text('Malzeme Öner'),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: IngredientCard(),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              ElevatedButtonWidget(
                onPressed: () => {},
                title: 'Tarif Ara',
                icon: Icon(Icons.search),
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
