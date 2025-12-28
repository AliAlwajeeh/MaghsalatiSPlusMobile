// lib/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'settings_edit_screen.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blue700 = Colors.lightBlue[700]!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        centerTitle: true,
        backgroundColor: blue700,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ملف المستخدم + تعديل
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  leading: const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                  title: const Text('اسم المستخدم'),
                  subtitle: const Text('user@example.com'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/settings/edit'),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // من نحن
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  leading: Icon(Icons.info_outline, color: blue700),
                  title: const Text('من نحن'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.pushNamed(context, '/settings/about'),
                ),
              ),

              const SizedBox(height: 12),

              // خدمة العملاء
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  leading: Icon(Icons.support_agent_outlined, color: blue700),
                  title: const Text('خدمة العملاء'),
                  subtitle: const Text('733322052'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chat, color: Colors.green),
                        onPressed: () {
                          // TODO: افتح WhatsApp عبر url_launcher
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone, color: Colors.blue),
                        onPressed: () {
                          // TODO: افتح لوحة الاتصال عبر url_launcher
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
