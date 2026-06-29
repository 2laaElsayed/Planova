import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:planova_app/core/constants/app_colors.dart';

class CircleStepper extends StatelessWidget {
  const CircleStepper({super.key, required this.icon, required this.isActive});

  final String icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    Color color = isActive ? AppColors.kPrimary : AppColors.mediumGrey;

    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2, color: color),
      ),
      child: Center(
        child: SvgPicture.asset(
          icon,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    );
  }
}
