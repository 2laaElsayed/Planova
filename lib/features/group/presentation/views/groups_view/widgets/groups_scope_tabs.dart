import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';

class GroupsScopeTabs extends StatelessWidget {
  final ScopeTab selected;
  final Function(ScopeTab) onChange;

  const GroupsScopeTabs({
    super.key,
    required this.selected,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    Widget item(String label, ScopeTab value) {
      final isSelected = selected == value;

      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();

      final textWidth = textPainter.width;

      return Expanded(
        child: GestureDetector(
          onTap: () => onChange(value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.kPrimary : AppColors.blueGrey,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),

              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: isSelected ? textWidth : 0,
                decoration: BoxDecoration(
                  color: AppColors.kPrimary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Divider(height: 1, thickness: 1, color: AppColors.kStroke),
          ),

          Row(
            children: [
              item('All Groups', ScopeTab.all),
              item('Team', ScopeTab.team),
              item('Personal', ScopeTab.personal),
            ],
          ),
        ],
      ),
    );
  }
}
