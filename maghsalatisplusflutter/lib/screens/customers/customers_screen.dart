// lib/screens/customers/customers_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/customer.dart';
import '../../services/customer_service.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final _service = CustomerService();
  late Future<List<Customer>> _futureCustomers;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => _futureCustomers = _service.fetchCustomers();

  Future<void> _confirmDelete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تأكيد حذف العميل'),
        content: Text('هل تريد حذف العميل رقم $id؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _service.deleteCustomer(id);
      setState(_load);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تم حذف العميل #$id')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('العملاء'),
        backgroundColor: Colors.lightBlue[700],
      ),
      body: FutureBuilder<List<Customer>>(
        future: _futureCustomers,
        builder: (c, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('خطأ: ${snap.error}'));
          }
          final list = snap.data!
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          if (list.isEmpty) {
            return const Center(child: Text('لا يوجد عملاء بعد'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final customer = list[i];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    '#${customer.id}  ${customer.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'تاريخ التسجيل: ${DateFormat('yyyy-MM-dd').format(customer.createdAt)}',
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (action) {
                      switch (action) {
                        case 'view':
                          Navigator.pushNamed(
                            context,
                            '/customers/${customer.id}',
                          );
                          break;
                        case 'edit':
                          Navigator.pushNamed(
                            context,
                            '/customers/edit',
                            arguments: customer,
                          );
                          break;
                        case 'delete':
                          _confirmDelete(customer.id);
                          break;
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'view', child: Text('عرض التفاصيل')),
                      PopupMenuItem(value: 'edit', child: Text('تعديل')),
                      PopupMenuItem(value: 'delete', child: Text('حذف')),
                    ],
                  ),
                  onTap: () =>
                      Navigator.pushNamed(context, '/customers/${customer.id}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue[700],
        child: const Icon(Icons.person_add, size: 28),
        onPressed: () => Navigator.pushNamed(context, '/customers/new'),
      ),
    );
  }
}
