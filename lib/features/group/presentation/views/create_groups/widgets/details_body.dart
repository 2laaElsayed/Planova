import 'package:flutter/material.dart';
import 'package:planova_app/core/widgets/custom_text_field.dart';

class DetailsBody extends StatelessWidget {
  const DetailsBody({
    super.key,
    required this.onNameChanged,
    required this.onDesChanged,
  });
  final Function(String) onNameChanged;
  final Function(String) onDesChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Title",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D2366),
            ),
          ),
          SizedBox(height: 8),
          CustomTextField(
            hintText: "What needs to be done?",
            onchange: onNameChanged,
          ),
          SizedBox(height: 20),
          Text(
            "Description",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D2366),
            ),
          ),
          SizedBox(height: 8),
          CustomTextField(
            hintText: "Add details...",
            maxLines: 4,
            onchange: onDesChanged,
          ),
        ],
      ),
    );
  }
}
