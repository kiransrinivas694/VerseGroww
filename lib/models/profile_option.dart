import 'package:flutter/material.dart';

class ProfileOption {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  ProfileOption({
    required this.title,
    required this.icon,
    this.iconColor,
    required this.onTap,
  });
}
