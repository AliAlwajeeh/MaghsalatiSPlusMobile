// lib/services/customer_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer.dart';
import '../models/create_customer_request.dart';
import '../models/customer_detail.dart';

class CustomerService {
  static const _baseUrl = 'http://localhost:5041';

  Future<List<Customer>> fetchCustomers() async {
    final res = await http.get(Uri.parse('$_baseUrl/customers'));
    if (res.statusCode == 200) {
      return Customer.listFromJson(res.body);
    }
    throw Exception('فشل في جلب العملاء');
  }

  Future<CustomerDetail> fetchCustomerById(int id) async {
    final res = await http.get(Uri.parse('$_baseUrl/customers/$id'));
    if (res.statusCode == 200) {
      return CustomerDetail.fromJson(jsonDecode(res.body));
    }
    throw Exception('فشل في جلب تفاصيل العميل');
  }

  Future<void> deleteCustomer(int id) async {
    final res = await http.delete(Uri.parse('$_baseUrl/customers/$id'));
    if (res.statusCode != 200) {
      throw Exception('فشل حذف العميل');
    }
  }

  Future<void> createCustomer(CreateCustomerRequest dto) async {
    final uri = Uri.parse('$_baseUrl/customers');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('فشل إنشاء العميل');
    }
  }

  Future<void> updateCustomer(int id, CreateCustomerRequest dto) async {
    final uri = Uri.parse('$_baseUrl/customers/$id');
    final res = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('فشل تعديل بيانات العميل');
    }
  }
}
