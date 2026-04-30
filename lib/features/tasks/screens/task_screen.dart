import 'package:flutter/material.dart';
import '../widgets/task_details_widgets/task_input_fields.dart';
import '../widgets/task_details_widgets/task_options_row.dart';
import '../widgets/task_details_widgets/task_date_picker.dart';
import '../widgets/task_details_widgets/task_app_bar.dart';
import '../widgets/task_details_widgets/task_reminder.dart';
import '../widgets/task_details_widgets/primary_button.dart';

class CreateTaskScreen extends StatelessWidget {
  final bool isEdit;

  const CreateTaskScreen({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(title: isEdit ? "Task Details" : "New Task"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TaskInputFields(),
              const SizedBox(height: 16),
              const TaskOptionsRow(),
              const SizedBox(height: 16),
               TaskDatePicker(),
              const SizedBox(height: 16),
              const TaskReminder(),
              const SizedBox(height: 30),
              PrimaryButton(
                text: isEdit ? "Save Changes" : "Create Task",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}