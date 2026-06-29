import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'font_helper.dart';

class AppStyles {
  // Dynamic styles (home_feature) - تتغير حسب الـ context
  static TextStyle medium14(BuildContext context) {
    return TextStyle(
      fontSize: FontHelper.scale(context, 14),
      fontWeight: FontWeight.w500,
      color: AppColors.blueGrey,
    );
  }

  static TextStyle medium12(BuildContext context) {
    return TextStyle(
      fontSize: FontHelper.scale(context, 12),
      fontWeight: FontWeight.w500,
      color: AppColors.blueGrey,
    );
  }

  static TextStyle bold32(BuildContext context) {
    return TextStyle(
      fontSize: FontHelper.scale(context, 32),
      fontWeight: FontWeight.w700,
      color: AppColors.white,
    );
  }

  static TextStyle bold24(BuildContext context) {
    return TextStyle(
      fontSize: FontHelper.scale(context, 24),
      fontWeight: FontWeight.w700,
      color: AppColors.white,
    );
  }

  static TextStyle bold20(BuildContext context) {
    return TextStyle(
      fontSize: FontHelper.scale(context, 20),
      fontWeight: FontWeight.w700,
      color: AppColors.white,
    );
  }

  static TextStyle bold18(BuildContext context) {
    return TextStyle(
      fontSize: FontHelper.scale(context, 18),
      fontWeight: FontWeight.w700,
      color: AppColors.white,
    );
  }

  static TextStyle medium16(BuildContext context) {
    return TextStyle(
      fontSize: FontHelper.scale(context, 16),
      fontWeight: FontWeight.w500,
      color: AppColors.white,
    );
  }

  static TextStyle semiBold16(BuildContext context) {
    return TextStyle(
      fontSize: FontHelper.scale(context, 16),
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    );
  }

  static TextStyle bold12(BuildContext context) {
    return TextStyle(
      fontSize: FontHelper.scale(context, 12),
      fontWeight: FontWeight.w700,
      color: AppColors.white,
    );
  }

  static TextStyle bold16(BuildContext context) {
    return TextStyle(
      fontSize: FontHelper.scale(context, 16),
      fontWeight: FontWeight.w700,
      color: AppColors.white,
    );
  }

  static TextStyle semiBold18(BuildContext context) {
    return TextStyle(
      fontSize: FontHelper.scale(context, 18),
      fontWeight: FontWeight.w600,
      color: AppColors.primaryBlue,
    );
  }

  static TextStyle semiBold20(BuildContext context) {
    return TextStyle(
      fontSize: FontHelper.scale(context, 20),
      fontWeight: FontWeight.w600,
      color: AppColors.primaryBlue,
    );
  }

  static TextStyle regular12(BuildContext context) {
    return TextStyle(
      fontSize: FontHelper.scale(context, 12),
      fontWeight: FontWeight.w400,
      color: const Color(0xff848A94).withOpacity(0.8),
    );
  }

  static TextStyle regular10(BuildContext context) {
    return TextStyle(
      fontSize: FontHelper.scale(context, 10),
      fontWeight: FontWeight.w400,
      color: AppColors.orange,
    );
  }

  static TextStyle medium10(BuildContext context) {
    return TextStyle(
      fontSize: FontHelper.scale(context, 10),
      fontWeight: FontWeight.w500,
      color: AppColors.primaryBlue,
    );
  }

  static const styleSemiBold18 = TextStyle(
    color: AppColors.kDarkBlue,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const styleSemiBold16 = TextStyle(
    color: AppColors.kWhite,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const styleMedium12 = TextStyle(
    color: AppColors.kPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const styleMedium16 = TextStyle(
    color: AppColors.kDarkBlue,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const styleRegular12 = TextStyle(
    color: AppColors.mediumGrey,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static const styleRegular14 = TextStyle(
    color: AppColors.mediumGrey,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}