import 'package:easycook/core/data/models/recipes/recipeAdd/get_recipe_made_response.dart';
import 'package:easycook/core/data/models/viewedHistory.dart';
import 'package:easycook/core/data/repositories/recipe_repository.dart';
import 'package:easycook/core/data/repositories/viewedHistory_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:easycook/views/history/used_images.dart';
import 'package:easycook/views/history/viewed_recipes.dart';
import 'package:easycook/views/history/yapılan_tarifler.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<ViewedRecipeHistoryItem> _viewedRecipeHistory = [];
  List<RecipeMadedGetResponse> _madedRecipesList = [];
  List<bool> _tappedState = [];

  late final RecipeRepository _recipeRepository;
  int _selectedIndex = -1; // -1: hiçbiri seçili değil

  @override
  void initState() {
    super.initState();
    _recipeRepository = RecipeRepository();
    _fetchViewedHistory();
  }

  Future<void> _fetchViewedHistory() async {
    final repo =
        ViewedHistoryRepository(ApiService(baseUrl: ApiConstats.baseUrl));
    final history = await repo.getAllViewedHistory();

    setState(() {
      _viewedRecipeHistory = history;
      _tappedState =
          List.generate(_viewedRecipeHistory.length, (index) => false);
    });
  }

  Future<void> _fetchMadedRecipes() async {
    try {
      final responseMadedRecipe = await _recipeRepository.getMadedRecipeAsync();
      if (responseMadedRecipe != null) {
        setState(() {
          _madedRecipesList.clear();
          _madedRecipesList.addAll(responseMadedRecipe);
        });
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  void _onRecipeTapped(int index) {
    setState(() {
      _tappedState[index] = !_tappedState[index];
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // 🔽 Kaydırılabilir butonlar
            SizedBox(
              height: 75,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 0
                            ? Colors.yellow
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButtonWidget(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                        title: "Görüntülenen Tarifler",
                        icon: const Icon(Icons.history),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 1
                            ? Colors.yellow
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButtonWidget(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        title: "Kullanılan Resimler",
                        icon: const Icon(Icons.photo),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 2
                            ? Colors.yellow
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButtonWidget(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 2;
                            _fetchMadedRecipes();
                          });
                        },
                        title: "Yapılan Tarifler",
                        icon: const Icon(Icons.photo),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.black),
            // 🔽 Sayfa içeriği
            Expanded(
              child: () {
                switch (_selectedIndex) {
                  case 0:
                    return ViewedRecipes(
                      selectedIndex: _selectedIndex,
                      suggestedRecipes: _viewedRecipeHistory,
                    );
                  case 1:
                    return const UsedImages();
                  case 2:
                    return MadedRecipes(
                      selectedIndex: _selectedIndex,
                      recipeMadedList: _madedRecipesList,
                    );
                  default:
                    return const SizedBox(); // boş ekran
                }
              }(),
            ),
          ],
        ),
      ),
    );
  }
}
