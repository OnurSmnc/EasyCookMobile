import 'package:easycook/core/data/models/login/login_request.dart';
import 'package:easycook/core/data/models/refreshToken/refreshToken_request.dart';
import 'package:easycook/core/data/models/user/calorie/calorie_request.dart';
import 'package:easycook/core/data/repositories/auth_repository.dart';
import 'package:easycook/core/data/repositories/user_repository.dart';
import 'package:easycook/core/service/api_constants.dart';
import 'package:easycook/core/service/api_exception.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/core/utils/bottomNavigationBar.dart';
import 'package:easycook/core/widgets/elevatedButton.dart';
import 'package:flutter/material.dart';

class KaloriHedefPage extends StatefulWidget {
  final String userId;
  final String? email;
  final String? password;

  const KaloriHedefPage(
      {Key? key, required this.userId, this.email, this.password})
      : super(key: key);

  @override
  State<KaloriHedefPage> createState() => _KaloriHedefPageState();
}

class _KaloriHedefPageState extends State<KaloriHedefPage> {
  final _hedefKaloriController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final apiService = ApiService(baseUrl: ApiConstats.baseUrl);
  late final userRepository = UserRepository();
  late final authRepository;

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepository();
  }

  void _hedefKaydet() async {
    if (_formKey.currentState!.validate()) {
      int hedef = int.parse(_hedefKaloriController.text);
      try {
        // Kalori hedefini kaydet
        await userRepository.calorieRegister(
          CalorieRequest(
            userId: widget.userId,
            Calorie: hedef,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kalori hedefi başarıyla kaydedildi')),
        );

        try {
          final loginResponse = await authRepository.login(LoginRequest(
              email: widget.email as String,
              password: widget.password as String));

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
            MaterialPageRoute(
                builder: (context) => const MainNavigationWrapper()),
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

        // Geri dön veya başka sayfaya yönlendir
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Kalori Hedefi Belirle',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Ana form kartı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Icon(
                      Icons.track_changes,
                      color: Colors.orange,
                      size: 80,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Günlük Kalori Hedefinizi Belirleyin',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sağlıklı yaşam için günde almanız gereken kalori miktarını girin',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _hedefKaloriController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        labelText: 'Günlük Kalori Hedefi',
                        labelStyle: const TextStyle(fontSize: 16),
                        hintText: 'Örnek: 2000',
                        prefixIcon: Icon(Icons.local_fire_department,
                            color: Colors.red[400], size: 28),
                        suffixText: 'kcal',
                        suffixStyle: TextStyle(
                            color: Colors.blue[400],
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: Colors.blue[400]!, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen kalori hedefini girin';
                        }
                        int? kalori = int.tryParse(value);
                        if (kalori == null || kalori <= 0) {
                          return 'Geçerli bir kalori miktarı girin';
                        }
                        if (kalori < 1000) {
                          return 'Kalori hedefi çok düşük (min. 1000 kcal)';
                        }
                        if (kalori > 5000) {
                          return 'Kalori hedefi çok yüksek (max. 5000 kcal)';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _hedefKaydet(),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButtonWidget(
                        onPressed: _hedefKaydet,
                        title: 'Hedefi Kaydet',
                        icon: const Icon(Icons.check_box, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Öneri kartları
            const Text(
              'Genel Öneriler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.pink[200]!),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.woman, color: Colors.pink[400], size: 40),
                        const SizedBox(height: 12),
                        const Text(
                          'Kadınlar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '1800-2000\nkcal/gün',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.pink[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.man, color: Colors.blue[400], size: 40),
                        const SizedBox(height: 12),
                        const Text(
                          'Erkekler',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '2200-2500\nkcal/gün',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hedefKaloriController.dispose();
    super.dispose();
  }
}
