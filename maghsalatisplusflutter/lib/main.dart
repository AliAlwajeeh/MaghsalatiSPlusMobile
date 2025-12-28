import 'package:flutter/material.dart';

// استورد كل الشاشات هنا
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/orders/order_detail_screen.dart';
import 'screens/orders/order_form_screen.dart';
import 'screens/customers/customers_screen.dart';
import 'screens/customers/customer_detail_screen.dart';
import 'screens/customers/customer_form_screen.dart';
import 'screens/categories/categories_screen.dart';
import 'screens/categories/category_detail_screen.dart';
import 'screens/categories/category_form_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/settings/about_screen.dart';
import 'screens/settings/settings_edit_screen.dart';

void main() {
  //  runApp(const MaghsalatiApp());
  runApp(const MaterialApp(home: MaghsalatiApp()));
}

class MaghsalatiApp extends StatelessWidget {
  const MaghsalatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaghsalatiSPlus',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/orders': (_) => const OrdersScreen(),
        '/orders/new': (_) => const OrderFormScreen(),
        '/customers': (_) => const CustomersScreen(),
        '/customers/new': (_) => const CustomerFormScreen(),
        '/categories': (_) => const CategoriesScreen(),
        '/categories/new': (_) => const CategoryFormScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/settings/edit': (_) => const SettingsEditScreen(),
        '/settings/about': (_) => const AboutScreen(),
      },
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');
        final segments = uri.pathSegments;

        // Orders
        if (segments.length > 1 && segments[0] == 'orders') {
          if (segments.length == 2) {
            return MaterialPageRoute(
              builder: (_) =>
                  OrderDetailScreen(orderId: int.parse(segments[1])),
            );
          }
          if (segments.length == 3 && segments[2] == 'edit') {
            return MaterialPageRoute(
              builder: (_) =>
                  OrderFormScreen(editOrderId: int.parse(segments[1])),
            );
          }
        }

        // Customers
        if (segments.length > 1 && segments[0] == 'customers') {
          if (segments.length == 2) {
            return MaterialPageRoute(
              builder: (_) =>
                  CustomerDetailScreen(customerId: int.parse(segments[1])),
            );
          }
          if (segments.length == 3 && segments[2] == 'edit') {
            return MaterialPageRoute(
              builder: (_) => CustomerFormScreen(
                editCustomer: settings.arguments as dynamic,
              ),
            );
          }
        }

        // Categories
        if (segments.length > 1 && segments[0] == 'categories') {
          if (segments.length == 2) {
            return MaterialPageRoute(
              builder: (_) =>
                  CategoryDetailScreen(categoryId: int.parse(segments[1])),
            );
          }
          if (segments.length == 3 && segments[2] == 'edit') {
            return MaterialPageRoute(
              builder: (_) => CategoryFormScreen(
                editCategory: settings.arguments as dynamic,
              ),
            );
          }
        }

        return null;
      },
    );
  }
}
