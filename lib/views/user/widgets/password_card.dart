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
  final apiService =
      ApiService(baseUrl: ApiConstats.baseUrl); // Typo düzeltildi
  late final userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // const eklendi
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.lock, color: Colors.orange[600]),
                const SizedBox(width: 12), // const eklendi
                const Text(
                  // const eklendi
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
              child: const Text('Değiştir'), // const eklendi
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Context ismi değiştirildi
        return const PasswordChangeDialog();
      },
    );
  }
}

class PasswordChangeDialog extends StatefulWidget {
  const PasswordChangeDialog({Key? key}) : super(key: key);

  @override
  State<PasswordChangeDialog> createState() => _PasswordChangeDialogState();
}

class _PasswordChangeDialogState extends State<PasswordChangeDialog> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final UserRepository _userRepository = UserRepository();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _clearErrors() {
    setState(() {
      _currentPasswordError = null;
      _newPasswordError = null;
      _confirmPasswordError = null;
    });
  }

  bool _validateInputs() {
    _clearErrors();
    bool isValid = true;

    // Mevcut şifre kontrolü
    if (_currentPasswordController.text.isEmpty) {
      setState(() {
        _currentPasswordError = 'Mevcut şifre boş olamaz!';
      });
      isValid = false;
    }

    // Yeni şifre kontrolü
    if (_newPasswordController.text.isEmpty) {
      setState(() {
        _newPasswordError = 'Yeni şifre boş olamaz!';
      });
      isValid = false;
    } else if (_newPasswordController.text.length < 6) {
      setState(() {
        _newPasswordError = 'Yeni şifre en az 6 karakter olmalı!';
      });
      isValid = false;
    } else if (_newPasswordController.text[0] !=
        _newPasswordController.text[0].toUpperCase()) {
      setState(() {
        _newPasswordError = 'Şifre büyük harf ile başlamalı!';
      });
      isValid = false;
    }

    // Şifre tekrar kontrolü
    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Şifre tekrarı boş olamaz!';
      });
      isValid = false;
    } else if (_confirmPasswordController.text != _newPasswordController.text) {
      setState(() {
        _confirmPasswordError = 'Şifreler eşleşmiyor!';
      });
      isValid = false;
    }

    return isValid;
  }

  Future<void> _changePassword() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _userRepository.changePassword(
        PasswordRequest(
          activePassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
          confirmPassword: _confirmPasswordController.text,
        ),
      );

      if (!mounted) return;

      // Başarılı durumda - boş string kontrolü de eklendi
      if ((response.confirmPasswordError == null ||
              response.confirmPasswordError!.isEmpty) &&
          (response.currentPasswordError == null ||
              response.currentPasswordError!.isEmpty)) {
        // Önce loading'i durdur
        setState(() {
          _isLoading = false;
        });

        // Popup'ı kapat
        if (mounted) {
          Navigator.of(context).pop();

          // Başarı mesajını göster
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Şifre başarıyla değiştirildi!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        return;
      } else {
        // API'den gelen hatalar
        setState(() {
          _confirmPasswordError = response.confirmPasswordError;
          _currentPasswordError = response.currentPasswordError;
          _isLoading = false;
        });
      }
    } on ApiException catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bilinmeyen bir hata oluştu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          enabled: !_isLoading,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.black),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange)),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),
            errorText: errorText,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: _isLoading ? null : onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Şifre Değiştir'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPasswordField(
              controller: _currentPasswordController,
              labelText: 'Mevcut Şifre',
              obscureText: !_showCurrentPassword,
              onToggleVisibility: () {
                setState(() {
                  _showCurrentPassword = !_showCurrentPassword;
                });
              },
              errorText: _currentPasswordError,
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              controller: _newPasswordController,
              labelText: 'Yeni Şifre',
              obscureText: !_showNewPassword,
              onToggleVisibility: () {
                setState(() {
                  _showNewPassword = !_showNewPassword;
                });
              },
              errorText: _newPasswordError,
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              controller: _confirmPasswordController,
              labelText: 'Yeni Şifre Tekrar',
              obscureText: !_showConfirmPassword,
              onToggleVisibility: () {
                setState(() {
                  _showConfirmPassword = !_showConfirmPassword;
                });
              },
              errorText: _confirmPasswordError,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text(
            'İptal',
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[600], // Arka plan rengi
            foregroundColor: Colors.white, // Yazı rengi
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _isLoading ? null : _changePassword,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Değiştir'),
        ),
      ],
    );
  }
}
