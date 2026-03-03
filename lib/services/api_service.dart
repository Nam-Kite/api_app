import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Fetches a list of posts from a public API.
  ///
  /// Throws an [Exception] if the request fails or parsing fails.
  Future<List<Post>> fetchPosts() async {
    final url = Uri.parse('$_baseUrl/posts');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((e) => Post.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      // rethrow so callers can handle the error
      throw Exception('Network error: $e');
    }
  }
}
