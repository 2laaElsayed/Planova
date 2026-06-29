import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';

class ModeButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const ModeButton({
    super.key,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEFF0FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: selected ? AppColors.kPrimary : Colors.grey,
        ),
      ),
    );
  }
}
