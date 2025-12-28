// lib/screens/categories/category_detail_screen.dart

import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../services/category_service.dart';

class CategoryDetailScreen extends StatefulWidget {
  final int categoryId;
  const CategoryDetailScreen({required this.categoryId, super.key});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final _service = CategoryService();
  late Future<Category> _futureCategory;

  @override
  void initState() {
    super.initState();
    _futureCategory = _service.fetchCategoryById(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
      future: _futureCategory,
      builder: (context, snap) {
        // حالة التحميل
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // حالة الخطأ
        if (snap.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('تفاصيل القسم #${widget.categoryId}'),
              backgroundColor: Colors.lightBlue[700],
            ),
            body: Center(child: Text('خطأ: ${snap.error}')),
          );
        }

        // الحالة الناجحة
        final cat = snap.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text('تفاصيل القسم #${cat.id}'),
            backgroundColor: Colors.lightBlue[700],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رقم القسم: ${cat.id}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'اسم القسم: ${cat.name}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.lightBlue[700],
            child: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/categories/edit', arguments: cat);
            },
          ),
        );
      },
    );
  }
}
