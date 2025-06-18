import 'package:easycook/core/data/models/user/userInfo/get_user_info.dart';
import 'package:easycook/core/data/models/user/userInfo/update_userInfo_request.dart';
import 'package:easycook/core/data/models/user_profile/user_profile_model.dart';
import 'package:easycook/core/data/repositories/user_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:flutter/material.dart';

class ProfileInfoCard extends StatefulWidget {
  const ProfileInfoCard({Key? key}) : super(key: key);

  @override
  State<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends State<ProfileInfoCard> {
  final ApiService _apiService = ApiService(baseUrl: ApiConstats.baseUrl);
  late final UserRepository userRepository;

  UserInfo? userProfile;
  @override
  void initState() {
    super.initState();
    userRepository = UserRepository(); // Pass the initialized ApiService

    getUserProfile();
  }

  void getUserProfile() async {
    try {
      UserInfo userProfileFetched = await userRepository.getUserInfo();
      setState(() {
        userProfile = userProfileFetched;
      });
    } catch (e) {
      // Print the error for debugging purposes.
      print('Error fetching user profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load user profile.')),
        );
      }
    }
  }

  void updateUserProfile(UpdateUserInfo updatedProfile) async {
    try {
      await userRepository.updateUserProfile(updatedProfile);
      setState(() {
        userProfile = UserInfo(
          UserId: userProfile?.UserId ?? '',
          UserName: updatedProfile.FirstName ?? '',
          Email: updatedProfile.Email ?? '',
          fullName: ((updatedProfile.FirstName ?? '') +
                  ' ' +
                  (updatedProfile.lastName ?? ''))
              .trim(),
          lastName: updatedProfile.lastName ?? '',
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil güncellendi!')),
      );
    } catch (e) {
      print('Error updating user profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil güncelleme başarısız.')),
      );
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
                Text(
                  'Kişisel Bilgiler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                IconButton(
                  onPressed: () => _editProfileInfo(context),
                  icon: Icon(Icons.edit, color: Colors.green[600]),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoRow(
                Icons.person, 'Ad Soyad', userProfile?.fullName ?? ''),
            SizedBox(height: 12),
            _buildInfoRow(Icons.email, 'E-posta', userProfile?.Email ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _editProfileInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController =
            TextEditingController(text: userProfile?.UserName ?? '');
        TextEditingController surnameController =
            TextEditingController(text: userProfile?.lastName ?? '');
        TextEditingController emailController =
            TextEditingController(text: userProfile?.Email ?? '');

        return AlertDialog(
          title: Text('Bilgileri Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Ad',
                  border: OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: surnameController,
                decoration: InputDecoration(
                  labelText: 'Soyad',
                  border: OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('İptal', style: TextStyle(color: Colors.red[600])),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600], // Buton rengi
                foregroundColor: Colors.white, // Metin rengi
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty) {
                  onUpdate(nameController.text, surnameController.text,
                      emailController.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bilgiler güncellendi!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
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

  void onUpdate(String firstName, String surname, String email) async {
    setState(() {
      updateUserProfile(
        UpdateUserInfo(
          FirstName: firstName,
          lastName: surname,
          Email: email,
        ),
      );
    });
    // Optionally, you can call an API to update the user profile on the backend here.
    // await userRepository.updateUserInfo(fullName, email);
  }
}
