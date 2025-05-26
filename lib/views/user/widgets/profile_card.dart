import 'package:easycook/core/data/models/user_profile/user_profile_model.dart';
import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final UserProfileModel userProfile;
  final Function(String, String) onUpdate;

  const ProfileInfoCard({
    Key? key,
    required this.userProfile,
    required this.onUpdate,
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
            _buildInfoRow(Icons.person, 'Ad Soyad', userProfile.fullName),
            SizedBox(height: 12),
            _buildInfoRow(Icons.email, 'E-posta', userProfile.email),
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
            TextEditingController(text: userProfile.fullName);
        TextEditingController emailController =
            TextEditingController(text: userProfile.email);

        return AlertDialog(
          title: Text('Bilgileri Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Ad Soyad',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
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
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty) {
                  onUpdate(nameController.text, emailController.text);
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
}
