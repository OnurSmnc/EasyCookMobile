import 'package:flutter/material.dart';

class PasswordCard extends StatelessWidget {
  const PasswordCard({Key? key}) : super(key: key);

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
                Icon(Icons.lock, color: Colors.orange[600]),
                SizedBox(width: 12),
                Text(
                  'Şifre Değiştir',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => _changePassword(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Değiştir'),
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController currentPasswordController =
            TextEditingController();
        TextEditingController newPasswordController = TextEditingController();
        TextEditingController confirmPasswordController =
            TextEditingController();
        bool showCurrentPassword = false;
        bool showNewPassword = false;
        bool showConfirmPassword = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Şifre Değiştir'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentPasswordController,
                    obscureText: !showCurrentPassword,
                    decoration: InputDecoration(
                      labelText: 'Mevcut Şifre',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showCurrentPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            showCurrentPassword = !showCurrentPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: newPasswordController,
                    obscureText: !showNewPassword,
                    decoration: InputDecoration(
                      labelText: 'Yeni Şifre',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showNewPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            showNewPassword = !showNewPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: !showConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Yeni Şifre Tekrar',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            showConfirmPassword = !showConfirmPassword;
                          });
                        },
                      ),
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
                    if (currentPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Mevcut şifrenizi girin!')),
                      );
                      return;
                    }

                    if (newPasswordController.text.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Yeni şifre en az 6 karakter olmalı!')),
                      );
                      return;
                    }

                    if (newPasswordController.text ==
                        confirmPasswordController.text) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Şifre başarıyla değiştirildi!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Şifreler eşleşmiyor!')),
                      );
                    }
                  },
                  child: Text('Değiştir'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
