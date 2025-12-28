// lib/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import '../../models/auth/login_request.dart';
import '../../services/auth_service.dart';
//import 'register_screen.dart'; // استيراد شاشة التسجيل

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _onLoginPressed() async {
    setState(() => _isLoading = true);

    final dto = LoginRequest(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    try {
      final result = await _authService.login(dto);
      // بعد نجاح تسجيل الدخول يمكن الانتقال إلى الصفحة الرئيسية
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في تسجيل الدخول')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MaghsalatiSPlus'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الشعار الدائري
            CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),

            SizedBox(height: 24),

            // حقل البريد الإلكتروني
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),

            // حقل كلمة المرور
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 24),

            // زرّ تسجيل الدخول
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onLoginPressed,
                child: _isLoading
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text('تسجيل الدخول'),
              ),
            ),

            SizedBox(height: 12),

            // رابط إنشاء حساب
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ليس لديك حساب؟'),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text('إنشاء حساب'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
