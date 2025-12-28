// lib/screens/customers/customer_form_screen.dart

import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../models/create_customer_request.dart';
import '../../services/customer_service.dart';

class CustomerFormScreen extends StatefulWidget {
  final Customer? editCustomer;
  const CustomerFormScreen({this.editCustomer, super.key});

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _service = CustomerService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.editCustomer != null) {
      _nameCtrl.text = widget.editCustomer!.name;
      _phoneCtrl.text = widget.editCustomer!.phoneNumber;
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final dto = CreateCustomerRequest(
      name: widget.editCustomer?.name ?? _nameCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim(),
      shopOwnerId: 'SHOP_OWNER_ID', // استبدل بالـ userId أو من الـ token
    );

    try {
      if (widget.editCustomer != null) {
        await _service.updateCustomer(widget.editCustomer!.id, dto);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم تحديث العميل')));
      } else {
        await _service.createCustomer(dto);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم إنشاء عميل جديد')));
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
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editCustomer != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'تعديل العميل' : 'إضافة عميل'),
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
                  labelText: 'اسم العميل',
                  prefixIcon: Icon(Icons.person_rounded),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'أدخل اسم العميل' : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  prefixIcon: Icon(Icons.phone_rounded),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'أدخل رقم الهاتف' : null,
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
                      : Text(isEdit ? 'حفظ التعديلات' : 'إضافة عميل'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
