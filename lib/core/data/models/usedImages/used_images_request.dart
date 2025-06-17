class UsedImageModel {
  final String image;
  final DateTime createdDate;

  UsedImageModel({
    required this.image,
    required this.createdDate,
  });

  factory UsedImageModel.fromJson(Map<String, dynamic> json) {
    return UsedImageModel(
      image: json['image'] ?? '',
      createdDate: DateTime.parse(json['createdDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'createdDate': createdDate.toIso8601String(),
    };
  }
}
