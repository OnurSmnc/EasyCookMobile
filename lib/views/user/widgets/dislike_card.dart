import 'package:easycook/core/data/models/user_profile/user_profile_model.dart';
import 'package:easycook/views/user/widgets/ingredient_selector.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_chip.dart';

class DislikesCard extends StatelessWidget {
  final List<String> dislikes;
  final Function(String) onAdd;
  final Function(String) onRemove;

  const DislikesCard({
    Key? key,
    required this.dislikes,
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
                    Icon(Icons.thumb_down, color: Colors.blue[700], size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Sevmediklerim',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _manageDislikes(context),
                  icon: Icon(Icons.add, color: Colors.blue[600]),
                  tooltip: 'Sevmediğim Malzeme Ekle',
                ),
              ],
            ),
            SizedBox(height: 12),
            if (dislikes.isEmpty)
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
                        'Henüz sevmediğiniz malzeme belirtmediniz. Kişiselleştirilmiş öneriler için tercihlerinizi ekleyin.',
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
                    '${dislikes.length} malzeme sevmiyorsunuz:',
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
                    children: dislikes
                        .map((dislike) => CustomChip(
                              label: dislike,
                              backgroundColor: Colors.blue[100]!,
                              textColor: Colors.blue[700]!,
                              onDelete: () => _removeDislike(context, dislike),
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

  void _manageDislikes(BuildContext context) {
    IngredientSelectorDialog.show(
      context: context,
      title: 'Sevmediğim Malzeme Ekle',
      subtitle: 'Sevmediğiniz malzemeleri seçin',
      currentList: dislikes,
      availableIngredients: UserProfileModel.availableIngredients,
      onAdd: (ingredient) {
        onAdd(ingredient);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$ingredient sevmediklerinize eklendi!'),
            backgroundColor: Colors.blue[600],
          ),
        );
      },
    );
  }

  void _removeDislike(BuildContext context, String dislike) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sevmediğimi Çıkar'),
          content: Text(
              '$dislike\'yi sevmediklerinizden çıkarmak istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                onRemove(dislike);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$dislike sevmediklerden çıkarıldı!')),
                );
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blue[600]),
              child: Text('Çıkar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
