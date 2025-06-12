import 'package:get/get.dart';
import '../views/auth/login_screen.dart';
import '../views/entry_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/login',
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: '/home',
      page: () => EntryScreen(),
    ),
  ];
}
