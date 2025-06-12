import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/profile_option.dart';
import '../controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final RxList<ProfileOption> options = <ProfileOption>[].obs;
  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    _initializeOptions();
  }

  void _initializeOptions() {
    options.value = [
      ProfileOption(
        title: 'Subscription',
        icon: Icons.card_membership_rounded,
        onTap: () {
          // TODO: Navigate to subscription screen
          Get.snackbar(
            'Coming Soon',
            'Subscription feature will be available soon!',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      ),
      ProfileOption(
        title: 'Terms and Conditions',
        icon: Icons.description_rounded,
        onTap: () {
          // TODO: Navigate to terms and conditions screen
          Get.snackbar(
            'Coming Soon',
            'Terms and conditions will be available soon!',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      ),
      ProfileOption(
        title: 'Share App',
        icon: Icons.share_rounded,
        onTap: () {
          // TODO: Implement share functionality
          Get.snackbar(
            'Coming Soon',
            'Share feature will be available soon!',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      ),
      ProfileOption(
        title: 'Logout',
        icon: Icons.logout_rounded,
        iconColor: Colors.red,
        onTap: () => _showLogoutConfirmation(),
      ),
    ];
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Close dialog
              await _authController.signOut();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
