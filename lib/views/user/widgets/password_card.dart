import 'package:easycook/core/data/models/user/password/password_request.dart';
import 'package:easycook/core/data/repositories/user_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_exception.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:flutter/material.dart';

class PasswordCard extends StatefulWidget {
  const PasswordCard({Key? key}) : super(key: key);

  @override
  State<PasswordCard> createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard> {
  final apiService = ApiService(baseUrl: ApiConstats.baseUrl);
  late final userRepository = UserRepository();

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
                  onPressed: () async {
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

                    try {
                      // Call the userRepository to change the password
                      await userRepository.changePassword(
                        PasswordRequest(
                          activePassword: currentPasswordController.text,
                          newPassword: newPasswordController.text,
                          confirmPassword: confirmPasswordController.text,
                        ),
                      );

                      // If successful, close the dialog and show success message
                      if (mounted) {
                        // Check if the widget is still mounted before interacting with context
                        Navigator.pop(context);
                        SnackBar(
                            content: Text('Şifre başarıyla değiştirildi!'));
                      }
                    } on ApiException catch (e) {
                      if (mounted) {
                        SnackBar(content: Text('Hata: ${e.message}'));
                      }
                    } catch (e) {
                      if (mounted) {
                        SnackBar(content: Text('Bilinmeyen bir hata oluştu'));
                      }
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
