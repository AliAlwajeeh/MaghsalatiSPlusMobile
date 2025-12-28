// lib/models/category.dart

import 'dart:convert';

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'] as int, name: json['name'] as String);
  }

  static List<Category> listFromJson(String str) {
    final data = jsonDecode(str) as List<dynamic>;
    return data
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
