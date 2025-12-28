// lib/screens/categories/categories_screen.dart

import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../services/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _service = CategoryService();
  late Future<List<Category>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => _futureCategories = _service.fetchCategories();

  Future<void> _confirmDelete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل تريد حذف القسم رقم $id؟'),
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
      await _service.deleteCategory(id);
      setState(_load);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تم حذف القسم #$id')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأقسام'),
        backgroundColor: Colors.lightBlue[700],
      ),
      body: FutureBuilder<List<Category>>(
        future: _futureCategories,
        builder: (c, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('خطأ: ${snap.error}'));
          }
          final list = snap.data!;
          if (list.isEmpty) {
            return const Center(child: Text('لا توجد أقسام بعد'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final cat = list[i];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    '#${cat.id}  ${cat.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (action) {
                      switch (action) {
                        case 'view':
                          Navigator.pushNamed(context, '/categories/${cat.id}');
                          break;
                        case 'edit':
                          Navigator.pushNamed(
                            context,
                            '/categories/edit',
                            arguments: cat,
                          );
                          break;
                        case 'delete':
                          _confirmDelete(cat.id);
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
                      Navigator.pushNamed(context, '/categories/${cat.id}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue[700],
        child: const Icon(Icons.add_box, size: 28),
        onPressed: () => Navigator.pushNamed(context, '/categories/new'),
      ),
    );
  }
}
