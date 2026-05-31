import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/constants/app_styles.dart';
import 'package:planova_app/features/group/presentation/views/edit_groups/widgets/preview_card.dart';

class AppearanceBody extends StatelessWidget {
  const AppearanceBody({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
    required this.name,
  });

  final List<Color> colors;
  final Color selectedColor;
  final Function(Color) onColorSelected;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PreviewCard(color: selectedColor, name: name),

          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Group Color",
              style: AppStyles.styleSemiBold16.copyWith(
                color: AppColors.kDarkBlue,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(width: 1, color: AppColors.kStroke),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: colors.map((color) {
                  return GestureDetector(
                    onTap: () => onColorSelected(color),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selectedColor == color
                            ? Border.all(color: Colors.grey, width: 2)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
