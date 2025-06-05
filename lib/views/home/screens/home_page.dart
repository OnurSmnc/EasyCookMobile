// lib/features/home/screens/home_page.dart
import 'dart:io';

import 'package:easycook/core/data/models/detect_ingredient.dart';
import 'package:easycook/core/data/models/recipes.dart';
import 'package:easycook/core/data/repositories/recipe_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:easycook/views/home/widgets/recipe_modal_popup.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  List<DetectedIngredient> _detectedIngredients = [];
  List<Recipes> _suggestedRecipes = [];
  bool _isLoading = false;

  void _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isLoading = true;
      });

      try {
        final response =
            await RecipeRepository().detectIngredientsFromImage(_image!);

        setState(() {
          _detectedIngredients = response.detectedIngredients;
          _suggestedRecipes = response.recipes;
          _isLoading = false;
        });
      } catch (e) {
        print("API hatası: $e");
        setState(() {
          _isLoading = false;
        });
      }
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
      appBar: AppBar(
        title: const Text(
          'EasyCook',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
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
                      child: Image.file(
                        _image!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Center(
                      child: Text('Fotoğraf seçilmedi'),
                    ),
            ),

            // Fotoğraf seçme butonları
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButtonWidget(
                      icon: Icon(Icons.photo_library),
                      title: "Galeriden Seç",
                      onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButtonWidget(
                      icon: Icon(Icons.camera_alt_sharp),
                      title: "Fotoğraf Çek",
                      onPressed: () => _pickImage(ImageSource.camera),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Loading indicator
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
                                label: Text(ingredient.name),
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
