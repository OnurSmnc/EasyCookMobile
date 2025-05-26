import 'package:easycook/core/data/models/user_profile/user_profile_model.dart';
import 'package:easycook/views/user/widgets/ingredient_selector.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_chip.dart';

class AllergiesCard extends StatelessWidget {
  final List<String> allergies;
  final Function(String) onAdd;
  final Function(String) onRemove;

  const AllergiesCard({
    Key? key,
    required this.allergies,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

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
                              label: allergy,
                              backgroundColor: Colors.red[100]!,
                              textColor: Colors.red[700]!,
                              onDelete: () => _removeAllergy(context, allergy),
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

  void _manageAllergies(BuildContext context) {
    IngredientSelectorDialog.show(
      context: context,
      title: 'Alerji Ekle',
      subtitle: 'Alerjik olduğunuz malzemeleri seçin',
      currentList: allergies,
      availableIngredients: UserProfileModel.availableIngredients,
      onAdd: (ingredient) {
        onAdd(ingredient);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$ingredient alerjilerinize eklendi!'),
            backgroundColor: Colors.red[600],
          ),
        );
      },
    );
  }

  void _removeAllergy(BuildContext context, String allergy) {
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
}
