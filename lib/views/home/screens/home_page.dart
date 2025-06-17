// lib/features/home/screens/home_page.dart
import 'dart:io';

import 'package:easycook/core/data/models/detect_ingredient.dart';
import 'package:easycook/core/data/models/recipes.dart';
import 'package:easycook/core/data/repositories/recipe_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:easycook/views/home/widgets/ingredinet_select.dart';
import 'package:easycook/views/home/widgets/recipe_modal_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easycook/core/utils/bottomNavigationBar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String? image;
  const HomePage({Key? key, this.image}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  List<DetectedIngredient> _detectedIngredients = [];
  List<Recipes> _suggestedRecipes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.image != null && widget.image!.isNotEmpty) {
      if (widget.image!.startsWith('http')) {
        // URL ise indir
        _downloadImageToFile(widget.image!).then((file) {
          setState(() {
            _image = file;
          });
          _detectIngredientsFromImage(_image!);
        });
      } else {
        // Direkt cihaz yoluysa
        _image = File(widget.image!);
        _detectIngredientsFromImage(_image!);
      }
    }
  }

  Future<File> _downloadImageToFile(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/temp_image.jpg');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<void> _detectIngredientsFromImage(File imageFile) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response =
          await RecipeRepository().detectIngredientsFromImage(imageFile);
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

  void _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await _detectIngredientsFromImage(_image!);
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
      body: SingleChildScrollView(
        child: SizedBox(
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
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
