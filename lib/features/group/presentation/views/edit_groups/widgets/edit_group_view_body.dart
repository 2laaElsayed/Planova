import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/widgets/custom_button.dart';
import 'package:planova_app/features/group/presentation/views/widgets/colors_widget.dart';
import 'package:planova_app/features/group/presentation/views/edit_groups/widgets/preview_card.dart';

class EditGroupViewBody extends StatefulWidget {
  const EditGroupViewBody({super.key});

  @override
  State<EditGroupViewBody> createState() => _EditGroupViewBodyState();
}

class _EditGroupViewBodyState extends State<EditGroupViewBody> {
  int currentStep = 0;

  final List<Color> colors = [
    const Color(0xFFFFC1BE),
    const Color(0xFFF6E1D3),
    const Color(0xFFBEE7E9),
    const Color(0xFFFFF2CC),
    const Color(0xFFB9B4A1),
    const Color(0xFFE1D5FF),
    const Color(0xFFA8D1A9),
    const Color(0xFFF3C4D3),
    const Color(0xFFD9EDB4),
    const Color(0xFFE5D9C3),
  ];

  Color selectedColor = const Color(0xFFFFC1BE);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  PreviewCard(color: AppColors.kPrimary, name: 'Malecular Biology',),
                  SizedBox(height: 16),
                  // DetailsBody(),
                  SizedBox(height: 16),
                  ColorsWidget(
                    colors: colors,
                    selectedColor: selectedColor,
                    onColorSelected: (color) {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          CustomButton(onTap: () {}, title: "Save"),
        ],
      ),
    );
  }
}
