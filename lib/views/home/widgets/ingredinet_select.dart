import 'package:easycook/core/data/models/ingredient/ingredient_request.dart';
import 'package:easycook/core/data/repositories/ingredient_repository.dart';
import 'package:easycook/views/user/widgets/custom_chip.dart';
import 'package:easycook/views/user/widgets/ingredient_selector.dart';
import 'package:flutter/material.dart';

class IngredientCard extends StatefulWidget {
  final void Function(List<IngredientData>) onSelectionChanged;

  const IngredientCard({super.key, required this.onSelectionChanged});
  @override
  State<IngredientCard> createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {
  late final IngredientRepository ingredientRepository;

  List<IngredientData> allIngredients = [];
  List<IngredientData> selectedIngredients = [];
  List<IngredientData> availableIngredients = [];

  @override
  void initState() {
    super.initState();
    ingredientRepository = IngredientRepository();
    getIngredients();
  }

  void getIngredients() async {
    try {
      final fetchedIngredients = await ingredientRepository.getAllIngredients();

      setState(() {
        allIngredients = fetchedIngredients;
        availableIngredients = List.from(allIngredients);
      });

      print("Fetched ingredients:");
      allIngredients.forEach((i) => print("id: ${i.id}, name: ${i.name}"));
    } catch (e) {
      print('Error fetching ingredients: $e');
    }
  }

  void onIngredientSelected(IngredientData ingredient) {
    if (!selectedIngredients.any((i) => i.id == ingredient.id)) {
      setState(() {
        selectedIngredients.add(ingredient);
        _updateAvailableIngredients();
        widget.onSelectionChanged(selectedIngredients);
      });
    }
  }

  void onIngredientDeselected(IngredientData ingredient) {
    setState(() {
      selectedIngredients.removeWhere((i) => i.id == ingredient.id);
      _updateAvailableIngredients();
      widget.onSelectionChanged(selectedIngredients);
    });
  }

  void _updateAvailableIngredients() {
    final selectedIds = selectedIngredients.map((e) => e.id).toSet();
    setState(() {
      availableIngredients =
          allIngredients.where((i) => !selectedIds.contains(i.id)).toList();
      print("--- Updating available ingredients ---");
      print("Selected IDs: $selectedIds");
      print("Available Ingredients AFTER UPDATE:");
    });
  }

  void _manageAllergies(BuildContext context) {
    IngredientSelectorDialog.show(
      context: context,
      title: 'Malzeme Ekle',
      subtitle: 'Malzemeleri seçin',
      currentList: selectedIngredients,
      availableIngredients: availableIngredients,
      onAdd: (ingredient) {
        if (ingredient != null) {
          onIngredientSelected(ingredient);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lütfen bir malzeme seçin.')),
          );
        }
      },
      colorSelection: Colors.orange[100]!,
    );
  }

  void _removeIngredient(BuildContext context, IngredientData ingredient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Malzeme Çıkar'),
          content: Text(
              '${ingredient.name} malzemesini çıkarmak istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                onIngredientDeselected(ingredient);
                Navigator.pop(context);
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
                          '${ingredient.name} çıkarıldı!',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.red[600],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600]),
              child: Text('Çıkar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.food_bank, color: Colors.orange[700], size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Seçilen Malzemeler',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _manageAllergies(context),
                  icon: Icon(Icons.add, color: Colors.orange[600]),
                  tooltip: 'Malzeme Seç',
                ),
              ],
            ),
            SizedBox(height: 12),
            if (selectedIngredients.isEmpty)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Henüz malzeme belirtmediniz. Yemek tarifi almak için malzeme seçiniz.',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${selectedIngredients.length} malzeme seçildi:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedIngredients
                        .map((ingredient) => CustomChip(
                              label: ingredient.name ?? "",
                              backgroundColor: Colors.orange[100]!,
                              textColor: Colors.orange[700]!,
                              onDelete: () =>
                                  _removeIngredient(context, ingredient),
                            ))
                        .toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
