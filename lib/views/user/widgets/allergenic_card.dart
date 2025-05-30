import 'dart:ffi';

import 'package:easycook/core/data/models/allergenics/allergenic_request.dart';
import 'package:easycook/core/data/models/allergenics/allergenic_response.dart';
import 'package:easycook/core/data/models/ingredient/ingredient_request.dart';
import 'package:easycook/core/data/models/user_profile/user_profile_model.dart';
import 'package:easycook/core/data/repositories/ingredient_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/views/user/widgets/ingredient_selector.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_chip.dart';

class AllergiesCard extends StatefulWidget {
  const AllergiesCard({super.key});
  @override
  State<AllergiesCard> createState() => _AllergiesCardState();
}

class _AllergiesCardState extends State<AllergiesCard> {
  final ApiService _apiService = ApiService(baseUrl: ApiConstats.baseUrl);
  late final IngredientRepository ingredientRepository;

  List<IngredientData>? availableIngredients;
  List<AllergenicResponse> allergies = [];

  @override
  void initState() {
    super.initState();
    ingredientRepository = IngredientRepository();

    // getIngredients();
    _fetchAllergies();
  }

  void getIngredients() async {
    try {
      final List<IngredientData> fetchedIngredients =
          await ingredientRepository.getAllIngredients();

      final allergyIds = allergies.map((a) => a.ingredients.id).toSet();
      setState(() {
        availableIngredients = fetchedIngredients
            .where((ingredient) => !allergyIds.contains(ingredient.id))
            .toList();
      });
    } catch (e) {
      // Handle error, e.g., show a snackbar or log the error
      print('Error fetching ingredients: $e');
    }
    // This method can be used to fetch available ingredients if needed
  }

  Future<void> _fetchAllergies() async {
    try {
      final response = await _apiService.get(ApiConstats.getAllergies);
      // response bir List<dynamic> ise:
      final List<AllergenicResponse> fetchedAllergies = (response as List)
          .map((e) => AllergenicResponse.fromJson(e))
          .toList();
      setState(() {
        allergies = fetchedAllergies;
      });
      getIngredients();
    } catch (e) {
      print('Error fetching allergies: $e');
    }
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
                    Icon(Icons.warning, color: Colors.red[700], size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Alerjilerim',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _manageAllergies(context),
                  icon: Icon(Icons.add, color: Colors.red[600]),
                  tooltip: 'Alerji Ekle',
                ),
              ],
            ),
            SizedBox(height: 12),
            if (allergies.isEmpty)
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
                        'Henüz alerji belirtmediniz. Güvenli yemek önerileri için alerjilerinizi ekleyin.',
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
                    '${allergies.length} alerji kaydedildi:',
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
                    children: allergies
                        .map((allergy) => CustomChip(
                              label: allergy.ingredients
                                  .name, // Use the appropriate property for String
                              backgroundColor: Colors.red[100]!,
                              textColor: Colors.red[700]!,
                              onDelete: () => _removeAllergy(
                                  context, allergy.ingredients.id),
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

  void _manageAllergies(BuildContext context) async {
    IngredientSelectorDialog.show(
      context: context,
      title: 'Alerji Ekle',
      subtitle: 'Alerjik olduğunuz malzemeleri seçin',
      currentList: allergies.map((a) => a.ingredients).toList(),
      availableIngredients: availableIngredients ?? [],
      onAdd: (ingredient) async {
        if (ingredient != null) {
          _addAllergy(ingredient); // Sadece bu satır!
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lütfen bir malzeme seçin.'),
            ),
          );
        }
      },
    );
  }

  void _addAllergy(IngredientData ingredient) async {
    try {
      var response = await _apiService.post(
        ApiConstats.addAllergy,
        AllergyRequest(ingredientId: [ingredient.id]),
      );

      if (response.statusCode == 200) {
        setState(() {
          allergies.add(AllergenicResponse(
            id: response.data['id'],
            userId: response
                .data['userId'], // Assuming the response contains the new ID
            ingredients: ingredient,
            ingredientsId: ingredient.id,
          ));
        });
        // Yeni alerjiyi listeye ekle

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
                Icon(Icons.check_circle, color: Colors.white),
                Text(
                  'Alerji eklendi!',
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
            content: Text('Alerji eklenemedi!'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    } catch (e) {
      print('Error adding allergy: $e');
    }
  }

  void _removeAllergy(BuildContext context, int allergy) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alerji Çıkar'),
          content: Text(
              '$allergy\'yi alerjilerinizden çıkarmak istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                onRemove(allergy);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$allergy alerjilerden çıkarıldı!')),
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

  void onRemove(int allergyId) {
    setState(() {
      allergies.removeWhere((allergy) => allergy.ingredients.id == allergyId);
    });
    // Optionally, call your API to remove the allergy from the backend here.
  }
}
