import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDatePicker extends StatelessWidget {
  TaskDatePicker({super.key});

  String formattedDate =
    DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.calendar_today, color: Color.fromARGB(255, 157, 164, 234),),
      title: const Text("Due Date" , style: TextStyle(color:Color.fromARGB(255, 172, 172, 173) ),),
      subtitle: Text(formattedDate),
      onTap: () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: Colors.white,
    );
  }
}