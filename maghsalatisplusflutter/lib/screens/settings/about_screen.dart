// lib/screens/settings/about_screen.dart

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blue700 = Colors.lightBlue[700]!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('من نحن'),
        centerTitle: true,
        backgroundColor: blue700,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'عن التطبيق',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'تطبيق مغسلتي اس بلس يساعد أصحاب المغاسل في إدارة طلباتهم، '
                'عملائهم، وأقسام خدماتهم بسهولة وفعالية.',
              ),
              SizedBox(height: 24),
              Text(
                'المطور',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Dev.Ali'),
              SizedBox(height: 24),
              Text(
                'للتواصل مع خدمة العملاء',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('واتساب واتصال: 733322052'),
            ],
          ),
        ),
      ),
    );
  }
}
