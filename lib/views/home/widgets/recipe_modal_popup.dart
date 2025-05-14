// lib/features/home/widgets/recipes_modal_popup.dart
import 'package:easycook/core/data/models/detect_ingredient.dart';
import 'package:easycook/core/data/models/recipes.dart';
import 'package:easycook/views/home/widgets/recipe_card.dart';
import 'package:flutter/material.dart';

class RecipesModalPopup extends StatelessWidget {
  final List<DetectedIngredient> ingredients;
  final List<Recipes> recipes;

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
                            label: Text(ingredient.name),
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
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return RecipeCards(recipe: recipe);
              },
            ),
          ),
        ],
      ),
    );
  }
}
