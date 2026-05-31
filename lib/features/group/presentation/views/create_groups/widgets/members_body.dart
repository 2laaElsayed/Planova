import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/widgets/custom_text_field.dart';
import 'package:planova_app/features/group/presentation/views/edit_groups/widgets/preview_card.dart';

class MembersBody extends StatelessWidget {
  const MembersBody({super.key, required this.selectedColor, required this.name});

  final Color selectedColor;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PreviewCard(color: selectedColor, subtitle: "2 members", name: name,),

        const SizedBox(height: 30),

        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Invite Members",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D2366),
            ),
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: CustomTextField(hintText: "Enter Name", onchange: (p0) {}),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.kPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
