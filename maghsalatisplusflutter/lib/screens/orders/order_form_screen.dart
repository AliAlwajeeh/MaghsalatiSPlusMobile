import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/order_service.dart';
import '../../models/order_item.dart';

class OrderFormScreen extends StatefulWidget {
  final int? editOrderId;
  const OrderFormScreen({this.editOrderId, super.key});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerIdCtrl = TextEditingController();
  final List<_ItemFormData> _items = [];
  bool _isLoading = false;
  final _picker = ImagePicker();
  final _service = OrderService();

  @override
  void initState() {
    super.initState();
    // إذا كان في تحرير، يمكن هنا تحميل بيانات الطلب مسبقاً
    _addItem(); // ابدأ بصف واحد فارغ
  }

  void _addItem() {
    setState(() => _items.add(_ItemFormData()));
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
  }

  Future<void> _pickImage(int index) async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (file != null) {
      setState(() => _items[index].image = File(file.path));
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_items.isEmpty) return;
    setState(() => _isLoading = true);

    // تجهيز JSON للأصناف
    final itemsJson = _items
        .map(
          (it) => {
            'itemName': it.nameCtrl.text,
            'quantity': int.parse(it.qtyCtrl.text),
            'price': double.parse(it.priceCtrl.text),
            'service': it.service,
            'categoryId': int.parse(it.categoryIdCtrl.text),
          },
        )
        .toList();

    // جمع الصور
    final images = _items.map((it) => it.image).whereType<File>().toList();

    try {
      await _service.createOrder(
        customerId: int.parse(_customerIdCtrl.text),
        itemsJson: itemsJson,
        images: images,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حفظ الطلب')));
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
    _customerIdCtrl.dispose();
    for (var it in _items) {
      it.nameCtrl.dispose();
      it.qtyCtrl.dispose();
      it.priceCtrl.dispose();
      it.categoryIdCtrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editOrderId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'تعديل الطلب' : 'إنشاء طلب جديد'),
        backgroundColor: Colors.lightBlue[700],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // حقل رقم العميل
              TextFormField(
                controller: _customerIdCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'رقم العميل',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'أدخل رقم العميل';
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // قائمة الأصناف القابلة للتكرار
              ..._items.asMap().entries.map((entry) {
                final idx = entry.key;
                final it = entry.value;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'صنف ${idx + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                              onPressed: () => _removeItem(idx),
                            ),
                          ],
                        ),

                        TextFormField(
                          controller: it.nameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'اسم الصنف',
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'أدخل اسم الصنف' : null,
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: it.qtyCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'الكمية',
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'أدخل الكمية'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: it.priceCtrl,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                decoration: const InputDecoration(
                                  labelText: 'السعر',
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'أدخل السعر'
                                    : null,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: it.categoryIdCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'رقم القسم',
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'أدخل رقم القسم'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: it.service,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Wash',
                                    child: Text('غسيل'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Iron',
                                    child: Text('كي'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'WashAndIron',
                                    child: Text('غسيل+كي'),
                                  ),
                                ],
                                onChanged: (v) => it.service = v!,
                                decoration: const InputDecoration(
                                  labelText: 'نوع الخدمة',
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // اختيار صورة الصنف
                        Row(
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.image_outlined),
                              label: Text(
                                it.image == null
                                    ? 'صورة الصنف'
                                    : 'تغيير الصورة',
                              ),
                              onPressed: () => _pickImage(idx),
                            ),
                            if (it.image != null) ...[
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 16),
              TextButton.icon(
                icon: const Icon(Icons.add_box_outlined),
                label: const Text('إضافة صنف جديد'),
                onPressed: _addItem,
              ),

              const SizedBox(height: 24),
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
                      : Text(isEdit ? 'حفظ التعديلات' : 'إنشاء الطلب'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// بيانات وسيطة لكل صف صنف في الواجهة
class _ItemFormData {
  final nameCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final categoryIdCtrl = TextEditingController();
  File? image;
  String service = 'Wash';
}
