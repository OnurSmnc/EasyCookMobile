import 'package:easycook/core/data/repositories/favorite_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easycook/core/data/models/recipes.dart';

class HomeRecipePage extends StatelessWidget {
  final Recipes recipe;
  final int viewedRecipeId;
  const HomeRecipePage(
      {Key? key, required this.recipe, required this.viewedRecipeId})
      : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'URL açılamıyor: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final ingredients = recipe.ingredients is String
        ? (recipe.ingredients as String).split(',')
        : (recipe.ingredients as List).cast<String>();

    final List<String> recipeFood;

// Properly handle the recipe preparation steps whether they're in string or list format
    if (recipe.recipeFood is String) {
      // Split the string by periods and filter out any empty strings
      recipeFood = (recipe.recipeFood as String)
          .split('.')
          .where((step) => step.trim().isNotEmpty)
          .map((step) => step.trim())
          .toList();
    } else {
      // Cast to List<String> if it's already a list
      recipeFood = (recipe.recipeFood as List).cast<String>();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EasyCook',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Geçici resim eklendi
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(
                Icons.image,
                size: 100,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            Center(
              child: Text(
                recipe.title,
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.orange[500]),
            const SizedBox(height: 12),
            Text(
              "Malzemeler:",
              style: TextStyle(
                color: Colors.orange[500],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            ...ingredients.map((item) => Text("- $item")).toList(),
            const SizedBox(height: 12),
            Divider(color: Colors.orange[500]),
            const SizedBox(height: 12),
            Text(
              "Yapılışı:",
              style: TextStyle(
                color: Colors.orange[500],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...recipeFood.asMap().entries.map((entry) {
              int idx = entry.key + 1;
              String step = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("$idx-) $step."),
              );
            }).toList(),
            const SizedBox(height: 12),
            Divider(color: Colors.orange[500]),
            const SizedBox(height: 12),
            if (recipe.url != null && recipe.url.isNotEmpty)
              TextButton(
                onPressed: () => _launchURL(recipe.url),
                child: const Text("Tarif Kaynağına Git"),
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.orange[50],
          border: Border(
            top: BorderSide(
              color: Colors.orange[500]!,
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButtonWidget(
                onPressed: () async {
                  await FavoriteRepository(
                    ApiService(baseUrl: ApiConstats.baseUrl),
                  ).addFavoriteRecipe(viewedRecipeId);
                },
                icon: const Icon(Icons.favorite_border),
                title: "Favorilere Ekle",
              ),
              const SizedBox(width: 12),
              ElevatedButtonWidget(
                onPressed: () {
                  print("Yorum yapıldı");
                },
                icon: const Icon(Icons.comment),
                title: "Yorum Yap",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
