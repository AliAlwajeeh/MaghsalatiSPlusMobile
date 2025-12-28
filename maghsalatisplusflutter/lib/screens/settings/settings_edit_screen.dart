// lib/screens/settings/settings_edit_screen.dart

import 'package:flutter/material.dart';

class SettingsEditScreen extends StatefulWidget {
  const SettingsEditScreen({super.key});

  @override
  State<SettingsEditScreen> createState() => _SettingsEditScreenState();
}

class _SettingsEditScreenState extends State<SettingsEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameCtrl = TextEditingController(text: 'مغسلتي اس بلس');
  final _emailCtrl = TextEditingController(text: 'user@example.com');
  final _phoneCtrl = TextEditingController(text: '733322052');
  final _locationCtrl = TextEditingController(text: 'صنعاء، اليمن');
  bool _isLoading = false;

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // TODO: استدعاء API لحفظ التعديلات

    await Future.delayed(const Duration(seconds: 1)); // محاكاة انتظار
    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _shopNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blue700 = Colors.lightBlue[700]!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل البيانات'),
        centerTitle: true,
        backgroundColor: blue700,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _shopNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'اسم المحل',
                    prefixIcon: Icon(Icons.store_rounded),
                  ),
                  validator: (v) => v!.isEmpty ? 'أدخل اسم المحل' : null,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: Icon(Icons.email_rounded),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'أدخل البريد الإلكتروني';
                    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    return regex.hasMatch(v) ? null : 'صيغة غير صحيحة';
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneCtrl,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف',
                    prefixIcon: Icon(Icons.phone_rounded),
                  ),
                  validator: (v) => v!.isEmpty ? 'أدخل رقم الهاتف' : null,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _locationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'الموقع',
                    prefixIcon: Icon(Icons.location_on_rounded),
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blue700,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _isLoading ? null : _onSave,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('حفظ التغييرات'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
