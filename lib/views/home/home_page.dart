import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easycook/core/widgets/ImagePickerWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:easycook/core/utils/bottomNavigationBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  List<String> _detectedIngredients = [];
  List<Recipe> _suggestedRecipes = [];
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile == null) return;

      setState(() {
        _isLoading = true;
        _image = File(pickedFile.path);
      });

      // Burada görüntü işleme ve malzeme tespiti yapılacak
      // API çağrısı veya ML model kullanımı gerçekleştirilecek

      // Örnek tespit edilen malzemeler (gerçek uygulamada API'den gelecek)
      await Future.delayed(
          const Duration(seconds: 2)); // API çağrısı simülasyonu

      setState(() {
        _detectedIngredients = ['Domates', 'Soğan', 'Biber', 'Zeytinyağı'];
        _suggestedRecipes = [
          Recipe(
            name: 'Menemen',
            ingredients: ['Domates', 'Soğan', 'Biber', 'Yumurta', 'Zeytinyağı'],
            preparationTime: '20 dk',
            imageUrl: 'https://example.com/menemen.jpg',
          ),
          Recipe(
            name: 'Domates Çorbası',
            ingredients: ['Domates', 'Soğan', 'Un', 'Tereyağı', 'Su'],
            preparationTime: '30 dk',
            imageUrl: 'https://example.com/domates_corbasi.jpg',
          ),
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    }
  }

  void _showRecipesModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => RecipesModalPopup(
        ingredients: _detectedIngredients,
        recipes: _suggestedRecipes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationMenu(),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Fotoğraf alanı
            Container(
              height: 250,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_image!, fit: BoxFit.cover),
                    )
                  : const Center(
                      child: Text('Fotoğraf seçilmedi'),
                    ),
            ),

            // Fotoğraf seçme butonları
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButtonWidget(
                    icon: Icon(Icons.photo_library),
                    title: "Galeriden Seç",
                    onPressed: () => {_pickImage(ImageSource.gallery)},
                  ),
                  ElevatedButtonWidget(
                    icon: Icon(Icons.camera_alt_sharp),
                    title: "Fotoğraf Çek",
                    onPressed: () => {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tespit edilen malzemeler bölümü

            const SizedBox(height: 24),

            // Önerilen tarifler bölümü
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ),

            // Tespit edilen malzemeler bölümü
            if (_detectedIngredients.isNotEmpty && !_isLoading)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Tespit Edilen Malzemeler:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _detectedIngredients
                          .map((ingredient) => Chip(
                                label: Text(ingredient),
                                backgroundColor: Colors.orange[100],
                                labelStyle:
                                    const TextStyle(color: Colors.black87),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _showRecipesModal,
                      icon: const Icon(Icons.restaurant_menu),
                      label: const Text('Önerilen Tarifleri Göster'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class RecipesModalPopup extends StatelessWidget {
  final List<String> ingredients;
  final List<Recipe> recipes;

  const RecipesModalPopup({
    Key? key,
    required this.ingredients,
    required this.recipes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // Üst kısım - Başlık ve kapatma butonu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Önerilen Tarifler',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Tespit edilen malzemeler
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tespit Edilen Malzemeler:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ingredients
                      .map((ingredient) => Chip(
                            label: Text(ingredient),
                            backgroundColor: Colors.orange[100],
                            labelStyle: const TextStyle(color: Colors.black87),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),

          const Divider(),

          // Tarifler listesi
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return RecipeCard(recipe: recipe);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text('${recipe.name} Görseli'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
                const SizedBox(height: 8),
                Text(
                  'Malzemeler: ${recipe.ingredients.join(", ")}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hazırlama Süresi: ${recipe.preparationTime}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                ElevatedButtonWidget(
                    onPressed: () => {},
                    title: "Tarifi Gör",
                    icon: Icon(Icons.restaurant_menu))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Recipe {
  final String name;
  final List<String> ingredients;
  final String preparationTime;
  final String imageUrl;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.preparationTime,
    required this.imageUrl,
  });
}
