import 'package:easycook/core/data/models/user_profile/user_profile_model.dart';
import 'package:easycook/core/data/repositories/user_repository.dart';
import 'package:easycook/views/user/widgets/allergenic_card.dart';
import 'package:easycook/views/user/widgets/calorie_card.dart';
import 'package:easycook/views/user/widgets/dislike_card.dart';
import 'package:easycook/views/user/widgets/password_card.dart';
import 'package:easycook/views/user/widgets/profile_card.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late UserProfileModel userProfile;
  late final UserRepository userRepository;
  late int _calorieGoal;
  @override
  void initState() {
    super.initState();
    userProfile = UserProfileModel(
      fullName: "Ahmet Yılmaz",
      email: "ahmet.yilmaz@email.com",
      allergicTo: ["Fındık", "Çilek", "Balık"],
      dislikes: ["Brokoli", "Patlıcan", "İstiridye"],
      dailyCalorieGoal: 2000,
    );
    userRepository = UserRepository();
    _fetchUserCalorieGoal();
  }

  void _fetchUserCalorieGoal() async {
    try {
      var response = await userRepository.getCalorie();
      if (response.Message == "Success") {
        _calorieGoal = response.Calorie as int;
        setState(() {
          userProfile.dailyCalorieGoal = _calorieGoal;
        });
      } else {
        throw Exception('Kalori hedefi alınamadı: ${response.Message}');
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileInfoCard(),
            SizedBox(height: 20),
            PasswordCard(),
            SizedBox(height: 20),
            CalorieCard(
              currentGoal: userProfile.dailyCalorieGoal,
              userRepository: userRepository,
              onUpdate: (newGoal) {
                setState(() {
                  userProfile.dailyCalorieGoal = newGoal;
                });
              },
            ),
            SizedBox(height: 20),
            AllergiesCard(),
            SizedBox(height: 20),
            // DislikesCard(
            //   dislikes: userProfile.dislikes.,
            //   onAdd: (dislike) {
            //     setState(() {
            //       if (!userProfile.dislikes.contains(dislike)) {
            //         userProfile.dislikes.add(dislike);
            //       }
            //     });
            //   },
            //   onRemove: (dislike) {
            //     setState(() {
            //       userProfile.dislikes.remove(dislike);
            //     });
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
