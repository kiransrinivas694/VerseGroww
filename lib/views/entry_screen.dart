import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/theme_controller.dart';
import '../bindings/history_binding.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class EntryScreen extends StatelessWidget {
  EntryScreen({super.key}) {
    Get.put(NavigationController());
  }

  final List<Widget> _screens = [
    HomeScreen(),
    const HistoryScreen(),
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
        () {
          // Initialize HistoryBinding when history tab is selected
          if (controller.currentIndex.value == 1) {
            HistoryBinding().dependencies();
          }
          return _screens[controller.currentIndex.value];
        },
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changePage,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
