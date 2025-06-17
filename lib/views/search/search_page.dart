// lib/features/home/screens/home_page.dart
import 'dart:io';

import 'package:easycook/core/data/models/detect_ingredient.dart';
import 'package:easycook/core/data/models/ingredient/ingredient_request.dart';
import 'package:easycook/core/data/models/recipes.dart';
import 'package:easycook/core/data/repositories/recipe_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:easycook/views/favorite/favorite_page.dart';
import 'package:easycook/views/history/yap%C4%B1lan_tarifler.dart';
import 'package:easycook/views/home/widgets/ingredinet_select.dart';
import 'package:easycook/views/home/widgets/recipe_card.dart';
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
  List<IngredientData> selectedIngredients = [];
  List<Recipes> recipesRecommended = [];
  List<DetectedIngredient> detectedIngredients = [];
  List<Recipes> _Recipes = [];
  @override
  void initState() {
    super.initState();
    _fetchRecommendationRecipes();
  }

  void _onIngredientsChanged(List<IngredientData> ingredients) {
    setState(() {
      selectedIngredients = ingredients;
    });
  }

  void _getRecipesAll() async {
    try {
      if (selectedIngredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lütfen önce malzeme seçin.")),
        );
        return;
      }

      final recipes =
          await RecipeRepository().getAllRecipesBySearch(selectedIngredients);

      if (recipes != null && mounted) {
        setState(() {
          _Recipes = recipes;

          detectedIngredients = selectedIngredients
              .map((e) => DetectedIngredient(id: e.id, name: e.name ?? ""))
              .toList();
        });

        _showRecipesModal();
      }

      print("Gelen tarif sayısı: ${recipes.length}");
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  void _showRecipesModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => RecipesModalPopup(
        ingredients: detectedIngredients,
        recipes: _Recipes,
      ),
    );
  }

  Future<void> _fetchRecommendationRecipes() async {
    try {
      final response = await RecipeRepository().getRecommendationRecipesAsync();
      if (response != null && mounted) {
        setState(() {
          recipesRecommended = response;
        });
      }
    } catch (e) {
      print('Hata: $e');
    }
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
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: IngredientCard(
                      onSelectionChanged: _onIngredientsChanged,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              ElevatedButtonWidget(
                onPressed: () => {
                  _getRecipesAll(),
                },
                title: 'Tarif Ara',
                icon: Icon(Icons.search),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Önerilen Tarifler',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: recipesRecommended.map((recipe) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        width: 280, // Sadece burada genişlik sınırla
                        height: 400, // Yüksekliği de sınırla
                        child: RecipeCards(recipe: recipe),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
