import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:easycook/models/Recipe.dart';
import 'package:flutter/material.dart';

class ViewedRecipes extends StatefulWidget {
  final int selectedIndex;
  final List<Recipe> suggestedRecipes; // Make sure this is passed correctly

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
          itemCount: widget
              .suggestedRecipes.length, // Use widget.suggestedRecipes here
          itemBuilder: (context, index) {
            final recipe = widget.suggestedRecipes[index]; // Access the recipe
            return RecipeCard(
                recipe: recipe); // Pass recipe to the RecipeCard widget
          },
        ),
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
                    onPressed: () => {}, // Add functionality if needed
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
