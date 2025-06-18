import 'dart:math';

import 'package:easycook/core/data/models/register/register_request.dart';
import 'package:easycook/core/data/models/register/register_response.dart';
import 'package:easycook/core/data/repositories/auth_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:easycook/views/auth/calorie.dart';
import 'package:easycook/views/auth/login.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final apiService =
      ApiService(baseUrl: ApiConstats.baseUrl); // Örnek API URL'si
  late final AuthRepository authRepository = AuthRepository();

  void register() async {
    if (_formKey.currentState!.validate()) {
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Şifreler eşleşmiyor!")),
        );
        return;
      }

      final fullName = "$firstName $lastName";
      final RegisterResponse registerResponse;

      try {
        final registerRequest = RegisterRequest(
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          firstName: firstName,
          lastName: lastName,
          fullName: fullName,
        );
        registerResponse = await authRepository.register(registerRequest);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text("Kayıt başarısız: $e",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              )),
        );
        return;
      }

      // Kayıt sonrası giriş ekranına yönlendirme
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Kayıt başarılı!",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          duration: Duration(seconds: 3),
        ),
      );
      // Navigator.pop(context); // Giriş sayfasına dön
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => KaloriHedefPage(
                  userId: registerResponse.userId,
                  email: email,
                  password: password,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kayıt Ol")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: "Ad"),
                validator: (value) =>
                    value!.isEmpty ? "Ad boş bırakılamaz" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: "Soyad"),
                validator: (value) =>
                    value!.isEmpty ? "Soyad boş bırakılamaz" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "E-posta"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? "E-posta giriniz" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Şifre"),
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? "Şifre en az 6 karakter olmalı" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(labelText: "Şifre (Tekrar)"),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? "Şifreyi tekrar giriniz" : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButtonWidget(
                  onPressed: register,
                  icon: Icon(Icons.app_registration, color: Colors.white),
                  title: "Kayıt Ol",
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  ); // Giriş sayfasına dön
                },
                child: const Text(
                  "Zaten bir hesabın var mı? Giriş Yap",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
