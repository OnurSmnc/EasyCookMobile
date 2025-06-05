import 'package:flutter/material.dart';

class MadedRecipes extends StatefulWidget {
  final String recipeTitle;
  final int recipeId;

  const MadedRecipes({
    Key? key,
    required this.recipeTitle,
    required this.recipeId,
  }) : super(key: key);

  @override
  _MadedRecipesState createState() => _MadedRecipesState();
}

class _MadedRecipesState extends State<MadedRecipes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeTitle),
      ),
      body: Center(
        child: Text('Recipe ID: ${widget.recipeId}'),
      ),
    );
  }
}
