import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:planova_app/core/constants/assets.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(Assets.imagesHomeOutline, "Home", 0),
          _item(Assets.imagesAddTask, "Tasks", 1),
          _item(Assets.imagesGroupOutline, "Group", 2),
          _item(Assets.imagesSettingOutlined, "Setting", 3),
        ],
      ),
    );
  }

  Widget _item(String icon, String label, int index) {
    final isSelected = currentIndex == index;

    String selectedIcon;
    switch (icon) {
      case Assets.imagesHomeOutline:
        selectedIcon = Assets.imagesHomeFill;
        break;
      case Assets.imagesAddTask:
        selectedIcon = Assets.imagesAddTask;
        break;
      case Assets.imagesGroupOutline:
        selectedIcon = Assets.imagesGroupFill;
        break;
      case Assets.imagesSettingOutlined:
        selectedIcon = Assets.imagesSettingFill;
        break;
      default:
        selectedIcon = icon;
    }

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          // color: isSelected
          //     ? const Color(0xff8B80F8).withOpacity(0.12)
          //     : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isSelected ? selectedIcon : icon,
              width: 24,
              height: 24,
              color: isSelected ? const Color(0xff8B80F8) : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? const Color(0xff8B80F8) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}