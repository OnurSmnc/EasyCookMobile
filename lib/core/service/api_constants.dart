class ApiConstats {
  static const String baseUrl = 'http://10.0.2.2:5001';

  //Endpointler
  static const String addViewedRecipes = 'api/ViewedRecipe/CreateViewedHistory';
  static const String detectIngredients = 'api/Malzeme/DetectIngredients';
  static const String addFavorite =
      'api/FavoriteFood/CreateFavoriteRecipe'; // Updated endpoint
  static const String removeFavorite = 'api/FavoriteFood/RemoveFavoriteRecipe';
  static const String getFavorite = 'api/FavoriteFood/GetAllFavoriteFood';
  static const String getViewedHistory = 'api/ViewedRecipe/GetAllViewedHistory';
  static const String login = 'api/Auth/Login';
  static const String refreshToken = 'api/Auth/RefreshToken';
  static const String register = 'api/Auth/Register';
  static const String changePassword = 'api/UserInfo/UpdateUserPassword';
  static const String getUserInfo = 'api/UserInfo/GetUserInfo';
  static const String updateUserInfo = 'api/UserInfo/UpdateUserInfo';
  static const String getIngredients =
      'api/Malzeme/GetAllIngredients'; // Endpoint to get all ingredients
  static const String getAllergies =
      'api/Alerjik/GetAllAllergenics'; // Endpoint to get all allergies
  static const String addAllergy =
      'api/Alerjik/AddAllergenics'; // Endpoint to add a new allergy

  static const String deleteAllergy = 'api/Alerjik/RemoveAllergenics';
  static const String addCalorie = 'api/UserInfo/CreateUserCalorie';
  static const String updateCalorie = 'api/UserInfo/UpdateUserCalorie';
  static const String getCalorie = 'api/UserInfo/GetUserCalorie';
  static const String addComment = 'api/FoodComment/CreateUserFoodComment';
  static const String getComment = 'api/FoodComment/GetAllUserComment';
  static const String madeRecipe = 'api/Tarifler/RecipeMaded';
  static const String getRecipeMaded = 'api/Tarifler/GetAllRecipeMaded';
  static const String getRecommendedRecipes = 'api/Malzeme/GetRecommendatitons';

  // API timeout durations
  static const int connectionTimeout = 30000; // milliseconds

  // API response codes
  static const int success = 200;
  static const int created = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int serverError = 500;
}
