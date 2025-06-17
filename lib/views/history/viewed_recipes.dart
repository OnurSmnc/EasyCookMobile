import 'package:easycook/core/data/models/recipes.dart';
import 'package:easycook/core/data/models/viewedHistory.dart';
import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:easycook/core/data/models/Recipe.dart';
import 'package:easycook/views/favorite/favorite_page.dart';
import 'package:easycook/views/home/screens/home_recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ViewedRecipes extends StatefulWidget {
  final int selectedIndex;
  final List<ViewedRecipeHistoryItem> // Use the correct type for your data
      suggestedRecipes; // Make sure this is passed correctly

  const ViewedRecipes({
    required this.selectedIndex,
    required this.suggestedRecipes,
    Key? key,
  }) : super(key: key);

  @override
  _ViewedRecipesState createState() => _ViewedRecipesState();
}

class _ViewedRecipesState extends State<ViewedRecipes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.selectedIndex == 0
              ? Colors.orange.shade50
              : Colors.transparent,
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.suggestedRecipes.length,
          itemBuilder: (context, index) {
            final viewedRecipe = widget.suggestedRecipes[index];

            // Recipes modeline uygun şekilde doldur
            final recipe = Recipes(
              title: viewedRecipe.title,
              recipeFood: viewedRecipe.recipeFood,
              ingredients: viewedRecipe.ingredients,
              url: viewedRecipe.url,
              id: viewedRecipe.recipeId,
              createdDate: viewedRecipe.viewedDate,
              image: viewedRecipe.image,
            );

            return RecipeCard(
              recipe: recipe,
              viewedRecipeId: viewedRecipe.id as int,
              dateTitle: 'Görüntülenme Tarihi',
            );
          },
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipes recipe;
  final int viewedRecipeId;
  final String dateTitle;

  const RecipeCard(
      {Key? key,
      required this.recipe,
      required this.viewedRecipeId,
      required this.dateTitle})
      : super(key: key);

  String formatDate(String? dateString) {
    if (dateString == null) return "Tarih yok";

    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat("d MMMM y HH:mm", "tr_TR").format(date);
    } catch (e) {
      return "$e";
    }
  }

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
            height: 200,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[300],
            ),
            child: (recipe.image != null && recipe.image!.isNotEmpty)
                ? Image.network(
                    recipe.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Text('Resim yüklenemedi'),
                    ),
                  )
                : const Center(child: Text('Resim yok')),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Text(
                      dateTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formatDate(recipe.createdDate),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// Ingredients
                Text(
                  'Malzemeler: ${recipe.ingredients}',
                  style: const TextStyle(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                /// URL
                Text(
                  'Url: ${recipe.url}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.blueAccent,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                /// Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButtonWidget(
                      onPressed: () {
                        // Navigate to the recipe detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeRecipePage(
                                recipe: recipe, viewedRecipeId: viewedRecipeId),
                          ),
                        );
                      },
                      icon: const Icon(Icons.restaurant_menu),
                      title: 'Tarife Git'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
