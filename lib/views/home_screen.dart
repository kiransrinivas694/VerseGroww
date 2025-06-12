import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../models/verse.dart';
import 'widget_customization_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}) {
    Get.put(HomeController());
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Verse',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => _buildVerseCard(controller.todayVerse.value, theme),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () =>
                            Get.to(() => WidgetCustomizationScreen()),
                        icon: const Icon(Icons.palette_outlined),
                        label: const Text('Customize Widget'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: controller.refreshVerse,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh Verse'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerseCard(Verse? verse, ThemeData theme) {
    if (verse == null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primaryContainer.withOpacity(0.3),
              theme.colorScheme.primaryContainer.withOpacity(0.1),
            ],
          ),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withOpacity(0.3),
            theme.colorScheme.primaryContainer.withOpacity(0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      verse?.name ?? '',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: () =>
                          Get.find<HomeController>().refreshVerse(),
                      tooltip: 'Refresh Verse',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  verse?.text ?? '',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  verse?.reference ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
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
