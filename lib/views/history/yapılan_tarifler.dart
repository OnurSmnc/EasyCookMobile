import 'package:easycook/core/data/models/recipes.dart';
import 'package:easycook/core/data/models/recipes/recipeAdd/get_recipe_made_response.dart';
import 'package:easycook/views/history/viewed_recipes.dart';
import 'package:easycook/views/home/widgets/recipe_card.dart';
import 'package:flutter/material.dart';

class MadedRecipes extends StatefulWidget {
  final List<RecipeMadedGetResponse> recipeMadedList;
  final int selectedIndex;
  const MadedRecipes(
      {Key? key, required this.recipeMadedList, required this.selectedIndex})
      : super(key: key);

  @override
  _MadedRecipesState createState() => _MadedRecipesState();
}

class _MadedRecipesState extends State<MadedRecipes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.orange.shade50),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.recipeMadedList.length,
          itemBuilder: (context, index) {
            final _recipeMadedList = widget.recipeMadedList[index];

            // Recipes modeline uygun şekilde doldur
            final recipe = Recipes(
              title: _recipeMadedList.recipeDto.title,
              recipeFood: _recipeMadedList.recipeDto.recipeFood,
              ingredients: _recipeMadedList.recipeDto.ingredients,
              url: _recipeMadedList.recipeDto.url,
              id: _recipeMadedList.recipeDto.recipeId,
              createdDate: _recipeMadedList.createdDate.toIso8601String(),
              image: _recipeMadedList.recipeDto.image,
              calorieDto: _recipeMadedList.calorieDto,
              preparationTime: _recipeMadedList.recipeDto.preparationTime,
            );

            return RecipeCard(
              recipe: recipe,
              viewedRecipeId: _recipeMadedList.viewedRecipeId as int,
              dateTitle: 'Yapılma Tarihi',
            );
          },
        ),
      ),
    );
  }
}
