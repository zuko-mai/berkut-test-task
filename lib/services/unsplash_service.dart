import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/photo.dart';

class UnsplashService {
  static const String baseUrl = 'https://api.unsplash.com';
  static const String accessKey = 'I-I9NHn_SZUihpIjkj4CTAPaA2PEVjyhLo4lhV_xXMI';

  Map<String, String> get _headers => {
        'Authorization': 'Client-ID $accessKey',
        'Accept-Version': 'v1',
        'Content-Type': 'application/json',
      };

  Future<List<Photo>> getRandomPhotos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/photos/random?count=8'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Photo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load random photos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<SearchResult> searchPhotos(String query, {int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/photos?query=$query&page=$page&per_page=10'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Search result: $data');
        return SearchResult.fromJson(data);
      } else {
        throw Exception('Failed to search photos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Photo> getPhotoDetails(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/photos/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Photo.fromJson(data);
      } else {
        throw Exception('Failed to load photo details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
