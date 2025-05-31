class CalorieRequest {
  final String? userId;
  final int? Calorie;

  CalorieRequest({
    this.userId,
    this.Calorie,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'calorie': Calorie,
    };
  }

  @override
  String toString() {
    return 'CalorieRequest(userId: $userId, calorie: $Calorie)';
  }
}
