import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/constants/app_styles.dart';

class PreviewCard extends StatelessWidget {
  const PreviewCard({
    super.key,
    required this.color,
    this.subtitle,
    required this.name,
  });

  final Color color;
  final String? subtitle;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1, color: AppColors.kStroke),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
              
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
       
              name.isNotEmpty ? name : 'New Group',
              style: AppStyles.styleSemiBold16.copyWith(
                color: AppColors.kDarkBlue,
              ),
            ),
            const SizedBox(height: 8),

            if (subtitle != null)
              Text(subtitle!, style: AppStyles.styleMedium12),
          ],
        ),
      ),
    );
  }
}
