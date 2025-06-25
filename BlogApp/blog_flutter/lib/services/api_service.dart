import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/post.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static final _storage = FlutterSecureStorage();

  /// LOGIN - returns token and stores it securely
  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'token', value: data['token']);
      await _storage.write(key: 'userId', value: data['user_id'].toString());
      return true;
    }
    return false;
  }

  /// GET TOKEN
  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  /// LOGOUT
  static Future<void> logout() async {
    await _storage.deleteAll();
  }

  /// GET all posts
  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  /// GET single post
  static Future<Post> fetchPostDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/$id/'));

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  /// CREATE a new post
  static Future<bool> createPost(String title, String content, String token) async {
  final response = await http.post(
    Uri.parse('$baseUrl/posts/'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    },
    body: jsonEncode({'title': title, 'content': content}),
  );

  return response.statusCode == 201;
}

  
}
