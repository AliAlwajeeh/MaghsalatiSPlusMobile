import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/order_detail.dart';
import '../../models/order_item.dart';
import '../../services/order_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;
  const OrderDetailScreen({required this.orderId, super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _service = OrderService();
  late Future<OrderDetail> _futureDetail;

  @override
  void initState() {
    super.initState();
    _futureDetail = _service.fetchOrderById(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الطلب #${widget.orderId}'),
        backgroundColor: Colors.lightBlue[700],
      ),
      body: FutureBuilder<OrderDetail>(
        future: _futureDetail,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('خطأ: ${snap.error}'));
          }
          final order = snap.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التاريخ: ${DateFormat('yyyy-MM-dd – kk:mm').format(order.orderDate)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'العميل: ${order.customerName}',
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(height: 32),

                const Text(
                  'عناصر الطلب:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: ListView.builder(
                    itemCount: order.items.length,
                    itemBuilder: (ctx, i) {
                      final item = order.items[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: item.imageUrl != null
                              ? Image.network(
                                  item.imageUrl!,
                                  width: 48,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image_not_supported_rounded),
                          title: Text(item.itemName),
                          subtitle: Text(
                            'كمية: ${item.quantity}   سعر: ${item.price}',
                          ),
                          trailing: Text(item.service),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue[700],
        child: const Icon(Icons.edit),
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/orders/new',
            arguments: widget.orderId,
          );
        },
      ),
    );
  }
}
