import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/question_model.dart';

class ApiService {
  static const String baseUrl = 'https://opentdb.com';

  // Session cache for categories
  static List<CategoryModel>? _cachedCategories;

  /// Fetches categories from OpenTDB, caching them in memory for the session
  static Future<List<CategoryModel>> getCategories({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedCategories != null && _cachedCategories!.isNotEmpty) {
      return _cachedCategories!;
    }

    final url = Uri.parse('$baseUrl/api_category.php');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> categoryList = data['trivia_categories'] ?? [];
        _cachedCategories = categoryList
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return _cachedCategories!;
      } else {
        throw Exception('Failed to load categories (Status: ${response.statusCode})');
      }
    } catch (e) {
      // If network fails but cache exists, return cache
      if (_cachedCategories != null && _cachedCategories!.isNotEmpty) {
        return _cachedCategories!;
      }
      rethrow;
    }
  }

  /// Fetches quiz questions with given parameters
  static Future<List<QuestionModel>> getQuestions({
    required int amount,
    int? categoryId,
    String? difficulty, // 'easy', 'medium', 'hard', or null for any
    String? type,       // 'multiple', 'boolean', or null for any
  }) async {
    final queryParams = <String, String>{
      'amount': amount.toString(),
    };

    if (categoryId != null && categoryId > 0) {
      queryParams['category'] = categoryId.toString();
    }
    if (difficulty != null && difficulty.isNotEmpty && difficulty.toLowerCase() != 'any') {
      queryParams['difficulty'] = difficulty.toLowerCase();
    }
    if (type != null && type.isNotEmpty && type.toLowerCase() != 'any') {
      queryParams['type'] = type.toLowerCase();
    }

    final url = Uri.parse('$baseUrl/api.php').replace(queryParameters: queryParams);

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final responseCode = data['response_code'] as int? ?? 0;

        if (responseCode == 0) {
          final List<dynamic> results = data['results'] ?? [];
          if (results.isEmpty) {
            throw Exception('No questions returned for the selected configuration.');
          }
          return results
              .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
              .toList();
        } else if (responseCode == 1) {
          throw Exception(
              'Not enough questions available for this specific configuration. Try fewer questions or "Any Difficulty".');
        } else if (responseCode == 2) {
          throw Exception('Invalid parameters provided to the API.');
        } else if (responseCode == 5) {
          throw Exception('Rate limited. Please wait 5 seconds before trying again.');
        } else {
          throw Exception('API returned response code $responseCode');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
