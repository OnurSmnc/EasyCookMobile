import 'package:easycook/core/utils/bottomNavigationBar.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<String> _detectedIngredients = [];
  List<Recipe> _suggestedRecipes = [];
  List<bool> _tappedState = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _suggestedRecipes = [
      Recipe(
        name: 'Menemen',
        ingredients: ['Domates', 'Soğan', 'Biber', 'Yumurta', 'Zeytinyağı'],
        preparationTime: '20 dk',
        imageUrl: 'https://example.com/menemen.jpg',
      ),
      Recipe(
        name: 'Domates Çorbası',
        ingredients: ['Domates', 'Soğan', 'Un', 'Tereyağı', 'Su'],
        preparationTime: '30 dk',
        imageUrl: 'https://example.com/domates_corbasi.jpg',
      ),
      Recipe(
        name: 'Menemen',
        ingredients: ['Domates', 'Soğan', 'Biber', 'Yumurta', 'Zeytinyağı'],
        preparationTime: '20 dk',
        imageUrl: 'https://example.com/menemen.jpg',
      ),
      Recipe(
        name: 'Domates Çorbası',
        ingredients: ['Domates', 'Soğan', 'Un', 'Tereyağı', 'Su'],
        preparationTime: '30 dk',
        imageUrl: 'https://example.com/domates_corbasi.jpg',
      ),
      Recipe(
        name: 'Menemen',
        ingredients: ['Domates', 'Soğan', 'Biber', 'Yumurta', 'Zeytinyağı'],
        preparationTime: '20 dk',
        imageUrl: 'https://example.com/menemen.jpg',
      ),
      Recipe(
        name: 'Domates Çorbası',
        ingredients: ['Domates', 'Soğan', 'Un', 'Tereyağı', 'Su'],
        preparationTime: '30 dk',
        imageUrl: 'https://example.com/domates_corbasi.jpg',
      ),
      Recipe(
        name: 'Menemen',
        ingredients: ['Domates', 'Soğan', 'Biber', 'Yumurta', 'Zeytinyağı'],
        preparationTime: '20 dk',
        imageUrl: 'https://example.com/menemen.jpg',
      ),
      Recipe(
        name: 'Domates Çorbası',
        ingredients: ['Domates', 'Soğan', 'Un', 'Tereyağı', 'Su'],
        preparationTime: '30 dk',
        imageUrl: 'https://example.com/domates_corbasi.jpg',
      ),
      Recipe(
        name: 'Domates Çorbası',
        ingredients: ['Domates', 'Soğan', 'Un', 'Tereyağı', 'Su'],
        preparationTime: '30 dk',
        imageUrl: 'https://example.com/domates_corbasi.jpg',
      ),
    ];
    _tappedState = List.generate(_suggestedRecipes.length, (index) => false);
  }

  void _onRecipeTapped(int index) {
    setState(() {
      _tappedState[index] = !_tappedState[index]; // Toggle the tapped state
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RecipeDetailPage(recipe: _suggestedRecipes[index]),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationMenu(),
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
              shrinkWrap: true,
              itemCount: _suggestedRecipes.length,
              itemBuilder: (context, index) {
                final recipe = _suggestedRecipes[index];
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
                          backgroundImage: NetworkImage(recipe.imageUrl),
                        ),
                        title: Text(
                          recipe.name,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _tappedState[index]
                                  ? Colors.black
                                  : Colors.white),
                        ),
                        subtitle:
                            Text("Hazırlık Süresi: ${recipe.preparationTime}"),
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

class Recipe {
  final String name;
  final List<String> ingredients;
  final String preparationTime;
  final String imageUrl;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.preparationTime,
    required this.imageUrl,
  });
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
