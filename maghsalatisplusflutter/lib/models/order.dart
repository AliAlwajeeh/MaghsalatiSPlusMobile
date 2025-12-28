// lib/models/order.dart

import 'dart:convert';

class Order {
  final int id;
  final DateTime orderDate;
  final String customerName;

  Order({
    required this.id,
    required this.orderDate,
    required this.customerName,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      orderDate: DateTime.parse(json['orderDate'] as String),
      customerName: json['customer']['name'] as String,
    );
  }

  static List<Order> listFromJson(String str) {
    final data = jsonDecode(str) as List<dynamic>;
    return data.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
  }
}
