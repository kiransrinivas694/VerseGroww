import 'package:flutter/material.dart';

class ProfileOption {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const ProfileOption({
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor,
  });
}
