
import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.kDarkBlue,
        ),
      ),
    );
  }
}