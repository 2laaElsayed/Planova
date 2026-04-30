import 'package:flutter/material.dart';
import 'custom_text_field.dart';
class TaskInputFields extends StatelessWidget {
  const TaskInputFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CustomTextField(
          label: "Title",
          hint: "What needs to be done?",
        ),
        SizedBox(height: 16),
        CustomTextField(
          label: "Description",
          hint: "Add details...",
          maxLines: 3,
        ),
      ],
    );
  }
}