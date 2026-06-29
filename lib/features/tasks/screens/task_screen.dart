import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/new_task_provider.dart';
import '../widgets/task_details_widgets/task_app_bar.dart';
import '../widgets/task_details_widgets/task_date_picker.dart';
import '../widgets/task_details_widgets/task_input_fields.dart';
import '../widgets/task_details_widgets/task_options_row.dart';
import '../widgets/task_details_widgets/task_reminder.dart';
import '../widgets/task_details_widgets/primary_button.dart';
import 'package:planova_app/features/tasks/models/TaskModel.dart';

class CreateTaskScreen extends StatefulWidget {
  final bool isEdit;
  final TaskModel? task;

  const CreateTaskScreen({super.key, this.isEdit = false, this.task});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<NewTaskProvider>();

      if (widget.isEdit && widget.task != null) {
        provider.loadTask(widget.task!);
      } else {
        provider.clearTask();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewTaskProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: TaskAppBar(
            title: widget.isEdit ? "Task Details" : "New Task",
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TaskInputFields(
                    initialTitle: provider.title,
                    initialDescription: provider.description,
                  ),

                  const SizedBox(height: 16),
                  const TaskOptionsRow(),
                  const SizedBox(height: 16),
                  const TaskDatePicker(),
                  const SizedBox(height: 16),
                  const TaskReminder(),
                  const SizedBox(height: 30),

                  PrimaryButton(
                    text: provider.isSubmitting
                        ? (widget.isEdit ? "Saving..." : "Creating...")
                        : (widget.isEdit ? "Save Changes" : "Create Task"),
                    onPressed: () async {
                      if (widget.isEdit && widget.task != null) {
                        await provider.updateTask(widget.task!.taskId);
                      } else {
                        await provider.submitTask();
                      }

                      if (provider.status == NewTaskStatus.success) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.isEdit
                                    ? "Task Updated Successfully"
                                    : "Task Created Successfully",
                              ),
                            ),
                          );
                        }
                      }

                      if (provider.status == NewTaskStatus.error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                provider.error ?? "Something went wrong",
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
