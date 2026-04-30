import 'package:flutter/material.dart';

class TaskReminder extends StatefulWidget {
  const TaskReminder({super.key});

  @override
  State<TaskReminder> createState() => _TaskReminderState();
}

class _TaskReminderState extends State<TaskReminder> {
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.notifications_none,
          color: Color(0xFF9BA3EB),
          size: 28,
        ),
        title: const Text("Reminder" , style: TextStyle(color: Color(0xFFACACAD))),
        subtitle: const Text(
          "Get notified before due date",
        ),
        trailing: Switch(
          value: isEnabled,
          onChanged: (value) {
            setState(() {
              isEnabled = value;
            });
          },
        ),
      ),
    );
  }
}