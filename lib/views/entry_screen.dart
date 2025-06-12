import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/theme_controller.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class EntryScreen extends StatelessWidget {
  EntryScreen({super.key}) {
    Get.put(NavigationController());
  }

  final List<Widget> _screens = [
    HomeScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.find<NavigationController>();
    final ThemeController themeController = Get.find<ThemeController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('VerseGroww'),
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                themeController.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: themeController.toggleTheme,
              tooltip: themeController.isDarkMode
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(
        () => _screens[controller.currentIndex.value],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
