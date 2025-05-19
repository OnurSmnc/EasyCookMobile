import 'package:easycook/core/data/models/viewedHistory.dart';
import 'package:easycook/core/service/api_service.dart';
import 'package:easycook/core/service/api_constants.dart';

class ViewedHistoryRepository {
  final ApiService _apiService;

  ViewedHistoryRepository(this._apiService);

  Future<List<ViewedRecipeHistoryItem>> getAllViewedHistory() async {
    try {
      final response = await _apiService.get(ApiConstats.getViewedHistory);
      print("API response: $response");
      final List<dynamic> historyList = response['viewedHistory'] ?? [];
      print("History List: $historyList");
      return historyList
          .map((e) => ViewedRecipeHistoryItem.fromJson(e))
          .toList();
    } catch (e) {
      print('ViewedHistoryRepository - getAllViewedHistory error: $e');
      return [];
    }
  }
}
