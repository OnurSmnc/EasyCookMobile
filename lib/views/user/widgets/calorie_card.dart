import 'package:easycook/core/data/models/user/calorie/calorie_request.dart';
import 'package:easycook/core/data/repositories/user_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalorieCard extends StatelessWidget {
  final int currentGoal;
  final Function(int) onUpdate;

  final ApiService _apiService = ApiService(baseUrl: ApiConstats.baseUrl);
  final UserRepository userRepository;

  CalorieCard({
    Key? key,
    required this.currentGoal,
    required this.onUpdate,
    required this.userRepository,
  }) : super(key: key);

  @override
  void initState() {
    _fetchUserCalorieGoal();
  }

  void _fetchUserCalorieGoal() async {
    try {
      var response = await userRepository.getCalorie();
      if (response.Message == "Success") {
        onUpdate(response.Calorie as int);
      } else {
        throw Exception('Kalori hedefi alınamadı: ${response.Message}');
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

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

  void updateGoal(BuildContext context, int newGoal) async {
    try {
      if (newGoal >= 1000 && newGoal <= 5000) {
        var response = await userRepository.calorieUpdate(
          CalorieUpdateRequest(CalorieCount: newGoal),
        );

        if (response.Message == "Success") {
          onUpdate(newGoal);
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
                  Icon(Icons.check, color: Colors.white),
                  Text(
                    'Kalori hedefiniz ${newGoal} olarak güncellendi!',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception('Kalori hedefi güncellenemedi: ${response.Message}');
        }
      } else {
        throw ArgumentError('Kalori hedefi 1000-5000 arasında olmalıdır.');
      }
    } catch (e) {
      print('Hata: $e');
    }
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
            ElevatedButtonWidget(
              title: 'Kaydet',
              icon: Icon(Icons.save, color: Colors.white),
              onPressed: () {
                int? newGoal = int.tryParse(calorieController.text);
                updateGoal(context, newGoal as int? ?? currentGoal);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
