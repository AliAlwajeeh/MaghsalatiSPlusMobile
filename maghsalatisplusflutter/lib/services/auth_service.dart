// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth/login_request.dart';
import '../models/auth/login_response.dart';
import 'dart:io';

class AuthService {
  static const _baseUrl = 'http://localhost:5041';

  Future<LoginResponse> login(LoginRequest dto) async {
    final uri = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<void> register({
    required String shopName,
    required String email,
    required String password,
    required String phoneNumber,
    String? location,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$_baseUrl/register');
    final request = http.MultipartRequest('POST', uri)
      ..fields['ShopName'] = shopName
      ..fields['Email'] = email
      ..fields['Password'] = password
      ..fields['PhoneNumber'] = phoneNumber;
    if (location != null) {
      request.fields['Location'] = location;
    }
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('ProfileImageFile', imageFile.path),
      );
    }

    final streamed = await request.send();
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode != 200) {
      final err = jsonDecode(resp.body);
      throw Exception(err['Message'] ?? 'Register failed');
    }
  }
}
