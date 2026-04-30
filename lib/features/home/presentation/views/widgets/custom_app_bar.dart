import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/constants/app_styles.dart';
import 'package:planova_app/core/constants/assets.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Image.asset(Assets.imagesProfile, width: 40, height: 40),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good Morning', style: AppStyles.medium14(context)),
                Text('Hla!', style: AppStyles.semiBold20(context)),
              ],
            ),
          ],
        ),
        Spacer(),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.yellowSoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(Assets.imagesFire),
                  const SizedBox(width: 10),
                  Text(
                    "2",
                    style: AppStyles.regular12(
                      context,
                    ).copyWith(color: AppColors.orange),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: SvgPicture.asset(
                Assets.imagesNotification,
                width: 24,
                height: 24,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
