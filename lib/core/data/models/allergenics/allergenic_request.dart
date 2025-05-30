import 'package:flutter/foundation.dart'; // Optional: for @required if not using null safety

class AllergyRequest {
  final List<int> ingredientId;

  AllergyRequest({
    required this.ingredientId,
  });

  factory AllergyRequest.fromJson(Map<String, dynamic> json) {
    return AllergyRequest(
      ingredientId: List<int>.from(json['ingredientId'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingredientId': ingredientId,
    };
  }
}
