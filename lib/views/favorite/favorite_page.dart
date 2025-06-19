import 'package:easycook/core/data/models/favorite.dart';
import 'package:easycook/core/data/models/recipes.dart';
import 'package:easycook/core/data/repositories/favorite_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/core/utils/bottomNavigationBar.dart';
import 'package:easycook/core/data/models/Recipe.dart';
import 'package:easycook/views/home/screens/home_recipe_page.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Favorite> _favoriteRecipes = [];
  List<bool> _tappedState = [];
  final ApiService _api = ApiService(baseUrl: ApiConstats.baseUrl);
  late final favoriteRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favoriteRepository = FavoriteRepository();
    _fetchFavorite();
  }

  Future<void> _fetchFavorite() async {
    final repo = FavoriteRepository();
    final favorite = await repo.getFavorites();
    if (!mounted) return;
    setState(() {
      _favoriteRecipes = favorite.reversed.toList();
      ;
      _tappedState = List.generate(
        _favoriteRecipes.length ?? 0,
        (index) => false,
      );
    });
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  void _onRecipeTapped(int index) async {
    setState(() {
      _tappedState[index] = true; // Sadece tıklananı beyaz yap
    });

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeRecipePage(
          viewedRecipeId: _favoriteRecipes[index].viewedRecipesId
              as int, // Use non-nullable recipeId
          recipe: Recipes(
            title: _favoriteRecipes[index].viewedRecipe.title,
            id: _favoriteRecipes[index].viewedRecipe.recipeId,
            ingredients: _favoriteRecipes[index].viewedRecipe.ingredients,
            url: _favoriteRecipes[index].viewedRecipe.url,
            recipeFood: _favoriteRecipes[index].viewedRecipe.recipeFood,
            image: _favoriteRecipes[index].viewedRecipe.image,
          ),
          favoriteRecipeId: _favoriteRecipes[index].id,
          favoriteRepository: favoriteRepository,
        ),
      ),
    );

    // Geri dönünce tüm state'i sıfırla
    setState(() {
      _tappedState = List.generate(_favoriteRecipes.length, (i) => false);
    });
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Sevdiğiniz Tarifler",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
          Divider(
            color: Colors.orange,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = _favoriteRecipes[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: InkWell(
                      onTap: () => _onRecipeTapped(index), // Handle tap
                      splashColor:
                          Colors.orange.withOpacity(0.5), // Splash color
                      highlightColor: Colors.orange.withOpacity(0.2),

                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(recipe.viewedRecipe.image as String),
                        ),
                        title: Text(
                          recipe.viewedRecipe.title,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _tappedState[index]
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Hazırlık Süresi: ${recipe.preparationTime} dakika"),
                            SizedBox(height: 4),
                            Text(
                              "Tarih: ${_formatDate(recipe.createdDate as DateTime)}", // Buraya tarih geliyor
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.favorite, color: Colors.orange),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(recipe.imageUrl),
            SizedBox(height: 20),
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...recipe.ingredients
                .map((ingredient) => Text(ingredient))
                .toList(),
            SizedBox(height: 20),
            Text(
              'Preparation Time: ${recipe.preparationTime}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
