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

class GetCalorieResponse {
  final String? Message;
  final int? Calorie;

  GetCalorieResponse({
    this.Message,
    this.Calorie,
  });

  factory GetCalorieResponse.fromJson(Map<String, dynamic> json) {
    return GetCalorieResponse(
      Message: json['message'] as String?,
      Calorie: json['calorie'] as int?,
    );
  }

  @override
  String toString() {
    return 'GetCalorieResponse(calorie: $Calorie, message: $Message)';
  }
}

class CalorieUpdateRequest {
  final int CalorieCount;

  CalorieUpdateRequest({
    required this.CalorieCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'calorieCount': CalorieCount,
    };
  }

  @override
  String toString() {
    return 'CalorieUpdateRequest(calorieCount: $CalorieCount)';
  }
}

class CalorieResponse {
  final String? Message;
  CalorieResponse({
    this.Message,
  });

  factory CalorieResponse.fromJson(Map<String, dynamic> json) {
    return CalorieResponse(
      Message: json['message'] as String?,
    );
  }

  @override
  String toString() {
    return 'CalorieResponse(message: $Message)';
  }
}
