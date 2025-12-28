import 'dart:convert';
import 'order_item.dart';

class OrderDetail {
  final int id;
  final DateTime orderDate;
  final String customerName;
  final List<OrderItem> items;

  OrderDetail({
    required this.id,
    required this.orderDate,
    required this.customerName,
    required this.items,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['orderItems'] as List<dynamic>;
    return OrderDetail(
      id: json['id'] as int,
      orderDate: DateTime.parse(json['orderDate'] as String),
      customerName: json['customer']['name'] as String,
      items: itemsJson
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
