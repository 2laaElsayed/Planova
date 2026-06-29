import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/new_task_provider.dart';
import 'custom_text_field.dart';

class TaskInputFields extends StatefulWidget {
  final String initialTitle;
  final String initialDescription;

  const TaskInputFields({
    super.key,
    required this.initialTitle,
    required this.initialDescription,
  });

  @override
  State<TaskInputFields> createState() => _TaskInputFieldsState();
}

class _TaskInputFieldsState extends State<TaskInputFields> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription);
  }

  @override
  void didUpdateWidget(covariant TaskInputFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTitle != oldWidget.initialTitle) {
      _titleController.text = widget.initialTitle;
    }
    if (widget.initialDescription != oldWidget.initialDescription) {
      _descriptionController.text = widget.initialDescription;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: "Title",
          hint: "What needs to be done?",
          controller: _titleController,
          onChanged: (value) {
            context.read<NewTaskProvider>().setTitle(value);
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: "Description",
          hint: "Add details...",
          maxLines: 3,
          controller: _descriptionController,
          onChanged: (value) {
            context.read<NewTaskProvider>().setDescription(value);
          },
        ),
      ],
    );
  }
}