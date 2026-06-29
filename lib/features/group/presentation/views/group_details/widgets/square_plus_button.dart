import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';

class SquarePlusButton extends StatelessWidget {
  const SquarePlusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: AppColors.kPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 16),
    );
  }
}
