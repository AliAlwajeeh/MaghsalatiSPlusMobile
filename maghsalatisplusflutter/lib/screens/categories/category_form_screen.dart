// lib/screens/categories/category_form_screen.dart

import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../models/create_category_request.dart';
import '../../services/category_service.dart';

class CategoryFormScreen extends StatefulWidget {
  final Category? editCategory;
  const CategoryFormScreen({this.editCategory, super.key});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _service = CategoryService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.editCategory != null) {
      _nameCtrl.text = widget.editCategory!.name;
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final dto = CreateCategoryRequest(
      name: _nameCtrl.text.trim(),
      shopOwnerId: 'SHOP_OWNER_ID', // ضع الـ userId الخاص بك
    );

    try {
      if (widget.editCategory != null) {
        await _service.updateCategory(widget.editCategory!.id, dto);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم تعديل القسم')));
      } else {
        await _service.createCategory(dto);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم إضافة قسم جديد')));
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editCategory != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'تعديل القسم' : 'إضافة قسم'),
        backgroundColor: Colors.lightBlue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'اسم القسم',
                  prefixIcon: Icon(Icons.category_rounded),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'أدخل اسم القسم' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEdit ? 'حفظ التعديلات' : 'إضافة قسم'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
