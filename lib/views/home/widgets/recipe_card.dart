// lib/features/home/widgets/recipe_card.dart
import 'dart:io';

import 'package:easycook/core/data/models/recipes.dart';
import 'package:easycook/core/data/repositories/viewed_recipe_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:easycook/views/home/screens/home_recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecipeCards extends StatelessWidget {
  final Recipes recipe;

  const RecipeCards({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: (recipe.image != null &&
                    recipe.image!.isNotEmpty &&
                    recipe.image != "null")
                ? Image.network(
                    recipe.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Text('Resim yüklenemedi')),
                  )
                : const Center(child: Text('Resim yok')),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  maxLines: 1,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: recipe.title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Malzemeler: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[300],
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: recipe.ingredients,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  maxLines: 3,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Link: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[300],
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: recipe.url,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      maxLines: 3,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Kalori: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[300],
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: recipe.calorieDto != null
                                ? recipe.calorieDto!.calorie.toString()
                                : 'Bilinmiyor',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      maxLines: 3,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Hazırlık Süresi: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[300],
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: recipe.preparationTime != null
                                ? recipe.preparationTime.toString() + ' dk'
                                : 'Bilinmiyor',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButtonWidget(
                  onPressed: () async {
                    final viewedRecipeId = await ViewedRecipeRepository(
                      ApiService(baseUrl: ApiConstats.baseUrl),
                    ).addViewedRecipe(recipe.id);

                    if (viewedRecipeId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeRecipePage(
                            recipe: recipe,
                            viewedRecipeId:
                                viewedRecipeId, // <-- Bunu da gönder!
                          ),
                        ),
                      );
                    } else {
                      // Hata mesajı göster
                    }
                  },
                  title: "Tarifi Gör",
                  icon: const Icon(Icons.restaurant_menu),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TestButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print("Butona basıldı");
          },
          child: Text("Test Butonu"),
        ),
      ),
    );
  }
}
