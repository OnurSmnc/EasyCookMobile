import 'package:easycook/core/data/models/login/login_request.dart';
import 'package:easycook/core/data/models/refreshToken/refreshToken_request.dart';
import 'package:easycook/core/data/repositories/auth_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_exception.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/core/utils/bottomNavigationBar.dart';
import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:easycook/views/auth/register.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final apiService = ApiService(baseUrl: ApiConstats.baseUrl);
  late final authRepository = AuthRepository();

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Giriş işlemi burada yapılır (API çağrısı veya Firebase)
    print("Email: $email, Password: $password");

    try {
      final loginResponse = await authRepository
          .login(LoginRequest(email: email, password: password));

      print("Login successful: ${loginResponse.token}");

      // refresh token'ı kullanarak access token yeniless
      final refreshResponse = await authRepository.refreshToken(
        RefreshTokenRequest(
          accessToken: loginResponse.token,
          refreshToken: loginResponse.refreshToken,
        ),
      );

      // refresh'ten dönen refreshToken'ı Authorization header olarak ayarla
      apiService.updateAuthorizationHeader(refreshResponse.accessToken);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationWrapper()),
      );
    } on ApiException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bilinmeyen bir hata oluştu')),
      );
    }

    // Doğrulama sonrası başka sayfaya yönlendirme yapılabilir
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.restaurant_menu,
                  size: 80, color: Colors.orangeAccent),
              const SizedBox(height: 20),
              const Text(
                "Easy Cook",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "E-posta",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Şifre",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButtonWidget(
                    onPressed: login,
                    icon: Icon(Icons.login, color: Colors.white),
                    title: "Giriş Yap",
                  )),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Kayıt sayfasına yönlendirme
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text(
                  "Hesabınız yok mu? Kayıt olun",
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
