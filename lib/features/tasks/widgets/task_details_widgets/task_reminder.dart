import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/new_task_provider.dart';

class TaskReminder extends StatelessWidget {
  const TaskReminder({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<NewTaskProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: Colors.grey[100]!,
        ),
      ),

      child: ListTile(

        leading: const Icon(
          Icons.notifications_none,
          color: Color(0xFF9BA3EB),
          size: 28,
        ),

        title: const Text(
          "Reminder",
          style: TextStyle(
            color: Color(0xFFACACAD),
          ),
        ),

        subtitle: const Text(
          "Get notified before due date",
        ),

        trailing: Switch(

          value: provider.reminderEnabled,

          onChanged: (value) {

            provider.toggleReminder(value);
          },
        ),
      ),
    );
  }
}