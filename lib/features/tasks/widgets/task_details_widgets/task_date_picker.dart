import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/new_task_provider.dart';

class TaskDatePicker extends StatelessWidget {
  const TaskDatePicker({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<NewTaskProvider>();

    final formattedDate = DateFormat(
      'EEEE, MMM d, yyyy',
    ).format(provider.dueDate);

    return ListTile(

      leading: const Icon(
        Icons.calendar_today,
        color: Color.fromARGB(255, 157, 164, 234),
      ),

      title: const Text(
        "Due Date",
        style: TextStyle(
          color: Color.fromARGB(255, 172, 172, 173),
        ),
      ),

      subtitle: Text(formattedDate),

      onTap: () async {

        final pickedDate = await showDatePicker(
          context: context,

          initialDate: provider.dueDate,

          firstDate: DateTime.now(),

          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {

          provider.setDueDate(pickedDate);
        }
      },

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      tileColor: Colors.white,
    );
  }
}