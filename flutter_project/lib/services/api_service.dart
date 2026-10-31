import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/listing.dart';

class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Determine host dynamically based on platform (e.g., 10.0.2.2 for Android emulator)
  static String get defaultBaseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080/api';
    }
    return 'http://localhost:8080/api';
  }

  String baseUrl = defaultBaseUrl;
  String? _authToken;
  Map<String, dynamic>? _currentUser;

  bool get isAuthenticated => _authToken != null;
  String? get currentUserId => _currentUser?['id'] as String?;
  Map<String, dynamic>? get currentUser => _currentUser;
  String get currentUserName => _currentUser?['name'] as String? ?? 'Rohan Varma';
  String get currentUserPhone => _currentUser?['phone'] as String? ?? '+91 98765 43210';
  String get currentUserEmail => _currentUser?['email'] as String? ?? 'rohan@srkr.edu.in';

  void logout() {
    _authToken = null;
    _currentUser = null;
  }

  Map<String, String> get _headers {
    final map = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_authToken != null) {
      map['Authorization'] = 'Bearer $_authToken';
    }
    return map;
  }

  // --- Auth APIs ---

  Future<bool> login({
    String email = 'rohan@srkr.edu.in',
    String password = 'password123',
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true) {
          _authToken = body['data']['token'];
          _currentUser = body['data']['user'];
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('ApiService.login error: $e');
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String department = 'Computer Science',
    String batch = "'28",
    String rollNumber = '24A91A05XX',
    String college = 'SRKR Engg College',
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'department': department,
          'batch': batch,
          'rollNumber': rollNumber,
          'college': college,
        }),
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true) {
          _authToken = body['data']['token'];
          _currentUser = body['data']['user'];
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('ApiService.register error: $e');
      return false;
    }
  }

  // Ensure authenticated session (auto-authenticates demo user if token is missing)
  Future<void> ensureAuthenticated() async {
    if (!isAuthenticated) {
      await login();
    }
  }

  // --- Products / Listings APIs ---

  Future<List<Listing>> fetchProducts({FilterState? filter}) async {
    try {
      final queryParams = <String, String>{};

      if (filter != null) {
        if (filter.searchQuery.trim().isNotEmpty) {
          queryParams['search'] = filter.searchQuery.trim();
        }
        if (filter.category != 'All') {
          queryParams['category'] = filter.category;
        }
        if (filter.department != 'all') {
          queryParams['department'] = filter.department;
        }
        if (filter.semester.isNotEmpty) {
          queryParams['semester'] = filter.semester;
        }
        if (filter.condition != null) {
          queryParams['condition'] = filter.condition!.label;
        }
        if (filter.minPrice > 0) {
          queryParams['minPrice'] = filter.minPrice.toString();
        }
        if (filter.maxPrice < 1500) {
          queryParams['maxPrice'] = filter.maxPrice.toString();
        }
        if (filter.sortBy.isNotEmpty) {
          queryParams['sortBy'] = filter.sortBy;
        }
      }

      final uri = Uri.parse('$baseUrl/products').replace(queryParameters: queryParams.isEmpty ? null : queryParams);
      final res = await http.get(uri, headers: _headers);

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success'] == true && body['data'] is List) {
          final list = (body['data'] as List)
              .map((item) => Listing.fromJson(item as Map<String, dynamic>))
              .toList();
          return list;
        }
      }
      throw Exception('Failed to load listings: ${res.statusCode}');
    } catch (e) {
      debugPrint('ApiService.fetchProducts error: $e');
      rethrow;
    }
  }

  Future<Listing> fetchProductById(String id) async {
    final res = await http.get(Uri.parse('$baseUrl/products/$id'), headers: _headers);
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      if (body['success'] == true) {
        return Listing.fromJson(body['data'] as Map<String, dynamic>);
      }
    }
    throw Exception('Failed to load product $id');
  }

  Future<Listing> createProduct(Listing listing) async {
    await ensureAuthenticated();
    final res = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: _headers,
      body: jsonEncode(listing.toJson()),
    );

    if (res.statusCode == 201 || res.statusCode == 200) {
      final body = jsonDecode(res.body);
      if (body['success'] == true) {
        return Listing.fromJson(body['data'] as Map<String, dynamic>);
      }
    }
    throw Exception('Failed to create listing: ${res.body}');
  }

  Future<Listing> updateProduct(String id, Listing listing) async {
    await ensureAuthenticated();
    final res = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: _headers,
      body: jsonEncode(listing.toJson()),
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      if (body['success'] == true) {
        return Listing.fromJson(body['data'] as Map<String, dynamic>);
      }
    }
    throw Exception('Failed to update listing: ${res.body}');
  }

  Future<Listing> markAsSold(String id) async {
    await ensureAuthenticated();
    final res = await http.patch(
      Uri.parse('$baseUrl/products/$id/sold'),
      headers: _headers,
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      if (body['success'] == true) {
        return Listing.fromJson(body['data'] as Map<String, dynamic>);
      }
    }
    throw Exception('Failed to mark listing as sold: ${res.body}');
  }

  Future<void> deleteProduct(String id) async {
    await ensureAuthenticated();
    final res = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
      headers: _headers,
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to delete listing: ${res.body}');
    }
  }

  Future<List<Listing>> fetchMyProducts() async {
    await ensureAuthenticated();
    final res = await http.get(
      Uri.parse('$baseUrl/products/seller/me'),
      headers: _headers,
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      if (body['success'] == true && body['data'] is List) {
        return (body['data'] as List)
            .map((item) => Listing.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  // --- Cloudinary Image Upload API ---

  Future<String?> uploadImageBytes(Uint8List bytes, String filename) async {
    try {
      final uri = Uri.parse('$baseUrl/upload');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: filename),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data']?['url'] != null) {
          return body['data']['url'] as String;
        }
      }
    } catch (e) {
      debugPrint('ApiService.uploadImageBytes error: $e');
    }
    return null;
  }
}
