import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/constants/assets.dart';

class EditActionButton extends StatelessWidget {
  const EditActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey350),
      ),
      child: SvgPicture.asset(
        Assets.imagesEdit,
        width: 18,
        height: 18,
      ),
    );
  }
}