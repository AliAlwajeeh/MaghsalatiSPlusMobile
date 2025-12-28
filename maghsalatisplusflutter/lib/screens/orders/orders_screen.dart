// lib/screens/orders/orders_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/order.dart';
import '../../services/order_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _service = OrderService();
  late Future<List<Order>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _futureOrders = _service.fetchOrders();
  }

  Future<void> _confirmDelete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف الطلب رقم $id؟'),
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
      await _service.deleteOrder(id);
      setState(_load);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تم حذف الطلب رقم $id')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلبات'),
        backgroundColor: Colors.lightBlue[700],
        elevation: 2,
      ),
      body: FutureBuilder<List<Order>>(
        future: _futureOrders,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('خطأ: ${snap.error}'));
          }
          final orders = snap.data!;
          if (orders.isEmpty) {
            return const Center(child: Text('لا توجد طلبات بعد.'));
          }
          // ترتيب الطلبات بالتاريخ تنازلي
          orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final order = orders[i];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  title: Text(
                    'طلب #${order.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'التاريخ: ${DateFormat('yyyy-MM-dd – kk:mm').format(order.orderDate)}\n'
                    'العميل: ${order.customerName}',
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (action) {
                      switch (action) {
                        case 'view':
                          Navigator.pushNamed(context, '/orders/${order.id}');
                          break;
                        case 'edit':
                          Navigator.pushNamed(
                            context,
                            '/orders/${order.id}/edit',
                          );
                          break;
                        case 'delete':
                          _confirmDelete(order.id);
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
                      Navigator.pushNamed(context, '/orders/${order.id}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue[700],
        child: const Icon(Icons.add, size: 28),
        onPressed: () => Navigator.pushNamed(context, '/orders/new'),
      ),
    );
  }
}
