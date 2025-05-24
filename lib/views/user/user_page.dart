import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Kullanıcı bilgileri
  String fullName = "Ahmet Yılmaz";
  String email = "ahmet.yilmaz@email.com";

  // Alerjen ve sevmediği malzemeler
  List<String> allergicTo = ["Fındık", "Çilek", "Balık"];
  List<String> dislikes = ["Brokoli", "Patlıcan", "İstiridye"];

  // Mevcut malzemeler listesi
  final List<String> availableIngredients = [
    "Elma",
    "Armut",
    "Muz",
    "Çilek",
    "Kiraz",
    "Şeftali",
    "Domates",
    "Salatalık",
    "Havuç",
    "Brokoli",
    "Patlıcan",
    "Biber",
    "Fındık",
    "Badem",
    "Ceviz",
    "Balık",
    "Tavuk",
    "Et",
    "İstiridye",
    "Karides",
    "Süt",
    "Yumurta",
    "Peynir"
  ];

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
            // Profil Bilgileri Kartı
            _buildProfileCard(),
            SizedBox(height: 20),

            // Şifre Değiştirme Kartı
            _buildPasswordCard(),
            SizedBox(height: 20),

            // Kalori Kartı
            _buildCalorieCard(),
            SizedBox(height: 20),

            // Alerjiler Kartı
            _buildAllergiesCard(),
            SizedBox(height: 20),

            // Sevmedikleri Kartı
            _buildDislikesCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
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
                  onPressed: () => _editProfileInfo(),
                  icon: Icon(Icons.edit, color: Colors.green[600]),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoRow(Icons.person, 'Ad Soyad', fullName),
            SizedBox(height: 12),
            _buildInfoRow(Icons.email, 'E-posta', email),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieCard() {
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
                      '2000 kcal',
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
              onPressed: () => _changePassword(),
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

  Widget _buildPasswordCard() {
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
              onPressed: () => _changePassword(),
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

  Widget _buildAllergiesCard() {
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
                  'Alerjilerim',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
                IconButton(
                  onPressed: () => _manageAllergies(),
                  icon: Icon(Icons.add, color: Colors.red[600]),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (allergicTo.isEmpty)
              Text(
                'Henüz alerji belirtmediniz',
                style: TextStyle(
                    color: Colors.grey[600], fontStyle: FontStyle.italic),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allergicTo
                    .map((allergy) => _buildChip(
                          allergy,
                          Colors.red[100]!,
                          Colors.red[700]!,
                          () => _removeAllergy(allergy),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDislikesCard() {
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
                  'Sevmediklerim',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                IconButton(
                  onPressed: () => _manageDislikes(),
                  icon: Icon(Icons.add, color: Colors.blue[600]),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (dislikes.isEmpty)
              Text(
                'Henüz sevmediğiniz malzeme belirtmediniz',
                style: TextStyle(
                    color: Colors.grey[600], fontStyle: FontStyle.italic),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: dislikes
                    .map((dislike) => _buildChip(
                          dislike,
                          Colors.blue[100]!,
                          Colors.blue[700]!,
                          () => _removeDislike(dislike),
                        ))
                    .toList(),
              ),
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

  Widget _buildChip(String label, Color backgroundColor, Color textColor,
      VoidCallback onDelete) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      backgroundColor: backgroundColor,
      deleteIcon: Icon(Icons.close, size: 18, color: textColor),
      onDeleted: onDelete,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  void _editProfileInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController =
            TextEditingController(text: fullName);
        TextEditingController emailController =
            TextEditingController(text: email);

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
                setState(() {
                  fullName = nameController.text;
                  email = emailController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Bilgiler güncellendi!')),
                );
              },
              child: Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController currentPasswordController =
            TextEditingController();
        TextEditingController newPasswordController = TextEditingController();
        TextEditingController confirmPasswordController =
            TextEditingController();

        return AlertDialog(
          title: Text('Şifre Değiştir'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mevcut Şifre',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Yeni Şifre',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Yeni Şifre Tekrar',
                  border: OutlineInputBorder(),
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
                if (newPasswordController.text ==
                    confirmPasswordController.text) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Şifre başarıyla değiştirildi!')),
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
  }

  void _manageAllergies() {
    _showIngredientSelector(
      title: 'Alerji Ekle',
      currentList: allergicTo,
      onAdd: (ingredient) {
        setState(() {
          if (!allergicTo.contains(ingredient)) {
            allergicTo.add(ingredient);
          }
        });
      },
    );
  }

  void _manageDislikes() {
    _showIngredientSelector(
      title: 'Sevmediğim Malzeme Ekle',
      currentList: dislikes,
      onAdd: (ingredient) {
        setState(() {
          if (!dislikes.contains(ingredient)) {
            dislikes.add(ingredient);
          }
        });
      },
    );
  }

  void _showIngredientSelector({
    required String title,
    required List<String> currentList,
    required Function(String) onAdd,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> filteredIngredients = availableIngredients
            .where((ingredient) => !currentList.contains(ingredient))
            .toList();

        return AlertDialog(
          title: Text(title),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: filteredIngredients.length,
              itemBuilder: (context, index) {
                String ingredient = filteredIngredients[index];
                return ListTile(
                  title: Text(ingredient),
                  trailing: Icon(Icons.add),
                  onTap: () {
                    onAdd(ingredient);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$ingredient eklendi!')),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('İptal'),
            ),
          ],
        );
      },
    );
  }

  void _removeAllergy(String allergy) {
    setState(() {
      allergicTo.remove(allergy);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$allergy alerjilerden çıkarıldı!')),
    );
  }

  void _removeDislike(String dislike) {
    setState(() {
      dislikes.remove(dislike);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$dislike sevmediklerden çıkarıldı!')),
    );
  }
}
