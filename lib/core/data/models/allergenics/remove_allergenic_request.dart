import 'package:flutter/foundation.dart'; // Optional: for @required if not using null safety

class RemevoAllergyRequest {
  final int ingredientId;

  RemevoAllergyRequest({
    required this.ingredientId,
  });

  factory RemevoAllergyRequest.fromJson(Map<String, dynamic> json) {
    return RemevoAllergyRequest(
      ingredientId: json['IngredientsId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IngredientsId': ingredientId,
    };
  }
}

class RemoveAllergenicRespone {
  final String Message;

  RemoveAllergenicRespone({
    required this.Message,
  });

  factory RemoveAllergenicRespone.fromJson(Map<String, dynamic> json) {
    return RemoveAllergenicRespone(
      Message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': Message,
    };
  }
}
