import 'package:easycook/core/data/models/viewedHistory.dart';
import 'package:easycook/core/data/repositories/viewedHistory_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:easycook/views/history/used_images.dart';
import 'package:easycook/views/history/viewed_recipes.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<ViewedRecipeHistoryItem> _viewedRecipeHistory = [];

  List<bool> _tappedState = [];

  @override
  void initState() {
    super.initState();
    _fetchViewedHistory();
  }

  Future<void> _fetchViewedHistory() async {
    final repo =
        ViewedHistoryRepository(ApiService(baseUrl: ApiConstats.baseUrl));
    final history = await repo.getAllViewedHistory();

    setState(() {
      _viewedRecipeHistory = history;
      _tappedState = List.generate(
        _viewedRecipeHistory.length ?? 0,
        (index) => false,
      );
    });
  }

  void _onRecipeTapped(int index) {
    setState(() {
      _tappedState[index] = !_tappedState[index]; // Toggle the tapped state
    });
  }

  int _selectedIndex =
      -1; // -1: hiçbiri seçili değil, 0: ilk buton, 1: ikinci buton

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
            Row(
              children: [
                // İlk buton
                Expanded(
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
                Divider(
                  color: Colors.orange,
                ),
                // İkinci buton
                Expanded(
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
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            Expanded(
              child: _selectedIndex == 0
                  ? ViewedRecipes(
                      selectedIndex: _selectedIndex,
                      suggestedRecipes: _viewedRecipeHistory,
                    )
                  : const UsedImages(),
            ),
          ],
        ),
      ),
    );
  }
}
