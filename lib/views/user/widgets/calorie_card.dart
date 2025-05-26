import 'package:flutter/material.dart';

class CalorieCard extends StatelessWidget {
  final int currentGoal;
  final Function(int) onUpdate;

  const CalorieCard({
    Key? key,
    required this.currentGoal,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.scale,
                  color: Colors.orange[600],
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Günlük Kalori Hedefi',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$currentGoal kcal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => _setCalorieGoal(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Kalori Ayarla'),
            ),
          ],
        ),
      ),
    );
  }

  void _setCalorieGoal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController calorieController =
            TextEditingController(text: currentGoal.toString());

        return AlertDialog(
          title: Text('Kalori Hedefi Ayarla'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: calorieController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Günlük Kalori Hedefi (kcal)',
                  border: OutlineInputBorder(),
                  helperText: 'Önerilen aralık: 1200-3000 kcal',
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kalori İhtiyacı Rehberi:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('• Kadın (18-30 yaş): 1800-2000 kcal',
                        style: TextStyle(fontSize: 12)),
                    Text('• Erkek (18-30 yaş): 2200-2400 kcal',
                        style: TextStyle(fontSize: 12)),
                    Text('• Aktif yaşam: +200-400 kcal',
                        style: TextStyle(fontSize: 12)),
                    Text('• Kilo verme: -300-500 kcal',
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                int? newGoal = int.tryParse(calorieController.text);
                if (newGoal != null && newGoal >= 1000 && newGoal <= 5000) {
                  onUpdate(newGoal);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Kalori hedefi güncellendi: $newGoal kcal')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Lütfen 1000-5000 arasında geçerli bir değer girin!')),
                  );
                }
              },
              child: Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }
}
