// lib/models/customer.dart

import 'dart:convert';

class Customer {
  final int id;
  final String name;
  final String phoneNumber;
  final DateTime createdAt;

  Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as int,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  static List<Customer> listFromJson(String str) {
    final data = jsonDecode(str) as List<dynamic>;
    return data
        .map((e) => Customer.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
