// lib/services/category_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/create_category_request.dart';

class CategoryService {
  static const _baseUrl = 'http://localhost:5041';

  Future<List<Category>> fetchCategories() async {
    final res = await http.get(Uri.parse('$_baseUrl/categories'));
    if (res.statusCode == 200) {
      return Category.listFromJson(res.body);
    }
    throw Exception('فشل في جلب الأقسام');
  }

  Future<Category> fetchCategoryById(int id) async {
    final res = await http.get(Uri.parse('$_baseUrl/categories/$id'));
    if (res.statusCode == 200) {
      return Category.fromJson(jsonDecode(res.body));
    }
    throw Exception('فشل في جلب تفاصيل القسم');
  }

  Future<void> deleteCategory(int id) async {
    final res = await http.delete(Uri.parse('$_baseUrl/categories/$id'));
    if (res.statusCode != 200) {
      throw Exception('فشل حذف القسم');
    }
  }

  Future<void> createCategory(CreateCategoryRequest dto) async {
    final uri = Uri.parse('$_baseUrl/categories');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('فشل إنشاء القسم');
    }
  }

  Future<void> updateCategory(int id, CreateCategoryRequest dto) async {
    final uri = Uri.parse('$_baseUrl/categories/$id');
    final res = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('فشل تعديل القسم');
    }
  }
}
