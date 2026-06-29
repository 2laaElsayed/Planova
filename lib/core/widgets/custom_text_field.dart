import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/constants/app_styles.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.hintText,
    this.maxLines = 1,
    required this.onchange,
    this.icon,
    this.controller,
  });

  final String hintText;
  final IconButton? icon;
  TextEditingController? controller;
  final int maxLines;
  final Function(String) onchange;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onchange,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        hintStyle: AppStyles.styleRegular14,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.kStroke),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.kStroke),
        ),
      ),
    );
  }
}
