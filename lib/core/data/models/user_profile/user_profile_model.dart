class UserProfileModel {
  String fullName;
  String email;
  List<String> allergicTo;
  List<String> dislikes;
  int dailyCalorieGoal;

  UserProfileModel({
    required this.fullName,
    required this.email,
    required this.allergicTo,
    required this.dislikes,
    this.dailyCalorieGoal = 2000,
  });

  // Mevcut malzemeler listesi
  static const List<String> availableIngredients = [
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

  // JSON'dan model oluşturma
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      allergicTo: List<String>.from(json['allergicTo'] ?? []),
      dislikes: List<String>.from(json['dislikes'] ?? []),
      dailyCalorieGoal: json['dailyCalorieGoal'] ?? 2000,
    );
  }

  // Model'i JSON'a çevirme
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'allergicTo': allergicTo,
      'dislikes': dislikes,
      'dailyCalorieGoal': dailyCalorieGoal,
    };
  }

  // Kullanılabilir malzemeleri filtreleme (alerjiler ve sevmedikleri hariç)
  List<String> getAvailableIngredientsForAllergies() {
    return availableIngredients
        .where((ingredient) => !allergicTo.contains(ingredient))
        .toList();
  }

  List<String> getAvailableIngredientsForDislikes() {
    return availableIngredients
        .where((ingredient) => !dislikes.contains(ingredient))
        .toList();
  }
}
