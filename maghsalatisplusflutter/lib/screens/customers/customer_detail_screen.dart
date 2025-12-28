// lib/screens/customers/customer_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/customer_detail.dart';
import '../../models/order.dart';
import '../../services/customer_service.dart';

class CustomerDetailScreen extends StatefulWidget {
  final int customerId;
  const CustomerDetailScreen({required this.customerId, super.key});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final _service = CustomerService();
  late Future<CustomerDetail> _futureDetail;

  @override
  void initState() {
    super.initState();
    _futureDetail = _service.fetchCustomerById(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل العميل #${widget.customerId}'),
        backgroundColor: Colors.lightBlue[700],
      ),
      body: FutureBuilder<CustomerDetail>(
        future: _futureDetail,
        builder: (c, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('خطأ: ${snap.error}'));
          }
          final detail = snap.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('رقم الهاتف: ${detail.phoneNumber}'),
                const Divider(height: 32),

                const Text(
                  'طلبات العميل:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: detail.orders.isEmpty
                      ? const Center(child: Text('لا توجد طلبات لهذا العميل'))
                      : ListView.builder(
                          itemCount: detail.orders.length,
                          itemBuilder: (_, i) {
                            final o = detail.orders[i];
                            return ListTile(
                              title: Text('طلب #${o.id}'),
                              subtitle: Text(
                                'تاريخ: ${DateFormat('yyyy-MM-dd').format(o.orderDate)}',
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (action) {
                                  switch (action) {
                                    case 'view':
                                      Navigator.pushNamed(
                                        context,
                                        '/orders/${o.id}',
                                      );
                                      break;
                                    case 'edit':
                                      Navigator.pushNamed(
                                        context,
                                        '/orders/${o.id}/edit',
                                      );
                                      break;
                                    case 'delete':
                                      // يمكن استدعاء حذف من OrderService
                                      break;
                                  }
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: 'view',
                                    child: Text('عرض التفاصيل'),
                                  ),
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text('تعديل'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('حذف'),
                                  ),
                                ],
                              ),
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/orders/${o.id}',
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
