import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/match_request_model.dart';
import '../models/gift_model.dart';

class ApiService {
  static const String baseUrl = 'http://your-server-ip:5000/api'; // Arkadaşının vereceği URL

  Future<UserModel> getUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load user');
  }

  Future<List<PostModel>> getPostsByLocation(String location) async {
    final response = await http.get(Uri.parse('$baseUrl/posts?location=$location'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PostModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load posts');
  }

  Future<void> createPost(PostModel post) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': post.id,
        'userId': post.userId,
        'imageUrl': post.imageUrl,
        'location': post.location,
        'createdAt': post.createdAt.toIso8601String(),
        'isBoosted': post.isBoosted,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create post');
    }
  }

  Future<void> sendMatchRequest(MatchRequestModel request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/matches'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': request.id,
        'senderId': request.senderId,
        'receiverId': request.receiverId,
        'message': request.message,
        'createdAt': request.createdAt.toIso8601String(),
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to send match request');
    }
  }

  Future<List<GiftModel>> getGifts(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/gifts?userId=$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => GiftModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load gifts');
  }
}