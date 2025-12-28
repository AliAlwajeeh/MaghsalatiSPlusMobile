// lib/models/customer_detail.dart

import 'dart:convert';
import 'order.dart';

class CustomerDetail {
  final int id;
  final String name;
  final String phoneNumber;
  final DateTime createdAt;
  final List<Order> orders;

  CustomerDetail({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.createdAt,
    required this.orders,
  });

  factory CustomerDetail.fromJson(Map<String, dynamic> json) {
    final list = (json['orders'] as List<dynamic>)
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList();
    return CustomerDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      orders: list,
    );
  }
}
