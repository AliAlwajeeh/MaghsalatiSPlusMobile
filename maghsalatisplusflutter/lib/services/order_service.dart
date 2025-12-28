import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import '../models/order_detail.dart';

class OrderService {
  static const _baseUrl = 'http://localhost:5041';

  Future<List<Order>> fetchOrders() async {
    final res = await http.get(Uri.parse('$_baseUrl/orders'));
    if (res.statusCode == 200) {
      return Order.listFromJson(res.body);
    }
    throw Exception('فشل في جلب الطلبات');
  }

  Future<OrderDetail> fetchOrderById(int id) async {
    final res = await http.get(Uri.parse('$_baseUrl/orders/$id'));
    if (res.statusCode == 200) {
      return OrderDetail.fromJson(jsonDecode(res.body));
    }
    throw Exception('فشل في جلب تفاصيل الطلب');
  }

  Future<void> deleteOrder(int id) async {
    final res = await http.delete(Uri.parse('$_baseUrl/orders/$id'));
    if (res.statusCode != 200) {
      throw Exception('فشل حذف الطلب');
    }
  }

  Future<void> createOrder({
    required int customerId,
    required List<Map<String, dynamic>> itemsJson,
    required List<File> images,
  }) async {
    final uri = Uri.parse('$_baseUrl/orders');
    final req = http.MultipartRequest('POST', uri)
      ..fields['CustomerId'] = customerId.toString()
      ..fields['OrderItemsJson'] = jsonEncode(itemsJson);

    // إضافة صور الأصناف
    for (var i = 0; i < images.length; i++) {
      req.files.add(
        await http.MultipartFile.fromPath('ItemImages', images[i].path),
      );
    }

    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);
    if (resp.statusCode != 200) {
      throw Exception('فشل إنشاء الطلب: ${resp.body}');
    }
  }
}
