import 'package:easycook/core/data/models/favorite.dart';
import 'package:easycook/core/data/models/recipes/recipeAdd/RecipeAddRequest.dart';
import 'package:easycook/core/data/repositories/favorite_repository.dart';
import 'package:easycook/core/data/repositories/recipe_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/views/comment/screens/commentPage.dart';
import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easycook/core/data/models/recipes.dart';

class HomeRecipePage extends StatefulWidget {
  final Recipes recipe;
  final int viewedRecipeId;
  final int? favoriteRecipeId;
  final FavoriteRepository? favoriteRepository;

  const HomeRecipePage({
    Key? key,
    required this.recipe,
    required this.viewedRecipeId,
    this.favoriteRecipeId,
    this.favoriteRepository,
  }) : super(key: key);

  @override
  State<HomeRecipePage> createState() => _HomeRecipePageState();
}

class _HomeRecipePageState extends State<HomeRecipePage> {
  List<Favorite> _favoriteRecipes = [];
  int? _favoriteId;
  late final RecipeRepository _recipeRepository;

  late final favoriteRepo;
  @override
  void initState() {
    super.initState();
    favoriteRepo = widget.favoriteRepository ?? FavoriteRepository();
    _recipeRepository = RecipeRepository();
    _fetchFavorite();
  }

  Future<void> _fetchFavorite() async {
    _favoriteRecipes = await favoriteRepo.getFavorites();
    if (!mounted) return;
    setState(() {
      try {
        final match = _favoriteRecipes.firstWhere(
          (fav) => fav.recipeId == widget.recipe.id,
        );
        _favoriteId = match.id;
      } catch (e) {
        _favoriteId = null;
      }
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'URL açılamıyor: $url';
    }
  }

  Future<void> _madeRecipe(
      BuildContext context, RecipeAddRequest request) async {
    try {
      final response = await _recipeRepository.madeRecipe(request);
      if (response.message == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(12),
            elevation: 4,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.verified, color: Colors.white),
                Text(
                  'Yapılan tariflere eklendi!',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(12),
            elevation: 4,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.warning, color: Colors.white),
                Text(
                  'Günlük kalori hedefini aşıyor!',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            backgroundColor: Colors.yellow[800],
          ),
        );
      }
    } catch (e) {
      print("Hata oluştu: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    }
  }

  void toggleFavorite(BuildContext context) async {
    if (_favoriteId != null) {
      var response = await favoriteRepo.removeFavorite(
        RemoveFavoriteRequset(favoriteId: _favoriteId!),
      );
      if (response != null && response.message == "Success") {
        setState(() {
          _favoriteId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(12),
            elevation: 4,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.remove_circle, color: Colors.white),
                Text(
                  'Favorilerden çıkarıldı!',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    } else {
      var response = await favoriteRepo?.addFavoriteRecipe(
          widget.viewedRecipeId, widget.recipe.id);
      if (response != null && response.message == "Success") {
        setState(() {
          _favoriteId = response.favoriteId; // Bunu response'a göre uyarlayın
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(12),
            elevation: 4,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.favorite, color: Colors.white),
                Text(
                  'Favorilere eklendi!',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            backgroundColor: Colors.green[600],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = (widget.recipe.ingredients).split(',');

    final List<String> recipeFood = (widget.recipe.recipeFood)
        .split('.')
        .where((step) => step.trim().isNotEmpty)
        .map((step) => step.trim())
        .toList();

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
            Container(
              height: 200,
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              child: (widget.recipe.image != null &&
                      widget.recipe.image!.isNotEmpty)
                  ? Image.network(
                      widget.recipe.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Text('Resim yüklenemedi'),
                      ),
                    )
                  : const Center(child: Text('Resim yok')),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                widget.recipe.title,
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
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black, width: 1),
                color: Colors.orange[100],
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hazırlık Süresi: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800], // Yazının rengi
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: widget.recipe.preparationTime != null
                          ? '${widget.recipe.preparationTime.toString()} dk'
                          : 'Bilinmiyor',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButtonWidget(
                    onPressed: () async {
                      await _madeRecipe(
                          context,
                          RecipeAddRequest(
                              recipeId: widget.recipe.id,
                              viewedRecipeId: widget.viewedRecipeId));
                    },
                    title: 'Yap',
                    icon: Icon(Icons.food_bank)),
                if (widget.recipe.url.isNotEmpty)
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange[200],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(color: Colors.black, width: 1.0),
                      ),
                    ),
                    onPressed: () => _launchURL(widget.recipe.url),
                    child: const Text("Tarif Kaynağına Git"),
                  ),
              ],
            )
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  toggleFavorite(context);
                },
                icon: _favoriteId != null
                    ? const Icon(Icons.favorite, color: Colors.red, size: 28)
                    : const Icon(Icons.favorite_border, size: 28),
                tooltip: _favoriteId != null
                    ? "Favorilerden Kaldır"
                    : "Favorilere Ekle",
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => CommentsModalPopup(
                      comments: [], // Gerçek yorumları burada ver
                      recipeId: widget.recipe.id,
                      recipeTitle: widget.recipe.title,
                      viewedRecipesId: widget.viewedRecipeId,
                      parentContext: context,
                    ),
                  );
                },
                icon: const Icon(Icons.comment_outlined, size: 28),
                tooltip: "Yorum Yap",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
